import request from '@/utils/request'

// 平台端海报管理API - 直接复用商户端API

/**
 * 获取海报列表
 */
export function platformPosterListApi(params) {
  return request({
    url: '/admin/platform/poster/list',
    method: 'get',
    params
  })
}

/**
 * 获取海报详情
 */
export function getPlatformPosterDetailApi(id) {
  return request({
    url: `/admin/merchant/poster/info/${id}`,
    method: 'get'
  })
}

/**
 * 创建海报
 */
export function createPlatformPosterApi(data) {
  return request({
    url: '/admin/merchant/poster/save',
    method: 'post',
    data
  })
}

/**
 * 更新海报
 */
export function updatePlatformPosterApi(data) {
  return request({
    url: '/admin/merchant/poster/update',
    method: 'post',
    data
  })
}

/**
 * 删除海报
 */
export function deletePlatformPosterApi(id) {
  return request({
    url: `/admin/platform/poster/delete/${id}`,
    method: 'post'
  })
}

/**
 * 批量删除海报
 */
export function batchDeletePlatformPosterApi(ids) {
  return request({
    url: '/admin/merchant/poster/batchDelete',
    method: 'post',
    data: ids
  })
}

/**
 * 更新海报状态
 */
export function updatePlatformPosterStatusApi(id, status) {
  return request({
    url: `/admin/merchant/poster/status/${id}`,
    method: 'post',
    data: { status }
  })
}

/**
 * 生成海报
 */
export function generatePlatformPosterApi(id) {
  return request({
    url: `/admin/merchant/poster/generate/${id}`,
    method: 'post'
  })
}
