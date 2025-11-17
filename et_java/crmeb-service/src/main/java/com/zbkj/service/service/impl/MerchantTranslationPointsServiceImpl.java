package com.zbkj.service.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zbkj.common.model.translation.MerchantTranslationPoints;
import com.zbkj.service.dao.MerchantTranslationPointsDao;
import com.zbkj.service.service.MerchantTranslationPointsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 商户翻译积分服务实现类
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 */
@Slf4j
@Service
public class MerchantTranslationPointsServiceImpl 
        extends ServiceImpl<MerchantTranslationPointsDao, MerchantTranslationPoints> 
        implements MerchantTranslationPointsService {

    @Resource
    private MerchantTranslationPointsDao dao;

    /**
     * 获取商户翻译积分信息
     * 
     * @param merId 商户ID
     * @return 积分信息
     */
    @Override
    public Map<String, Object> getPointsInfo(Integer merId) {
        Map<String, Object> result = new HashMap<>();
        
        if (merId == null) {
            result.put("totalChars", 0L);
            result.put("usedChars", 0L);
            result.put("remainingChars", 0L);
            result.put("usageRate", 0.0);
            result.put("totalTranslations", 0);
            return result;
        }
        
        try {
            MerchantTranslationPoints points = getOrInitPoints(merId);
            
            long totalChars = points.getTotalChars() != null ? points.getTotalChars() : 0L;
            long usedChars = points.getUsedChars() != null ? points.getUsedChars() : 0L;
            long remainingChars = points.getRemainingChars() != null ? points.getRemainingChars() : 0L;
            int totalTranslations = points.getTotalTranslations() != null ? points.getTotalTranslations() : 0;
            
            // 计算使用率
            double usageRate = totalChars > 0 ? (double) usedChars / totalChars * 100 : 0.0;
            
            result.put("totalChars", totalChars);
            result.put("usedChars", usedChars);
            result.put("remainingChars", remainingChars);
            result.put("usageRate", Math.round(usageRate * 100.0) / 100.0); // 保留两位小数
            result.put("totalTranslations", totalTranslations);
            
            log.debug("获取商户积分信息: merId={}, totalChars={}, usedChars={}, remainingChars={}", 
                     merId, totalChars, usedChars, remainingChars);
            
        } catch (Exception e) {
            log.error("获取商户翻译积分信息失败: merId={}, error={}", merId, e.getMessage(), e);
            // 返回默认值而不是抛出异常
            result.put("totalChars", 0L);
            result.put("usedChars", 0L);
            result.put("remainingChars", 0L);
            result.put("usageRate", 0.0);
            result.put("totalTranslations", 0);
        }
        
        return result;
    }

    /**
     * 初始化或获取商户积分信息
     * 
     * @param merId 商户ID
     * @return 积分信息
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public MerchantTranslationPoints getOrInitPoints(Integer merId) {
        if (merId == null) {
            throw new IllegalArgumentException("商户ID不能为空");
        }
        
        LambdaQueryWrapper<MerchantTranslationPoints> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(MerchantTranslationPoints::getMerId, merId);
        
        MerchantTranslationPoints points = dao.selectOne(wrapper);
        
        if (points == null) {
            // 初始化商户积分信息，默认给予100万字符（100积分）
            points = new MerchantTranslationPoints();
            points.setMerId(merId);
            points.setTotalChars(1000000L); // 默认100万字符
            points.setUsedChars(0L);
            points.setRemainingChars(1000000L);
            points.setTotalTranslations(0);
            points.setLastResetTime(new Date());
            points.setCreateTime(new Date());
            points.setUpdateTime(new Date());
            
            dao.insert(points);
            log.info("初始化商户翻译积分: merId={}, totalChars={}", merId, points.getTotalChars());
        }
        
        return points;
    }

    /**
     * 更新翻译使用量
     * 
     * @param merId 商户ID
     * @param charCount 使用的字符数
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateUsage(Integer merId, Integer charCount) {
        if (merId == null || charCount == null || charCount <= 0) {
            log.warn("更新翻译使用量参数无效: merId={}, charCount={}", merId, charCount);
            return;
        }
        
        try {
            MerchantTranslationPoints points = getOrInitPoints(merId);
            
            long newUsedChars = points.getUsedChars() + charCount;
            long newRemainingChars = Math.max(0, points.getTotalChars() - newUsedChars);
            int newTotalTranslations = points.getTotalTranslations() + 1;
            
            points.setUsedChars(newUsedChars);
            points.setRemainingChars(newRemainingChars);
            points.setTotalTranslations(newTotalTranslations);
            points.setUpdateTime(new Date());
            
            dao.updateById(points);
            
            log.info("更新商户翻译使用量: merId={}, charCount={}, newUsedChars={}, newRemainingChars={}", 
                    merId, charCount, newUsedChars, newRemainingChars);
            
            // 如果剩余字符数不足，记录警告
            if (newRemainingChars < 10000) { // 少于1万字符时警告
                log.warn("商户翻译积分不足: merId={}, remainingChars={}", merId, newRemainingChars);
            }
            
        } catch (Exception e) {
            log.error("更新商户翻译使用量失败: merId={}, charCount={}, error={}", 
                     merId, charCount, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 为商户添加翻译积分
     * 积分规则：1积分 = 10,000字符
     * 
     * @param merId 商户ID
     * @param points 积分数量（1积分 = 10,000字符）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addPoints(Integer merId, Integer points) {
        if (merId == null || points == null || points <= 0) {
            throw new IllegalArgumentException("参数无效: merId=" + merId + ", points=" + points);
        }
        
        try {
            MerchantTranslationPoints merchantPoints = getOrInitPoints(merId);
            
            // 1积分 = 10,000字符
            long addChars = points * 10000L;
            long newTotalChars = merchantPoints.getTotalChars() + addChars;
            long newRemainingChars = merchantPoints.getRemainingChars() + addChars;
            
            merchantPoints.setTotalChars(newTotalChars);
            merchantPoints.setRemainingChars(newRemainingChars);
            merchantPoints.setUpdateTime(new Date());
            
            dao.updateById(merchantPoints);
            
            log.info("为商户添加翻译积分: merId={}, points={}, addChars={}, newTotalChars={}, newRemainingChars={}", 
                    merId, points, addChars, newTotalChars, newRemainingChars);
            
        } catch (Exception e) {
            log.error("为商户添加翻译积分失败: merId={}, points={}, error={}", 
                     merId, points, e.getMessage(), e);
            throw e;
        }
    }
}



