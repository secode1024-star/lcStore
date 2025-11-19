import request from '@/utils/request';

/**
 * 获取翻译失败记录列表
 */
export function getFailureListApi(params) {
  return request({
    url: '/admin/merchant/translation/failure/list',
    method: 'GET',
    params
  });
}

/**
 * 重试单个失败的翻译
 */
export function retryTranslationApi(recordId) {
  return request({
    url: '/admin/merchant/translation/failure/retry',
    method: 'POST',
    params: { recordId }
  });
}

/**
 * 批量重试失败的翻译
 */
export function batchRetryTranslationsApi(status) {
  return request({
    url: '/admin/merchant/translation/failure/batch-retry',
    method: 'POST',
    params: { status }
  });
}

/**
 * 获取翻译失败统计
 */
export function getFailureStatisticsApi() {
  return request({
    url: '/admin/merchant/translation/failure/statistics',
    method: 'GET'
  });
}
