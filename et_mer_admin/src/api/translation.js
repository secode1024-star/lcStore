import request from '@/utils/request';

/**
 * 获取翻译积分信息（商户端 - 查看自己的积分）
 */
export function getTranslationPointsApi() {
  return request({
    url: '/admin/merchant/translation/points',
    method: 'GET',
  });
}

/**
 * 批量翻译（优化版：优先查询缓存，只翻译未缓存的内容）
 * @param {Object} params - 包含 fields（字段映射）和 targetLanguages（目标语言列表）
 * @returns {Promise} 返回翻译结果：{fieldName: {language: translatedText}}
 */
export function batchTranslateApi(params) {
  return request({
    url: '/admin/merchant/translation/batch',
    method: 'POST',
    data: params,
  });
}
















