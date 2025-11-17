package com.zbkj.service.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zbkj.common.constants.RedisConstants;
import com.zbkj.common.exception.CrmebException;
import com.zbkj.common.model.translation.Translation;
import com.zbkj.common.model.translation.TranslationCache;
import com.zbkj.common.utils.MessageUtils;
import com.zbkj.common.utils.RedisUtil;
import com.zbkj.service.dao.TranslationDao;
import com.zbkj.service.service.TranslationCacheService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.request.BatchTranslateRequest;
import com.zbkj.common.request.PageParamRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.Set;
import java.util.HashSet;
import java.util.concurrent.locks.ReentrantLock;

/**
 * 翻译服务实现类（带缓存机制）
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 */
@Service
public class TranslationServiceImpl extends ServiceImpl<TranslationDao, Translation> 
        implements com.zbkj.service.service.TranslationService {

    private static final Logger LOGGER = LoggerFactory.getLogger(TranslationServiceImpl.class);

    @Resource
    private TranslationDao dao;

    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private com.zbkj.common.service.TranslationService commonTranslationService;

    @Autowired(required = false)
    private TranslationCacheService translationCacheService;

    @Autowired(required = false)
    private com.zbkj.service.service.MerchantTranslationPointsService merchantTranslationPointsService;

    @Autowired
    private AsyncTranslationQueueService asyncTranslationQueueService;

    /**
     * 翻译请求同步锁：确保同一时间只有一个翻译请求在执行
     * 注意：现在主要使用异步队列服务，这个锁作为备用
     */
    private final ReentrantLock translationLock = new ReentrantLock();

    /**
     * 上次翻译请求的时间戳（用于计算间隔）
     */
    private volatile long lastTranslationTime = 0;

    /**
     * 翻译请求之间的最小间隔（毫秒）
     * 百度翻译API限制：
     * - 免费版/标准版：1 QPS（每秒1次）
     * - 高级版：10 QPS（每秒10次，即100ms间隔）
     * - 尊享版：100 QPS（每秒100次，即10ms间隔）
     * 
     * 由于频繁出现54003错误，增加到1500ms间隔（0.67 QPS），确保稳定性
     * 这样可以避免网络延迟和服务器处理时间导致的频率限制问题
     * 适用于标准版账户，提供足够的安全边际
     */
    private static final long TRANSLATION_INTERVAL_MS = 1500;

    /**
     * 获取翻译（带缓存机制）
     * 1. 先查Redis缓存
     * 2. 再查数据库缓存表
     * 3. 再查翻译存储表
     * 4. 都没有则调用翻译API
     */
    @Override
    public String getTranslation(String entityType, Integer entityId, String fieldName, 
                                 String targetLanguage, String sourceText, Integer merId) {
        if (StrUtil.isBlank(sourceText)) {
            return sourceText;
        }

        // 如果是中文或源语言，直接返回原文
        if ("zh-CN".equals(targetLanguage)) {
            return sourceText;
        }

        // 1. 先查Redis缓存
        String cacheKey = generateCacheKey(sourceText, targetLanguage);
        String redisCache = redisUtil.get(RedisConstants.TRANSLATION_CACHE_PREFIX + cacheKey);
        if (StrUtil.isNotBlank(redisCache)) {
            // 更新命中次数
            incrementCacheHit(cacheKey);
            return redisCache;
        }

        // 2. 查数据库缓存表
        if (translationCacheService != null) {
            TranslationCache dbCache = translationCacheService.getByCacheKey(cacheKey);
            if (ObjectUtil.isNotNull(dbCache) && 
                dbCache.getExpireTime() != null && 
                dbCache.getExpireTime().after(new Date())) {
                // 存入Redis
                redisUtil.set(RedisConstants.TRANSLATION_CACHE_PREFIX + cacheKey, 
                             dbCache.getTranslatedText(), 
                             Long.valueOf(24L), TimeUnit.HOURS);
                return dbCache.getTranslatedText();
            }
        }

        // 3. 查翻译存储表（如果有entityId）
        if (ObjectUtil.isNotNull(entityId)) {
            LambdaQueryWrapper<Translation> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Translation::getEntityType, entityType)
                   .eq(Translation::getEntityId, entityId)
                   .eq(Translation::getFieldName, fieldName)
                   .eq(Translation::getTargetLanguage, targetLanguage)
                   .last("limit 1");
            Translation translation = dao.selectOne(wrapper);
            if (ObjectUtil.isNotNull(translation)) {
                // 存入Redis缓存
                redisUtil.set(RedisConstants.TRANSLATION_CACHE_PREFIX + cacheKey, 
                             translation.getTranslatedText(), 
                             Long.valueOf(24L), TimeUnit.HOURS);
                // 存入数据库缓存表
                saveToCacheTable(cacheKey, sourceText, targetLanguage, translation.getTranslatedText());
                return translation.getTranslatedText();
            }
        }

        // 4. 调用翻译API（优先使用百度翻译，国内商户推荐）
        String translatedText = null;
        try {
            // 优先尝试百度翻译（国内推荐）
            translatedText = commonTranslationService.translateWithBaidu(
                sourceText, targetLanguage, "zh-CN");
            // 如果百度翻译失败或返回原文，尝试Google翻译作为备用
            if (StrUtil.isBlank(translatedText) || sourceText.equals(translatedText)) {
                translatedText = commonTranslationService.translateWithGoogle(
                    sourceText, targetLanguage, "zh-CN");
            }
        } catch (Exception e) {
            // 如果百度翻译异常，使用Google翻译
            LOGGER.warn("百度翻译失败，使用Google翻译: {}", e.getMessage());
            translatedText = commonTranslationService.translateWithGoogle(
                sourceText, targetLanguage, "zh-CN");
        }

        if (StrUtil.isNotBlank(translatedText) && !sourceText.equals(translatedText)) {
            // 保存到Redis
            redisUtil.set(RedisConstants.TRANSLATION_CACHE_PREFIX + cacheKey, 
                         translatedText, 
                         Long.valueOf(24L), TimeUnit.HOURS);

            // 保存到数据库缓存表
            saveToCacheTable(cacheKey, sourceText, targetLanguage, translatedText);

            // 如果提供了entityId，保存到翻译存储表
            if (ObjectUtil.isNotNull(entityId)) {
                LOGGER.info("准备保存翻译到Translation表: entityType={}, entityId={}, fieldName={}, targetLanguage={}", 
                          entityType, entityId, fieldName, targetLanguage);
                saveTranslation(entityType, entityId, fieldName, targetLanguage, 
                              sourceText, translatedText, merId);
                LOGGER.info("已保存翻译到Translation表: entityType={}, entityId={}, fieldName={}, targetLanguage={}", 
                          entityType, entityId, fieldName, targetLanguage);
            } else {
                LOGGER.warn("entityId为null，未保存到Translation表: entityType={}, fieldName={}, targetLanguage={}", 
                          entityType, fieldName, targetLanguage);
            }
        }

        return StrUtil.isNotBlank(translatedText) ? translatedText : sourceText;
    }

    /**
     * 仅从缓存和数据库获取翻译（不调用API）
     * 用于用户访问时的翻译查询，只读取已翻译的数据
     */
    @Override
    public String getCachedTranslation(String entityType, Integer entityId, String fieldName, 
                                       String targetLanguage, String sourceText, Integer merId) {
        if (StrUtil.isBlank(sourceText)) {
            return sourceText;
        }

        // 如果是中文或源语言，直接返回原文
        if ("zh-CN".equals(targetLanguage)) {
            return sourceText;
        }

        // 1. 先查Redis缓存
        String cacheKey = generateCacheKey(sourceText, targetLanguage);
        LOGGER.info("🔍 getCachedTranslation - 参数: entityType={}, entityId={}, fieldName={}, targetLanguage={}, sourceText={}, cacheKey={}", 
                   entityType, entityId, fieldName, targetLanguage, sourceText, cacheKey);
        
        String redisCache = redisUtil.get(RedisConstants.TRANSLATION_CACHE_PREFIX + cacheKey);
        if (StrUtil.isNotBlank(redisCache)) {
            LOGGER.info("✅ Redis缓存命中: cacheKey={}, translatedText={}", cacheKey, redisCache);
            // 更新命中次数
            incrementCacheHit(cacheKey);
            return redisCache;
        }
        LOGGER.info("❌ Redis缓存未命中: cacheKey={}", cacheKey);

        // 2. 查数据库缓存表
        if (translationCacheService != null) {
            TranslationCache dbCache = translationCacheService.getByCacheKey(cacheKey);
            if (ObjectUtil.isNotNull(dbCache) && 
                dbCache.getExpireTime() != null && 
                dbCache.getExpireTime().after(new Date())) {
                LOGGER.info("✅ 数据库缓存表命中: cacheKey={}, translatedText={}, targetLanguage={}", 
                           cacheKey, dbCache.getTranslatedText(), dbCache.getTargetLanguage());
                // 存入Redis
                redisUtil.set(RedisConstants.TRANSLATION_CACHE_PREFIX + cacheKey, 
                             dbCache.getTranslatedText(), 
                             Long.valueOf(24L), TimeUnit.HOURS);
                return dbCache.getTranslatedText();
            } else {
                LOGGER.info("❌ 数据库缓存表未命中或已过期: cacheKey={}, dbCache={}", cacheKey, dbCache);
            }
        }

        // 3. 查翻译存储表（如果有entityId）- 这是商户上传商品时翻译存储的表
        if (ObjectUtil.isNotNull(entityId)) {
            LambdaQueryWrapper<Translation> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Translation::getEntityType, entityType)
                   .eq(Translation::getEntityId, entityId)
                   .eq(Translation::getFieldName, fieldName)
                   .eq(Translation::getTargetLanguage, targetLanguage)
                   .last("limit 1");
            Translation translation = dao.selectOne(wrapper);
            if (ObjectUtil.isNotNull(translation)) {
                LOGGER.debug("从Translation表查询到翻译: entityType={}, entityId={}, fieldName={}, targetLanguage={}, translatedText={}", 
                           entityType, entityId, fieldName, targetLanguage, translation.getTranslatedText());
                // 存入Redis缓存
                redisUtil.set(RedisConstants.TRANSLATION_CACHE_PREFIX + cacheKey, 
                             translation.getTranslatedText(), 
                             Long.valueOf(24L), TimeUnit.HOURS);
                // 存入数据库缓存表
                saveToCacheTable(cacheKey, sourceText, targetLanguage, translation.getTranslatedText());
                return translation.getTranslatedText();
            } else {
                LOGGER.debug("Translation表查询未找到: entityType={}, entityId={}, fieldName={}, targetLanguage={}", 
                           entityType, entityId, fieldName, targetLanguage);
            }
        }

        // 4. 如果都找不到，返回原文（不调用API）
        return sourceText;
    }

    /**
     * 批量翻译（优化版：优先查询缓存，只翻译未缓存的内容）
     * 优化策略：
     * 1. 批量查询所有文本的缓存（Redis + 数据库缓存表）
     * 2. 只对未缓存的内容调用翻译API
     * 3. 将新翻译结果存入缓存
     * 4. 返回所有翻译结果（包括缓存的和新翻译的）
     */
    @Override
    // 移除 @Transactional 注解，避免与内部保存操作的事务冲突
    // 翻译和缓存操作不需要强事务控制，每个保存操作内部会处理自己的事务
    public Map<String, Map<String, String>> batchTranslate(
            BatchTranslateRequest request, Integer merId) {
        Map<String, Map<String, String>> result = new HashMap<>();
        
        if (request == null || request.getFields() == null || request.getFields().isEmpty()) {
            return result;
        }
        
        List<String> targetLanguages = request.getTargetLanguages();
        if (CollUtil.isEmpty(targetLanguages)) {
            return result;
        }
        
        // 1. 批量查询缓存（提高效率）
        Map<String, Map<String, String>> cachedResults = new HashMap<>();
        for (Map.Entry<String, String> entry : request.getFields().entrySet()) {
            String fieldName = entry.getKey();
            String sourceText = entry.getValue();
            
            // 跳过不需要翻译的字段：容量和尺寸
            if ("capacity".equals(fieldName) || "size".equals(fieldName)) {
                continue;
            }
            
            if (StrUtil.isBlank(sourceText)) {
                continue;
            }
            
            Map<String, String> langMap = new HashMap<>();
            for (String targetLang : targetLanguages) {
                // 跳过中文
                if ("zh-CN".equals(targetLang)) {
                    langMap.put(targetLang, sourceText);
                    continue;
                }
                
                // 查询缓存（Redis -> 数据库缓存表）
                String cacheKey = generateCacheKey(sourceText, targetLang);
                String cached = redisUtil.get(RedisConstants.TRANSLATION_CACHE_PREFIX + cacheKey);
                
                if (StrUtil.isBlank(cached) && translationCacheService != null) {
                    TranslationCache dbCache = translationCacheService.getByCacheKey(cacheKey);
                    if (ObjectUtil.isNotNull(dbCache) && 
                        dbCache.getExpireTime() != null && 
                        dbCache.getExpireTime().after(new Date())) {
                        cached = dbCache.getTranslatedText();
                        // 存入Redis
                        redisUtil.set(RedisConstants.TRANSLATION_CACHE_PREFIX + cacheKey, 
                                     cached, 
                                     Long.valueOf(24L), TimeUnit.HOURS);
                    }
                }
                
                if (StrUtil.isNotBlank(cached)) {
                    langMap.put(targetLang, cached);
                    incrementCacheHit(cacheKey);
                }
            }
            cachedResults.put(fieldName, langMap);
        }
        
        // 2. 只翻译未缓存的内容，并统计实际消耗的字符数
        int totalConsumedChars = 0; // 实际消耗的字符数（不包括缓存命中的）
        
        for (Map.Entry<String, String> entry : request.getFields().entrySet()) {
            String fieldName = entry.getKey();
            String sourceText = entry.getValue();
            
            // 跳过不需要翻译的字段：容量和尺寸
            if ("capacity".equals(fieldName) || "size".equals(fieldName)) {
                continue;
            }
            
            if (StrUtil.isBlank(sourceText)) {
                continue;
            }
            
            Map<String, String> langMap = cachedResults.getOrDefault(fieldName, new HashMap<>());
            
            // 统计该字段需要翻译的语言数量（用于进度显示）
            int totalLangCount = 0;
            int translatedLangCount = 0;
            for (String targetLang : targetLanguages) {
                if (!"zh-CN".equals(targetLang) && !langMap.containsKey(targetLang)) {
                    totalLangCount++;
                }
            }
            
            for (String targetLang : targetLanguages) {
                // 跳过中文和已有缓存的（缓存命中不计费）
                if ("zh-CN".equals(targetLang) || langMap.containsKey(targetLang)) {
                    continue;
                }
                
                // 调用翻译API（这里会消耗字符）- 使用同步排队机制
                String translatedText = null;
                boolean retryAfterDelay = false;
                try {
                    LOGGER.info("开始翻译: fieldName={}, sourceText={}, targetLang={}, merId={}, 进度={}/{}", 
                              fieldName, sourceText, targetLang, merId, translatedLangCount + 1, totalLangCount);
                    
                    // 使用同步排队机制，确保同一时间只有一个翻译请求在执行
                    translatedText = executeTranslationWithQueue(sourceText, targetLang, fieldName);
                    
                    LOGGER.debug("翻译结果: sourceText={}, translatedText={}, targetLang={}", 
                               sourceText, translatedText, targetLang);
                    
                } catch (Exception e) {
                    LOGGER.error("翻译异常: fieldName={}, sourceText={}, targetLang={}, error={}", 
                               fieldName, sourceText, targetLang, e.getMessage(), e);
                    translatedText = null;
                    // 如果异常信息中包含频率限制相关错误，标记需要延迟
                    if (e.getMessage() != null && 
                        (e.getMessage().contains("54003") || e.getMessage().contains("频率限制") || 
                         e.getMessage().contains("Invalid Access Limit"))) {
                        retryAfterDelay = true;
                    }
                }
                
                // 如果检测到频率限制错误，增加额外延迟
                if (retryAfterDelay) {
                    try {
                        long extraDelay = 10000; // 频率限制错误后额外延迟10秒，确保API恢复
                        LOGGER.warn("检测到频率限制错误(54003)，额外延迟 {}ms 后继续: fieldName={}, targetLang={}", 
                                  extraDelay, fieldName, targetLang);
                        Thread.sleep(extraDelay);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        LOGGER.warn("延迟被中断");
                    }
                }
                
                // 只有翻译成功（非空且不等于原文）才统计字符消耗和保存结果
                if (StrUtil.isNotBlank(translatedText) && !sourceText.equals(translatedText)) {
                    // 统计消耗的字符数（只计算实际调用API的）
                    totalConsumedChars += sourceText.length();
                    LOGGER.info("翻译成功，消耗字符数: sourceText={}, charCount={}, totalConsumed={}", 
                              sourceText, sourceText.length(), totalConsumedChars);
                    
                    String cacheKey = generateCacheKey(sourceText, targetLang);
                    
                    // 存入Redis
                    redisUtil.set(RedisConstants.TRANSLATION_CACHE_PREFIX + cacheKey, 
                                 translatedText, 
                                 Long.valueOf(24L), TimeUnit.HOURS);
                    
                    // 存入数据库缓存表
                    saveToCacheTable(cacheKey, sourceText, targetLang, translatedText);
                    LOGGER.info("已保存到缓存表: cacheKey={}, fieldName={}", cacheKey, fieldName);
                    
                    // 如果提供了entityId，保存到Translation表
                    if (ObjectUtil.isNotNull(request.getEntityId())) {
                        // 判断字段类型：规格字段使用 product_attr_value，商品字段使用 product
                        String entityType = request.getEntityType();
                        // 规格字段：product_name, material, origin（容量和尺寸不翻译）
                        if ("product_name".equals(fieldName) || "material".equals(fieldName) || "origin".equals(fieldName)) {
                            entityType = "product_attr_value";
                        }
                        
                        saveTranslation(entityType, request.getEntityId(), 
                                      fieldName, targetLang, sourceText, translatedText, merId);
                        LOGGER.info("已保存到Translation表: entityType={}, entityId={}, fieldName={}", 
                                  entityType, request.getEntityId(), fieldName);
                    } else {
                        LOGGER.warn("entityId为null，未保存到Translation表: fieldName={}", fieldName);
                    }
                    
                    langMap.put(targetLang, translatedText);
                    translatedLangCount++;
                } else {
                    // 翻译失败，不统计字符消耗，不保存结果，返回原文
                    LOGGER.warn("翻译失败，不统计字符消耗: fieldName={}, sourceText={}, translatedText={}, targetLang={}", 
                              fieldName, sourceText, translatedText, targetLang);
                    langMap.put(targetLang, sourceText); // 返回原文
                    translatedLangCount++;
                }
                
                // 注意：不需要额外延迟，因为 executeTranslationWithQueue 已经保证了最小间隔
                // 额外的延迟会导致批量翻译变慢
            }
            
            result.put(fieldName, langMap);
            
            // 每翻译完一个字段的所有语言后，添加额外延迟（避免批量翻译时请求过快）
            LOGGER.debug("字段 {} 翻译完成，共 {} 种语言", fieldName, totalLangCount);
        }
        
        // 3. 更新商户翻译积分使用情况（只统计实际调用API消耗的字符数）
        LOGGER.info("批量翻译完成: merId={}, totalConsumedChars={}, resultSize={}", 
                   merId, totalConsumedChars, result.size());
        
        if (totalConsumedChars > 0 && ObjectUtil.isNotNull(merId) && merchantTranslationPointsService != null) {
            try {
                merchantTranslationPointsService.updateUsage(merId, totalConsumedChars);
                LOGGER.info("更新商户翻译积分使用情况: merId={}, consumedChars={}", merId, totalConsumedChars);
            } catch (Exception e) {
                // 积分更新失败不影响翻译结果返回
                LOGGER.error("更新商户翻译积分失败: merId={}, consumedChars={}, error={}", 
                           merId, totalConsumedChars, e.getMessage(), e);
            }
        } else {
            if (totalConsumedChars == 0) {
                LOGGER.warn("未消耗字符数，可能所有内容都来自缓存: merId={}", merId);
            }
            if (merId == null) {
                LOGGER.warn("merId为null，无法更新积分使用情况");
            }
            if (merchantTranslationPointsService == null) {
                LOGGER.warn("merchantTranslationPointsService为null，无法更新积分使用情况");
            }
        }
        
        return result;
    }

    /**
     * 执行翻译（使用异步队列机制）
     * 新版本使用异步队列服务，彻底解决频率限制问题
     * 
     * @param sourceText 源文本
     * @param targetLang 目标语言
     * @param fieldName 字段名称（用于日志）
     * @return 翻译后的文本
     */
    private String executeTranslationWithQueue(String sourceText, String targetLang, String fieldName) {
        try {
            // 使用异步队列服务进行翻译
            CompletableFuture<String> future = asyncTranslationQueueService.submitTranslation(
                sourceText, targetLang, "zh-CN", fieldName);
            
            // 等待翻译完成（最多等待30秒）
            String translatedText = future.get(30, TimeUnit.SECONDS);
            
            LOGGER.debug("异步队列翻译结果: sourceText={}, translatedText={}, fieldName={}", 
                       sourceText, translatedText, fieldName);
            
            return translatedText;
            
        } catch (TimeoutException e) {
            LOGGER.error("翻译超时: fieldName={}, sourceText={}, targetLang={}", fieldName, sourceText, targetLang);
            return sourceText; // 超时返回原文
        } catch (Exception e) {
            LOGGER.error("异步翻译异常: fieldName={}, sourceText={}, targetLang={}, error={}", 
                       fieldName, sourceText, targetLang, e.getMessage(), e);
            return sourceText; // 异常返回原文
        }
    }

    /**
     * 执行翻译（旧版同步方法，作为备用）
     * 保留原有的同步翻译逻辑作为备用方案
     */
    private String executeTranslationWithQueueSync(String sourceText, String targetLang, String fieldName) {
        // 获取锁，确保同一时间只有一个翻译请求在执行
        translationLock.lock();
        try {
            // 计算距离上次请求的时间间隔
            long currentTime = System.currentTimeMillis();
            long timeSinceLastRequest = currentTime - lastTranslationTime;
            
            // 如果距离上次请求的时间小于最小间隔，则等待
            if (timeSinceLastRequest < TRANSLATION_INTERVAL_MS) {
                long waitTime = TRANSLATION_INTERVAL_MS - timeSinceLastRequest;
                LOGGER.debug("等待 {}ms 以避免频率限制: fieldName={}, targetLang={}", 
                           waitTime, fieldName, targetLang);
                try {
                    Thread.sleep(waitTime);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    LOGGER.warn("等待被中断: {}", e.getMessage());
                    return null;
                }
            }
            
            // 执行翻译
            String translatedText = null;
            
            try {
                // 只使用百度翻译，注释掉Google翻译避免混乱
                translatedText = commonTranslationService.translateWithBaidu(
                    sourceText, targetLang, "zh-CN");
                
                LOGGER.debug("百度翻译结果: sourceText={}, translatedText={}", sourceText, translatedText);
                
                // 注释掉Google翻译部分，避免混乱
                /*
                // 如果百度翻译失败或返回原文，尝试Google翻译
                if (StrUtil.isBlank(translatedText) || sourceText.equals(translatedText)) {
                    LOGGER.warn("百度翻译返回空或原文，尝试Google翻译: sourceText={}", sourceText);
                    translatedText = commonTranslationService.translateWithGoogle(
                        sourceText, targetLang, "zh-CN");
                    LOGGER.debug("Google翻译结果: sourceText={}, translatedText={}", sourceText, translatedText);
                }
                */
            } catch (Exception e) {
                LOGGER.error("翻译API调用异常: {}", e.getMessage(), e);
                // 注释掉Google翻译备用逻辑
                /*
                // 如果百度翻译异常，尝试Google翻译
                try {
                    translatedText = commonTranslationService.translateWithGoogle(
                        sourceText, targetLang, "zh-CN");
                    LOGGER.debug("Google翻译(异常后)结果: sourceText={}, translatedText={}", sourceText, translatedText);
                } catch (Exception e2) {
                    LOGGER.error("Google翻译也失败: {}", e2.getMessage(), e2);
                    translatedText = null;
                }
                */
                translatedText = null;
            }
            
            // 在翻译完成后更新上次请求时间（包括重试时间）
            // 这样可以确保下一次请求能够正确计算间隔
            lastTranslationTime = System.currentTimeMillis();
            
            return translatedText;
            
        } finally {
            // 释放锁，允许下一个请求执行
            translationLock.unlock();
        }
    }

    /**
     * 批量翻译商品信息
     */
    @Override
    // 移除 @Transactional 注解，避免与内部保存操作的事务冲突
    public void batchTranslateProduct(Integer productId, String storeName, String storeInfo, 
                                     String keyword, String content, String[] targetLanguages, Integer merId) {
        if (ObjectUtil.isNull(productId) || CollUtil.isEmpty(Arrays.asList(targetLanguages))) {
            return;
        }

        List<Translation> translations = new ArrayList<>();

        for (String lang : targetLanguages) {
            // 翻译商品名称
            if (StrUtil.isNotBlank(storeName)) {
                String translatedName = getTranslation("product", productId, "storeName", 
                                                      lang, storeName, merId);
                Translation nameTranslation = new Translation();
                nameTranslation.setEntityType("product")
                              .setEntityId(productId)
                              .setFieldName("storeName")
                              .setSourceLanguage("zh-CN")
                              .setTargetLanguage(lang)
                              .setSourceText(storeName)
                              .setTranslatedText(translatedName)
                              .setCharCount(storeName.length())
                              .setMerId(merId);
                translations.add(nameTranslation);
            }

            // 翻译商品描述
            if (StrUtil.isNotBlank(storeInfo)) {
                String translatedInfo = getTranslation("product", productId, "storeInfo", 
                                                      lang, storeInfo, merId);
                Translation infoTranslation = new Translation();
                infoTranslation.setEntityType("product")
                              .setEntityId(productId)
                              .setFieldName("storeInfo")
                              .setSourceLanguage("zh-CN")
                              .setTargetLanguage(lang)
                              .setSourceText(storeInfo)
                              .setTranslatedText(translatedInfo)
                              .setCharCount(storeInfo.length())
                              .setMerId(merId);
                translations.add(infoTranslation);
            }

            // 翻译关键字
            if (StrUtil.isNotBlank(keyword)) {
                String translatedKeyword = getTranslation("product", productId, "keyword", 
                                                         lang, keyword, merId);
                Translation keywordTranslation = new Translation();
                keywordTranslation.setEntityType("product")
                                 .setEntityId(productId)
                                 .setFieldName("keyword")
                                 .setSourceLanguage("zh-CN")
                                 .setTargetLanguage(lang)
                                 .setSourceText(keyword)
                                 .setTranslatedText(translatedKeyword)
                                 .setCharCount(keyword.length())
                                 .setMerId(merId);
                translations.add(keywordTranslation);
            }
            
            // 翻译商品详情内容（HTML富文本）
            if (StrUtil.isNotBlank(content)) {
                // 去除HTML标签，只翻译纯文本内容
                String plainText = content.replaceAll("<[^>]+>", "").trim();
                
                if (StrUtil.isNotBlank(plainText)) {
                    String translatedPlainText = getTranslation("product", productId, "content", 
                                                             lang, plainText, merId);
                    
                    // 将翻译后的纯文本替换回HTML中
                    String translatedContent = content.replaceAll(">([^<]+)<", ">" + translatedPlainText + "<");
                    
                    Translation contentTranslation = new Translation();
                    contentTranslation.setEntityType("product")
                                     .setEntityId(productId)
                                     .setFieldName("content")
                                     .setSourceLanguage("zh-CN")
                                     .setTargetLanguage(lang)
                                     .setSourceText(plainText)  // 存储纯文本
                                     .setTranslatedText(translatedPlainText)  // 存储纯文本翻译
                                     .setCharCount(plainText.length())
                                     .setMerId(merId);
                    translations.add(contentTranslation);
                    LOGGER.info("商品详情内容翻译完成: productId={}, lang={}, plainTextLength={}", 
                              productId, lang, plainText.length());
                }
            }
        }

        // 批量保存或更新
        if (CollUtil.isNotEmpty(translations)) {
            for (Translation translation : translations) {
                LambdaQueryWrapper<Translation> wrapper = Wrappers.lambdaQuery();
                wrapper.eq(Translation::getEntityType, translation.getEntityType())
                       .eq(Translation::getEntityId, translation.getEntityId())
                       .eq(Translation::getFieldName, translation.getFieldName())
                       .eq(Translation::getTargetLanguage, translation.getTargetLanguage());
                Translation exist = dao.selectOne(wrapper);
                if (ObjectUtil.isNotNull(exist)) {
                    translation.setId(exist.getId());
                    dao.updateById(translation);
                } else {
                    translation.setCacheKey(generateCacheKey(translation.getSourceText(), 
                                                            translation.getTargetLanguage()));
                    translation.setIsCached(true);
                    dao.insert(translation);
                }
            }
        }
    }

    /**
     * 生成缓存键
     */
    private String generateCacheKey(String sourceText, String targetLanguage) {
        // 使用标准语言代码生成缓存键（确保与前端一致）
        String standardLang = convertToStandardLanguageCode(targetLanguage);
        String text = sourceText + "_" + standardLang;
        return SecureUtil.md5(text);
    }

    /**
     * 将百度语言代码转换回前端标准代码
     * 这样确保存储到数据库的语言代码与前端i18n一致
     */
    private String convertToStandardLanguageCode(String baiduCode) {
        if (StrUtil.isBlank(baiduCode)) {
            return baiduCode;
        }
        
        String code = baiduCode.toLowerCase().trim();
        
        // 百度代码 -> 前端标准代码
        switch (code) {
            case "kor": return "ko";    // 韩语
            case "jp": return "ja";     // 日语
            case "ara": return "ar";    // 阿拉伯语
            case "fra": return "fr";    // 法语
            default: return code;       // 其他语言保持不变
        }
    }

    /**
     * 保存到缓存表
     */
    private void saveToCacheTable(String cacheKey, String sourceText, 
                                  String targetLanguage, String translatedText) {
        if (translationCacheService == null) {
            return;
        }
        try {
            // 确保使用标准语言代码存储（与前端i18n一致）
            String standardLang = convertToStandardLanguageCode(targetLanguage);
            
            TranslationCache cache = new TranslationCache();
            cache.setCacheKey(cacheKey)
                 .setSourceTextHash(SecureUtil.md5(sourceText))
                 .setTargetLanguage(standardLang)  // 使用标准代码
                 .setTranslatedText(translatedText)
                 .setHitCount(0);
            
            // 设置过期时间（30天后）- 翻译内容相对稳定，可以长期缓存
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DAY_OF_MONTH, 30);
            cache.setExpireTime(calendar.getTime());

            translationCacheService.saveOrUpdate(cache);
        } catch (Exception e) {
            // 缓存保存失败不影响主流程
            System.err.println("保存翻译缓存失败: " + e.getMessage());
        }
    }

    /**
     * 更新缓存命中次数
     */
    private void incrementCacheHit(String cacheKey) {
        // 异步更新命中次数，不影响主流程
        try {
            if (translationCacheService != null) {
                translationCacheService.incrementHitCount(cacheKey);
            }
        } catch (Exception e) {
            // 忽略错误
        }
    }

    /**
     * 保存翻译到存储表
     */
    private void saveTranslation(String entityType, Integer entityId, String fieldName,
                                String targetLanguage, String sourceText, 
                                String translatedText, Integer merId) {
        try {
            // 确保使用标准语言代码存储（与前端i18n一致）
            String standardLang = convertToStandardLanguageCode(targetLanguage);
            
            LOGGER.info("saveTranslation开始: entityType={}, entityId={}, fieldName={}, targetLanguage={} -> standardLang={}", 
                       entityType, entityId, fieldName, targetLanguage, standardLang);
            
            Translation translation = new Translation();
            translation.setEntityType(entityType)
                      .setEntityId(entityId)
                      .setFieldName(fieldName)
                      .setSourceLanguage("zh-CN")
                      .setTargetLanguage(standardLang)  // 使用标准代码
                      .setSourceText(sourceText)
                      .setTranslatedText(translatedText)
                      .setCharCount(sourceText.length())
                      .setCacheKey(generateCacheKey(sourceText, targetLanguage))
                      .setIsCached(true)
                      .setMerId(merId)
                      .setTranslationProvider("baidu");

            // 检查是否已存在（使用标准语言代码查询）
            LambdaQueryWrapper<Translation> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Translation::getEntityType, entityType)
                   .eq(Translation::getEntityId, entityId)
                   .eq(Translation::getFieldName, fieldName)
                   .eq(Translation::getTargetLanguage, standardLang);  // 使用标准代码查询
            Translation exist = dao.selectOne(wrapper);
            if (ObjectUtil.isNotNull(exist)) {
                translation.setId(exist.getId());
                LOGGER.info("更新已存在的翻译: id={}", exist.getId());
                dao.updateById(translation);
            } else {
                LOGGER.info("插入新翻译记录");
                dao.insert(translation);
            }
            LOGGER.info("saveTranslation成功: entityType={}, entityId={}, fieldName={}, targetLanguage={}", 
                      entityType, entityId, fieldName, targetLanguage);
        } catch (Exception e) {
            LOGGER.error("保存翻译失败: entityType={}, entityId={}, fieldName={}, targetLanguage={}, error={}", 
                       entityType, entityId, fieldName, targetLanguage, e.getMessage(), e);
        }
    }

    /**
     * 分页查询翻译列表
     */
    @Override
    public PageInfo<Translation> getTranslationList(String entityType, Integer entityId, 
                                                     String targetLanguage, Integer merId, 
                                                     PageParamRequest pageParamRequest) {
        PageHelper.startPage(pageParamRequest.getPage(), pageParamRequest.getLimit());
        
        LambdaQueryWrapper<Translation> wrapper = Wrappers.lambdaQuery();
        if (StrUtil.isNotBlank(entityType)) {
            wrapper.eq(Translation::getEntityType, entityType);
        }
        if (ObjectUtil.isNotNull(entityId)) {
            wrapper.eq(Translation::getEntityId, entityId);
        }
        if (StrUtil.isNotBlank(targetLanguage)) {
            wrapper.eq(Translation::getTargetLanguage, targetLanguage);
        }
        if (ObjectUtil.isNotNull(merId)) {
            wrapper.eq(Translation::getMerId, merId);
        }
        wrapper.orderByDesc(Translation::getCreateTime);
        
        List<Translation> list = dao.selectList(wrapper);
        return new PageInfo<>(list);
    }

    /**
     * 获取翻译统计信息
     */
    @Override
    public Map<String, Object> getStatistics(Integer merId) {
        Map<String, Object> result = new HashMap<>();
        
        LambdaQueryWrapper<Translation> wrapper = Wrappers.lambdaQuery();
        if (ObjectUtil.isNotNull(merId)) {
            wrapper.eq(Translation::getMerId, merId);
        }
        
        // 查询所有翻译记录
        List<Translation> allTranslations = dao.selectList(wrapper);
        
        // 总翻译数
        int totalCount = allTranslations.size();
        result.put("totalCount", totalCount);
        
        // 按语言统计
        Map<String, Integer> langCountMap = new HashMap<>();
        Set<String> languages = new HashSet<>();
        for (Translation t : allTranslations) {
            if (StrUtil.isNotBlank(t.getTargetLanguage())) {
                languages.add(t.getTargetLanguage());
            }
        }
        for (String lang : languages) {
            LambdaQueryWrapper<Translation> langWrapper = Wrappers.lambdaQuery();
            langWrapper.eq(Translation::getTargetLanguage, lang);
            if (ObjectUtil.isNotNull(merId)) {
                langWrapper.eq(Translation::getMerId, merId);
            }
            langCountMap.put(lang, dao.selectCount(langWrapper).intValue());
        }
        result.put("langStatistics", langCountMap);
        
        // 按实体类型统计
        Map<String, Integer> entityCountMap = new HashMap<>();
        Set<String> entityTypes = new HashSet<>();
        for (Translation t : allTranslations) {
            if (StrUtil.isNotBlank(t.getEntityType())) {
                entityTypes.add(t.getEntityType());
            }
        }
        for (String entityType : entityTypes) {
            LambdaQueryWrapper<Translation> entityWrapper = Wrappers.lambdaQuery();
            entityWrapper.eq(Translation::getEntityType, entityType);
            if (ObjectUtil.isNotNull(merId)) {
                entityWrapper.eq(Translation::getMerId, merId);
            }
            entityCountMap.put(entityType, dao.selectCount(entityWrapper).intValue());
        }
        result.put("entityStatistics", entityCountMap);
        
        // 总字符数
        long totalChars = 0;
        for (Translation t : allTranslations) {
            if (t.getCharCount() != null) {
                totalChars += t.getCharCount();
            }
        }
        result.put("totalChars", totalChars);
        
        return result;
    }
}




