package com.zbkj.front.service;

import com.zbkj.common.request.customerservice.SendMessageRequest;
import com.zbkj.common.response.customerservice.CustomerServiceConfigResponse;
import com.zbkj.common.response.customerservice.CustomerServiceMessageResponse;
import com.zbkj.common.response.customerservice.CustomerServiceSessionResponse;

import java.util.List;

/**
 * 客服前端服务接口
 */
public interface CustomerServiceFrontService {

    /**
     * 获取客服配置
     */
    CustomerServiceConfigResponse getConfig();

    /**
     * 创建或获取当前用户会话
     */
    CustomerServiceSessionResponse createOrGetSession();

    /**
     * 获取会话消息列表
     */
    List<CustomerServiceMessageResponse> getMessages(String sessionId);

    /**
     * 发送消息
     */
    Boolean sendMessage(SendMessageRequest request);

    /**
     * 标记消息为已读
     */
    Boolean markMessagesAsRead(String sessionId);
}






