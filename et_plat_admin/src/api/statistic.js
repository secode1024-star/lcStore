// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import request from '@/utils/request';

/**
 * 商品统计数据
 * @param pram
 */
export function productDataApi(params) {
  return request({
    url: `/admin/statistics/product/data`,
    method: 'GET',
    params,
  });
}

/**
 * 商品排行数据
 * @param pram
 */
export function productRankApi(params) {
  return request({
    url: `/admin/statistics/product/ranking`,
    method: 'GET',
    params,
  });
}

/**
 * 商品趋势数据
 * @param pram
 */
export function productTrendApi(params) {
  return request({
    url: `/admin/statistics/product/trend`,
    method: 'GET',
    params,
  });
}

/**
 * 交易统计数据
 * @param pram
 */
export function tradeDataApi() {
  return request({
    url: `/admin/statistics/trade/data`,
    method: 'GET',
  });
}

/**
 * 交易概览
 * @param pram
 */
export function tradeOverviewApi(params) {
  return request({
    url: `/admin/statistics/trade/overview`,
    method: 'GET',
    params,
  });
}

/**
 * 交易趋势
 * @param pram
 */
export function tradeTrendApi(params) {
  return request({
    url: `/admin/statistics/trade/trend`,
    method: 'GET',
    params,
  });
}

/**
 * 用户渠道数据
 * @param pram
 */
export function userChannelData() {
  return request({
    url: `/admin/platform/statistics/home/channel`,
    method: 'GET',
  });
}

/**
 * 用户概览数据
 * @param params
 */
export function userOverviewData(params) {
  return request({
    url: `/admin/platform/statistics/user/overview`,
    method: 'GET',
    params,
  });
}
