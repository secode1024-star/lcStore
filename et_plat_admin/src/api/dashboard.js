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

// 首页数据概览
export function viewModelApi() {
  return request({
    url: '/admin/platform/statistics/home/index',
    method: 'GET',
  });
}

// 用户购买统计
export function chartBuyApi() {
  return request({
    url: '/admin/statistics/home/chart/user/buy',
    method: 'get',
  });
}
// 首页经营数据
export function businessData() {
  return request({
    url: '/admin/platform/statistics/home/operating/data',
    method: 'get',
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
