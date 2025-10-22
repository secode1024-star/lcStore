package com.zbkj.service.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.zbkj.common.model.customerservice.CustomerServiceMessage;
import com.zbkj.common.request.customerservice.SendMessageRequest;
import com.zbkj.common.response.customerservice.CustomerServiceMessageResponse;

import java.util.List;

/**
 * 客服消息服务接口
 */
public interface CustomerServiceMessageService extends IService<CustomerServiceMessage> {
    
    /**
     * 获取会话消息列表
     */
    List<CustomerServiceMessageResponse> getMessageList(String sessionId);
    
    /**
     * 发送消息
     */
    Boolean sendMessage(SendMessageRequest request, Integer userId);
    
    /**
     * 标记消息为已读
     */
    Boolean markMessagesAsRead(String sessionId, Integer userId);
    
    /**
     * 客服发送消息
     */
    Boolean sendMessageByService(SendMessageRequest request, int adminId);
}