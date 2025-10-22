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
import {toLogin,checkLogin} from '../libs/login';
/**
 * 分享
 * @returns {*}
 */
export function getShare() {
  return request.get("share", {}, { noAuth: true });
}
/**
 * 自动复制口令功能
 * @returns {*}
 */
export function copyWords() {
  return request.get("copy_words", {}, { noAuth: true });
}
/**
 * 苹果登录
 * @param {Object} data
 */
export function appleLogin(data) {
	return request.post("ios/login", data, { noAuth : true });
}
/**
 * 苹果绑定手机号
 * @param {Object} data
 */
export function iosBinding(data) {
	return request.post("ios/binding/phone", data, { noAuth : true });
}
/**
 * 获取图片base64
 * @retins {*}
 * */
export function imageBase64(image) {
  return request.post("qrcode/url/to/base64",image,{ noAuth: true });
}