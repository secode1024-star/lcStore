// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c)  https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------


import request from "@/utils/request.js";

/**
 * 店铺详细信息
 * @param int id
 */
export function getMerDetailApi(id) {
  return request.get(`merchant/detail/${id}`, {}, {noAuth:true});
}

/**
 * 店铺首页信息
 * @param int id
 */
export function getMerIndexInfoApi(id) {
  return request.get(`merchant/index/info/${id}`, {}, {noAuth:true});
}

/**
 * 商户搜索列表
 * @param Obj data
 */
export function getMerSearchApi(data) {
  return request.get(`merchant/search/list`, data, {noAuth:true});
}

/**
 * 商户入驻申请
 * @param Obj data
 */
export function getMerSettledApplyApi(data) {
  return request.post(`merchant/settled/apply`, data);
}

/**
 * 商户入入驻记录
 * @param Obj data
 */
export function getMerSettledRecordApi(data) {
  return request.get(`merchant/settled/record`, data);
}

/**
 * 店铺街
 * @param Obj data
 */
export function getMerStreetApi(data) {
  return request.get(`merchant/street`, data , {noAuth:true});
}

/**
 * 商户商品列表
 * @param Obj data
 */
export function getMerProListApi(data) {
  return request.get(`product/merchant/pro/list`, data , {noAuth:true});
}

/**
 * 商户商品分类列表
 * @param Obj data
 */
export function getMerCategoryApi(id) {
  return request.get(`product/merchant/${id}/category/list`, {}, {noAuth:true});
}

/**
 * 收藏店铺
 * @param int id
 */
export function getMerCollectAddApi(id) {
  return request.post(`collect/add/merchant/${id}`);
}

/**
 * 取消收藏店铺
 * @param int id
 */
export function getMerCollectCancelApi(id) {
  return request.post(`collect/cancel/merchant/${id}`);
}

/**
 * 商户收藏列表
 * @param Obj data
 */
export function getMerCollectListApi(data) {
  return request.get(`collect/merchant/list`,data);
}

/**
 * 获取全部商户分类列表
 */
export function getMerCategoryListApi() {
  return request.get(`merchant/all/category/list`, {}, {noAuth:true});
}

/**
 * 获取全部商户类型列表
 */
export function getMerTypeListApi() {
  return request.get(`merchant/all/type/list`, {}, {noAuth:true});
}

/**
 * 商户入驻发送邮箱验证码
 */
export function emailSettledApi(data) {
  return request.post(`captcha/email/merchant/settled`, data);
}

/**
 * 获取入驻协议
 */
export function settledAgreementApi() {
  return request.get(`merchant/settled/agreement`);
}