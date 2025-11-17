package com.zbkj.service.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.model.translation.Translation;
import com.zbkj.common.request.BatchTranslateRequest;
import com.zbkj.common.request.PageParamRequest;

import java.util.Map;

/**
 * 翻译服务接口
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 */
public interface TranslationService extends IService<Translation> {

    /**
     * 获取翻译（带缓存机制）
     * 
     * @param entityType 实体类型
     * @param entityId 实体ID
     * @param fieldName 字段名称
     * @param targetLanguage 目标语言
     * @param sourceText 源文本
     * @param merId 商户ID
     * @return 翻译后的文本
     */
    String getTranslation(String entityType, Integer entityId, String fieldName, 
                         String targetLanguage, String sourceText, Integer merId);

    /**
     * 仅从缓存和数据库获取翻译（不调用API）
     * 用于用户访问时的翻译查询，只读取已翻译的数据
     * 
     * @param entityType 实体类型
     * @param entityId 实体ID
     * @param fieldName 字段名称
     * @param targetLanguage 目标语言
     * @param sourceText 源文本
     * @param merId 商户ID
     * @return 翻译后的文本，如果未找到则返回原文
     */
    String getCachedTranslation(String entityType, Integer entityId, String fieldName, 
                               String targetLanguage, String sourceText, Integer merId);

    /**
     * 批量翻译（优化版：优先查询缓存，只翻译未缓存的内容）
     * 
     * @param request 批量翻译请求
     * @param merId 商户ID
     * @return 翻译结果：{fieldName: {language: translatedText}}
     */
    Map<String, Map<String, String>> batchTranslate(BatchTranslateRequest request, Integer merId);

    /**
     * 批量翻译商品信息
     * 
     * @param productId 商品ID
     * @param storeName 商品名称
     * @param storeInfo 商品描述
     * @param keyword 关键字
     * @param content 商品详情（HTML富文本）
     * @param targetLanguages 目标语言列表
     * @param merId 商户ID
     */
    void batchTranslateProduct(Integer productId, String storeName, String storeInfo, 
                              String keyword, String content, String[] targetLanguages, Integer merId);

    /**
     * 分页查询翻译列表
     * 
     * @param entityType 实体类型
     * @param entityId 实体ID
     * @param targetLanguage 目标语言
     * @param merId 商户ID
     * @param pageParamRequest 分页参数
     * @return 翻译列表
     */
    PageInfo<Translation> getTranslationList(String entityType, Integer entityId, 
                                              String targetLanguage, Integer merId, 
                                              PageParamRequest pageParamRequest);

    /**
     * 获取翻译统计信息
     * 
     * @param merId 商户ID
     * @return 统计信息
     */
    Map<String, Object> getStatistics(Integer merId);
}



