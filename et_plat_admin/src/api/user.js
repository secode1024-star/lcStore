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

export function login(data) {
  return request({
    url: '/admin/platform/login',
    method: 'post',
    data,
  });
}

export function getInfo(token) {
  return request({
    url: '/admin/platform/getAdminInfoByToken',
    method: 'get',
    params: { token },
  });
}

export function logout() {
  return request({
    url: '/admin/platform/logout',
    method: 'get',
  });
}

/**
 * 会员管理 列表
 * @param pram
 */
export function userListApi(params) {
  return request({
    url: `/admin/platform/user/list`,
    method: 'get',
    params,
  });
}

/**
 * 会员管理 修改
 * @param pram
 */
export function userUpdateApi(data) {
  return request({
    url: `/admin/platform/user/update`,
    method: 'post',
    data,
  });
}

/**
 * 会员管理等级 修改
 * @param pram
 */
export function userLevelUpdateApi(data) {
  return request({
    url: `/admin/user/update/level`,
    method: 'post',
    data,
  });
}

/**
 * 会员管理 详情
 * @param pram
 */
export function userInfoApi(uid) {
  return request({
    url: `/admin/platform/user/info/${uid}`,
    method: 'get',
  });
}

/**
 * 会员管理 消费记录
 * @param pram
 */
export function expensesRecordApi(uid, params) {
  return request({
    url: `/admin/platform/user/expenses/record/${uid}`,
    method: 'get',
    params,
  });
}

/**
 * 会员管理 持有优惠券
 * @param pram
 */
export function haveCouponsApi(uid, params) {
  return request({
    url: `/admin/platform/user/have/coupons/${uid}`,
    method: 'get',
    params,
  });
}

/**
 * 会员管理 账户详情top数据
 * @param pram
 */
export function topdetailApi(uid) {
  return request({
    url: `/admin/platform/user/topdetail/${uid}`,
    method: 'get',
  });
}

/**
 * 会员管理 批量设置分组
 * @param data
 */
export function groupPiApi(data) {
  return request({
    url: `/admin/platform/user/group`,
    method: 'post',
    data,
  });
}

/**
 * 会员管理 批量设置标签
 * @data data
 */
export function tagPiApi(data) {
  return request({
    url: `/admin/platform/user/tag`,
    method: 'post',
    data,
  });
}

/**
 * 会员管理 删除
 * @param pram
 */
export function userDeleteApi(params) {
  return request({
    url: `/admin/user/delete`,
    method: 'get',
    params,
  });
}

/**
 * 会员等级 列表
 * @param pram
 */
export function levelListApi() {
  return request({
    url: `/admin/system/user/level/list`,
    method: 'get',
  });
}

/**
 * 会员等级 新增
 * @param pram
 */
export function levelSaveApi(data) {
  return request({
    url: `/admin/system/user/level/save`,
    method: 'post',
    data,
  });
}

/**
 * 会员等级 编辑
 *  @param pram
 */
export function levelUpdateApi(params, data) {
  return request({
    url: `/admin/system/user/level/update/${params}`,
    method: 'post',
    // params,
    data,
  });
}

/**
 * 会员等级 详情
 * @param pram
 */
export function levelInfoApi(params) {
  return request({
    url: `/admin/system/user/level/info`,
    method: 'get',
    params,
  });
}

/**
 * 会员等级 删除
 * @param pram
 */
export function levelDeleteApi(id) {
  return request({
    url: `/admin/system/user/level/delete/${id}`,
    method: 'post',
  });
}

/**
 * 会员等级 是否显示
 * @param pram
 */
export function levelUseApi(data) {
  return request({
    url: `/admin/system/user/level/use`,
    method: 'post',
    data,
  });
}

/**
 * 会员标签 列表
 * @param pram
 */
export function tagListApi(params) {
  return request({
    url: `/admin/platform/user/tag/list`,
    method: 'get',
    params,
  });
}

/**
 * 用户标签全部列表
 * @param pram
 */
export function tagAllListApi(params) {
  return request({
    url: `/admin/platform/user/tag/all/list`,
    method: 'get',
    params,
  });
}

/**
 * 会员标签 新增
 * @param pram
 */
export function tagSaveApi(data) {
  return request({
    url: `/admin/platform/user/tag/save`,
    method: 'post',
    data,
  });
}

/**
 * 会员标签 编辑
 * @param pram
 */
export function tagUpdateApi(id, data) {
  return request({
    url: `/admin/platform/user/tag/update/${id}`,
    method: 'post',
    data,
  });
}

/**
 * 会员标签 删除
 * @param pram
 */
export function tagDeleteApi(id) {
  return request({
    url: `/admin/platform/user/tag/delete/${id}`,
    method: 'get',
  });
}

/**
 *获取登录页图片
 */
export function getLoginPicApi() {
  return request({
    url: `/admin/platform/getLoginPic`,
    method: 'get',
  });
}

/**
 * @description 验证码
 */
export function captchaApi() {
  return request({
    url: `/admin/validate/code/get`,
    method: 'get',
  });
}

/**
 * 查询是否需要开启图形验证码
 * @returns {*}
 */
export function captchaconfigApi() {
  return request({
    url: `/admin/validate/code/getcaptchaconfig`,
    method: 'get',
  });
}

/**
 * @description 修改上级推广人
 */
export function updateSpreadApi(data) {
  return request({
    url: `/admin/user/update/spread`,
    method: 'post',
    data,
  });
}

/**
 * @description 修改手机号
 */
export function updatePhoneApi(params) {
  return request({
    url: `/admin/user/update/phone`,
    method: 'get',
    params,
  });
}
