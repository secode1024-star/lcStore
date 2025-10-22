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
    url: '/admin/merchant/login',
    method: 'post',
    data,
  });
}

export function getInfo(token) {
  return request({
    url: '/admin/merchant/getAdminInfoByToken',
    method: 'get',
    params: { token },
  });
}

export function logout() {
  return request({
    url: '/admin/merchant/logout',
    method: 'get',
  });
}

/**
 * 会员管理 列表
 * @param pram
 */
export function userListApi(params) {
  return request({
    url: `/admin/merchant/user/list`,
    method: 'get',
    params,
  });
}

/**
 *获取登录页图片
 */
export function getLoginPicApi() {
  return request({
    url: `/admin/merchant/getLoginPic`,
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
