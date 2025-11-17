// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2025 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import request from '@/utils/request';

/**
 * 获取翻译积分信息（平台管理端 - 管理所有商户的积分）
 * @param {Number} merId 商户ID，可选
 */
export function getTranslationPointsApi(merId) {
  return request({
    url: '/admin/platform/translation/points',
    method: 'GET',
    params: merId ? { merId } : {},
  });
}

/**
 * 获取翻译列表（平台管理端 - 查看所有商户的翻译记录）
 */
export function getTranslationListApi(params) {
  return request({
    url: '/admin/platform/translation/list',
    method: 'GET',
    params,
  });
}

/**
 * 获取单个翻译
 */
export function getTranslationApi(params) {
  return request({
    url: '/admin/platform/translation/get',
    method: 'GET',
    params,
  });
}

/**
 * 批量翻译商品
 */
export function batchTranslateApi(data) {
  return request({
    url: '/admin/platform/translation/batch',
    method: 'POST',
    data,
  });
}

/**
 * 获取翻译统计（平台管理端 - 查看所有商户的统计）
 */
export function getTranslationStatisticsApi(params) {
  return request({
    url: '/admin/platform/translation/statistics',
    method: 'GET',
    params: params || {},
  });
}

/**
 * 为商户添加翻译积分
 */
export function addMerchantTranslationPointsApi(data) {
  return request({
    url: '/admin/platform/translation/points/add',
    method: 'POST',
    data,
  });
}

