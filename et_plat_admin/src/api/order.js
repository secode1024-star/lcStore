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
 * 订单 列表
 * @param prams
 */
export function orderListApi(params) {
  return request({
    url: '/admin/platform/order/list',
    method: 'get',
    params,
  });
}

/**
 * 订单 列表 获取各状态数量
 * @param params
 */
export function orderStatusNumApi(params) {
  return request({
    url: '/admin/platform/order/status/num',
    method: 'get',
    params,
  });
}

/**
 * 订单 列表 数据统计
 * @param params
 */
export function orderListDataApi(params) {
  return request({
    url: '/admin/store/order/list/data',
    method: 'get',
    params,
  });
}

/**
 * 订单 详情
 * @param prams
 */
export function orderDetailApi(params) {
  return request({
    url: '/admin/platform/order/info',
    method: 'get',
    params,
  });
}

/**
 * 订单 备注
 * @param prams
 */
export function orderMarkApi(data) {
  return request({
    url: '/admin/platform/order/mark',
    method: 'post',
    data,
  });
}

/**
 * 订单 发货
 * @param prams
 */
export function orderSendApi(data) {
  return request({
    url: '/admin/merchant/order/send',
    method: 'post',
    data,
  });
}

/**
 * 订单 核销订单
 * @param prams
 */
export function writeUpdateApi(vCode) {
  return request({
    url: `/admin/store/order/writeUpdate/${vCode}`,
    method: 'get',
  });
}

/**
 * 订单 核销码查询待核销订单
 * @param prams
 */
export function writeConfirmApi(vCode) {
  return request({
    url: `/admin/store/order/writeConfirm/${vCode}`,
    method: 'get',
  });
}

/**
 * 订单 统计 头部数据
 */
export function orderStatisticsApi() {
  return request({
    url: `/admin/store/order/statistics`,
    method: 'get',
  });
}

/**
 * 核销订单 月列表数据
 */
export function statisticsDataApi(params) {
  return request({
    url: `/admin/store/order/statisticsData`,
    method: 'get',
    params,
  });
}

/**
 * 一键改价
 */
export function updatePriceApi(data) {
  return request({
    url: `admin/store/order/update/price`,
    method: 'post',
    data,
  });
}

/**
 *订单统计详情
 */
export function orderTimeApi(params) {
  return request({
    url: `/admin/store/order/time`,
    method: 'get',
    params,
  });
}

/**
 *面单默认配置信息
 */
export function sheetInfoApi() {
  return request({
    url: `/admin/store/order/sheet/info`,
    method: 'get',
  });
}

/**
 *面单默认配置信息
 */
export function getLogisticsInfoApi(params) {
  return request({
    url: `/admin/platform/order/getLogisticsInfo`,
    method: 'get',
    params,
  });
}

/**
 *视频号物流公司
 */
export function companyGetListApi() {
  return request({
    url: `/admin/pay/component/delivery/company/get/list`,
    method: 'get',
  });
}

/**
 *视频号物流公司
 */
export function videoSendApi(data) {
  return request({
    url: `/admin/store/order/video/send`,
    method: 'post',
    data,
  });
}

/**
 *打印小票
 */
export function orderPrint(id) {
  return request({
    url: `/admin/yly/print/${id}`,
    method: 'get',
  });
}

/**
 *退款列表
 */
export function refundListApi(params) {
  return request({
    url: `/admin/platform/refund/order/list`,
    method: 'get',
    params,
  });
}

/**
 *退商户备注退款订单
 */
export function refundMarkApi(data) {
  return request({
    url: `/admin/platform/refund/order/mark`,
    method: 'post',
    data,
  });
}

/**
 *获取退款订单各状态数量
 */
export function refundStatusNumApi(params) {
  return request({
    url: `/admin/platform/refund/order/status/num`,
    method: 'GET',
    params,
  });
}
