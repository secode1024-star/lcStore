package com.zbkj.service.service.impl;

import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.exception.CrmebException;
import com.zbkj.common.model.translation.TranslationFailureRecord;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.service.dao.TranslationFailureRecordDao;
import com.zbkj.service.service.TranslationFailureRecordService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 翻译失败记录服务实现类
 */
@Slf4j
@Service
public class TranslationFailureRecordServiceImpl extends ServiceImpl<TranslationFailureRecordDao, TranslationFailureRecord>
        implements TranslationFailureRecordService {

    @Autowired
    private TranslationFailureRecordDao dao;

    @Autowired
    private com.zbkj.service.service.TranslationService translationService;

    @Override
    public void recordFailure(String entityType, Integer entityId, String fieldName,
                             String sourceLanguage, String targetLanguage, String sourceText,
                             String failureReason, Integer retryCount, Integer maxRetries, Integer merId) {
        try {
            TranslationFailureRecord record = new TranslationFailureRecord();
            record.setEntityType(entityType);
            record.setEntityId(entityId);
            record.setFieldName(fieldName);
            record.setSourceLanguage(sourceLanguage);
            record.setTargetLanguage(targetLanguage);
            record.setSourceText(sourceText);
            record.setFailureReason(failureReason);
            record.setRetryCount(retryCount);
            record.setMaxRetries(maxRetries);
            record.setStatus("pending"); // 待重试
            record.setMerId(merId);
            record.setCreateTime(new Date());
            record.setUpdateTime(new Date());

            save(record);
            log.info("记录翻译失败: entityType={}, entityId={}, fieldName={}, targetLang={}, merId={}",
                    entityType, entityId, fieldName, targetLanguage, merId);
        } catch (Exception e) {
            log.error("记录翻译失败异常: {}", e.getMessage(), e);
        }
    }

    @Override
    public PageInfo<TranslationFailureRecord> getFailureList(Integer merId, String status, PageParamRequest pageParamRequest) {
        PageHelper.startPage(pageParamRequest.getPage(), pageParamRequest.getLimit());

        LambdaQueryWrapper<TranslationFailureRecord> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(TranslationFailureRecord::getMerId, merId);
        
        if (StrUtil.isNotBlank(status)) {
            wrapper.eq(TranslationFailureRecord::getStatus, status);
        }
        
        wrapper.orderByDesc(TranslationFailureRecord::getCreateTime);

        List<TranslationFailureRecord> list = dao.selectList(wrapper);
        return new PageInfo<>(list);
    }

    @Override
    public String retryTranslation(Integer recordId, Integer merId) {
        // 查询失败记录
        TranslationFailureRecord record = getById(recordId);
        if (record == null) {
            throw new CrmebException("失败记录不存在");
        }

        if (!record.getMerId().equals(merId)) {
            throw new CrmebException("无权限操作此记录");
        }

        if ("success".equals(record.getStatus())) {
            throw new CrmebException("该翻译已成功，无需重试");
        }

        try {
            // 更新状态为重试中
            record.setStatus("retrying");
            record.setLastRetryTime(new Date());
            record.setUpdateTime(new Date());
            updateById(record);

            // 调用翻译服务
            String translatedText = translationService.getTranslation(
                    record.getEntityType(),
                    record.getEntityId(),
                    record.getFieldName(),
                    record.getTargetLanguage(),
                    record.getSourceText(),
                    merId
            );

            // 检查翻译是否成功
            if (StrUtil.isNotBlank(translatedText) && !translatedText.equals(record.getSourceText())) {
                // 翻译成功
                record.setStatus("success");
                record.setUpdateTime(new Date());
                updateById(record);
                
                log.info("重试翻译成功: recordId={}, fieldName={}, targetLang={}", 
                        recordId, record.getFieldName(), record.getTargetLanguage());
                
                return translatedText;
            } else {
                // 翻译失败，增加重试次数
                record.setRetryCount(record.getRetryCount() + 1);
                
                if (record.getRetryCount() >= record.getMaxRetries()) {
                    record.setStatus("failed"); // 最终失败
                } else {
                    record.setStatus("pending"); // 待重试
                }
                
                record.setFailureReason("翻译返回空或原文");
                record.setUpdateTime(new Date());
                updateById(record);
                
                throw new CrmebException("翻译失败：返回空或原文");
            }
        } catch (Exception e) {
            // 更新失败原因
            record.setRetryCount(record.getRetryCount() + 1);
            
            if (record.getRetryCount() >= record.getMaxRetries()) {
                record.setStatus("failed"); // 最终失败
            } else {
                record.setStatus("pending"); // 待重试
            }
            
            record.setFailureReason(e.getMessage());
            record.setUpdateTime(new Date());
            updateById(record);
            
            log.error("重试翻译失败: recordId={}, error={}", recordId, e.getMessage());
            throw new CrmebException("重试翻译失败: " + e.getMessage());
        }
    }

    @Override
    public int batchRetryTranslations(Integer merId, String status) {
        // 查询待重试的记录
        LambdaQueryWrapper<TranslationFailureRecord> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(TranslationFailureRecord::getMerId, merId);
        
        if (StrUtil.isNotBlank(status)) {
            wrapper.eq(TranslationFailureRecord::getStatus, status);
        } else {
            wrapper.eq(TranslationFailureRecord::getStatus, "pending");
        }
        
        wrapper.orderByAsc(TranslationFailureRecord::getCreateTime);
        
        List<TranslationFailureRecord> records = list(wrapper);
        
        int successCount = 0;
        for (TranslationFailureRecord record : records) {
            try {
                retryTranslation(record.getId(), merId);
                successCount++;
            } catch (Exception e) {
                log.error("批量重试失败: recordId={}, error={}", record.getId(), e.getMessage());
                // 继续处理下一个
            }
        }
        
        log.info("批量重试翻译完成: merId={}, total={}, success={}", merId, records.size(), successCount);
        return successCount;
    }

    @Override
    public Map<String, Object> getFailureStatistics(Integer merId) {
        Map<String, Object> result = new HashMap<>();
        
        // 总失败数
        LambdaQueryWrapper<TranslationFailureRecord> totalWrapper = Wrappers.lambdaQuery();
        totalWrapper.eq(TranslationFailureRecord::getMerId, merId);
        long totalCount = count(totalWrapper);
        
        // 待重试数
        LambdaQueryWrapper<TranslationFailureRecord> pendingWrapper = Wrappers.lambdaQuery();
        pendingWrapper.eq(TranslationFailureRecord::getMerId, merId)
                     .eq(TranslationFailureRecord::getStatus, "pending");
        long pendingCount = count(pendingWrapper);
        
        // 重试中数
        LambdaQueryWrapper<TranslationFailureRecord> retryingWrapper = Wrappers.lambdaQuery();
        retryingWrapper.eq(TranslationFailureRecord::getMerId, merId)
                      .eq(TranslationFailureRecord::getStatus, "retrying");
        long retryingCount = count(retryingWrapper);
        
        // 已成功数
        LambdaQueryWrapper<TranslationFailureRecord> successWrapper = Wrappers.lambdaQuery();
        successWrapper.eq(TranslationFailureRecord::getMerId, merId)
                     .eq(TranslationFailureRecord::getStatus, "success");
        long successCount = count(successWrapper);
        
        // 最终失败数
        LambdaQueryWrapper<TranslationFailureRecord> failedWrapper = Wrappers.lambdaQuery();
        failedWrapper.eq(TranslationFailureRecord::getMerId, merId)
                    .eq(TranslationFailureRecord::getStatus, "failed");
        long failedCount = count(failedWrapper);
        
        result.put("totalCount", totalCount);
        result.put("pendingCount", pendingCount);
        result.put("retryingCount", retryingCount);
        result.put("successCount", successCount);
        result.put("failedCount", failedCount);
        
        return result;
    }
}
