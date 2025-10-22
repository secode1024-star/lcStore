import request from '@/utils/request'

// 获取客服配置
export function getCustomerServiceConfig() {
  return request({
    url: 'admin/platform/customer-service/config',
    method: 'get'
  })
}

// 保存客服配置
export function saveCustomerServiceConfig(data) {
  return request({
    url: 'admin/platform/customer-service/config',
    method: 'post',
    data
  })
}

// 获取客服会话列表
export function getCustomerServiceSessions() {
  return request({
    url: 'admin/platform/customer-service/sessions',
    method: 'get'
  })
}

// 获取会话消息
export function getSessionMessages(sessionId) {
  return request({
    url: `admin/platform/customer-service/messages/${sessionId}`,
    method: 'get'
  })
}

// 发送消息
export function sendMessage(data) {
  return request({
    url: 'admin/platform/customer-service/message/send',
    method: 'post',
    data
  })
}

// 标记消息已读
export function markMessagesRead(sessionId) {
  return request({
    url: `admin/platform/customer-service/messages/read/${sessionId}`,
    method: 'post'
  })
}
