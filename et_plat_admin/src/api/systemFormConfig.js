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

export function getFormConfigInfo(pram) {
  const data = {
    id: pram.id,
  };
  return request({
    url: '/admin/platform/form/temp/info',
    method: 'GET',
    params: data,
  });
}

export function getFormConfigList(pram) {
  const data = {
    keywords: pram.keywords,
    page: pram.page,
    limit: pram.limit,
  };
  return request({
    url: '/admin/platform/form/temp/list',
    method: 'GET',
    params: data,
  });
}

export function getFormConfigSave(pram) {
  const data = {
    content: pram.content,
    info: pram.info,
    name: pram.name,
  };
  return request({
    url: '/admin/platform/form/temp/save',
    method: 'POST',
    data: data,
  });
}

export function getFormConfigEdit(pram) {
  const params = { id: pram.id };
  const data = {
    content: pram.content,
    info: pram.info,
    name: pram.name,
  };
  return request({
    url: '/admin/platform/form/temp/update',
    method: 'POST',
    params: params,
    data: data,
  });
}

/**
 * 系统通知列表
 * @param pram
 */
export function notificationListApi(pram) {
  const data = {
    sendType: pram.sendType,
    //发送类型（1：通知会员，2：通知平台）
  };
  return request({
    url: '/admin/platform/notification/list',
    method: 'GET',
    params: data,
  });
}

/**
 * 发送邮件开关
 * @param pram
 */
export function notificationEmail(id) {
  return request({
    url: `/admin/platform/notification/email/switch/${id}`,
    method: 'post',
  });
}

/**
 * 发送短信开关
 * @param pram
 */
export function notificationSms(id) {
  return request({
    url: `/admin/platform/notification/sms/switch/${id}`,
    method: 'post',
  });
}

/**
 * 发送海外短信开关
 * @param pram
 */
export function overseaSwitch(id) {
  return request({
    url: `/admin/platform/notification/oversea/sms/switch/${id}`,
    method: 'post',
  });
}

/**
 * 通知详情
 * @param pram
 */
export function notificationDetail(param) {
  let data = {
    detailType: param.type,
    id: param.id,
  };
  return request({
    url: `/admin/platform/notification/detail`,
    method: 'get',
    params: data,
  });
}

//admin/system/notification/detail
/**
 * 修改通知
 * @param pram
 */
export function notificationUpdate(param) {
  let data = {
    detailType: param.type,
    id: param.id,
    status: param.status,
    tempId: param.tempId,
  };
  return request({
    url: `/admin/platform/notification/update`,
    method: 'post',
    data,
  });
}

/**
 * 生成表单 提交
 * @param pram
 */
export function parserFromUpdateApi(url, method, data) {
  return request({
    url,
    method,
    data,
  });
}

/**
 * @description 短信发送记录
 */
export function smsApi(params) {
  return request({
    url: '/admin/platform/sms/record',
    method: 'get',
    params,
  });
}
/**
 * 通过名称查询详情
 * @param pram
 */
export function formTempNameInfoApi(params) {
  return request({
    url: `/admin/platform/system/form/temp/name/info`,
    method: 'get',
    params,
  });
}
