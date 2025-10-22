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
 * 获取客服配置
 */
export function customerServiceConfigApi() {
  return request({
    url: '/admin/platform/customer-service/config',
    method: 'GET'
  });
}

/**
 * 保存客服配置
 */
export function customerServiceConfigSaveApi(data) {
  return request({
    url: '/admin/platform/customer-service/config',
    method: 'POST',
    data
  });
}

/**
 * 获取会话列表
 */
export function customerServiceSessionListApi() {
  return request({
    url: '/admin/platform/customer-service/sessions',
    method: 'GET'
  });
}

/**
 * 获取消息列表
 */
export function customerServiceMessageListApi(sessionId) {
  return request({
    url: `/admin/platform/customer-service/messages/${sessionId}`,
    method: 'GET'
  });
}

/**
 * 发送消息
 */
export function customerServiceSendMessageApi(data) {
  return request({
    url: '/admin/platform/customer-service/message/send',
    method: 'POST',
    data
  });
}




