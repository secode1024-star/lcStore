package com.zbkj.service.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.model.translation.TranslationFailureRecord;
import com.zbkj.common.request.PageParamRequest;

import java.util.List;

/**
 * 翻译失败记录服务接口
 */
public interface TranslationFailureRecordService extends IService<TranslationFailureRecord> {

    /**
     * 记录翻译失败
     * 
     * @param entityType 实体类型
     * @param entityId 实体ID
     * @param fieldName 字段名称
     * @param sourceLanguage 源语言
     * @param targetLanguage 目标语言
     * @param sourceText 源文本
     * @param failureReason 失败原因
     * @param retryCount 重试次数
     * @param maxRetries 最大重试次数
     * @param merId 商户ID
     */
    void recordFailure(String entityType, Integer entityId, String fieldName,
                      String sourceLanguage, String targetLanguage, String sourceText,
                      String failureReason, Integer retryCount, Integer maxRetries, Integer merId);

    /**
     * 获取失败记录列表
     * 
     * @param merId 商户ID
     * @param status 状态
     * @param pageParamRequest 分页参数
     * @return 失败记录列表
     */
    PageInfo<TranslationFailureRecord> getFailureList(Integer merId, String status, PageParamRequest pageParamRequest);

    /**
     * 重试单个失败的翻译
     * 
     * @param recordId 失败记录ID
     * @param merId 商户ID
     * @return 翻译结果
     */
    String retryTranslation(Integer recordId, Integer merId);

    /**
     * 批量重试失败的翻译
     * 
     * @param merId 商户ID
     * @param status 状态（可选，如果为null则重试所有pending状态的）
     * @return 重试成功的数量
     */
    int batchRetryTranslations(Integer merId, String status);

    /**
     * 获取商户的失败翻译统计
     * 
     * @param merId 商户ID
     * @return 统计信息
     */
    java.util.Map<String, Object> getFailureStatistics(Integer merId);
}
