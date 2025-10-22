package com.zbkj.front.service.impl;

import com.zbkj.common.request.customerservice.SendMessageRequest;
import com.zbkj.common.response.customerservice.CustomerServiceConfigResponse;
import com.zbkj.common.response.customerservice.CustomerServiceMessageResponse;
import com.zbkj.common.response.customerservice.CustomerServiceSessionResponse;
import com.zbkj.front.service.CustomerServiceFrontService;
import com.zbkj.service.service.CustomerServiceConfigService;
import com.zbkj.service.service.CustomerServiceMessageService;
import com.zbkj.service.service.CustomerServiceSessionService;
import com.zbkj.service.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 客服前端服务实现类
 */
@Service
public class CustomerServiceFrontServiceImpl implements CustomerServiceFrontService {

    @Autowired
    private CustomerServiceConfigService configService;

    @Autowired
    private CustomerServiceSessionService sessionService;

    @Autowired
    private CustomerServiceMessageService messageService;

    @Autowired
    private UserService userService;

    @Override
    public CustomerServiceConfigResponse getConfig() {
        return configService.getConfig();
    }

    @Override
    public CustomerServiceSessionResponse createOrGetSession() {
        // 获取当前登录用户ID，如果未登录则使用默认值
        Integer userId;
        try {
            userId = userService.getUserIdException();
        } catch (Exception e) {
            // 未登录用户使用默认ID 0
            userId = 0;
        }
        return sessionService.createOrGetSession(userId);
    }

    @Override
    public List<CustomerServiceMessageResponse> getMessages(String sessionId) {
        return messageService.getMessageList(sessionId);
    }

    @Override
    public Boolean sendMessage(SendMessageRequest request) {
        // 获取当前登录用户ID，如果未登录则使用默认值
        Integer userId;
        try {
            userId = userService.getUserIdException();
        } catch (Exception e) {
            // 未登录用户使用默认ID 0
            userId = 0;
        }
        return messageService.sendMessage(request, userId);
    }

    @Override
    public Boolean markMessagesAsRead(String sessionId) {
        // 获取当前登录用户ID，如果未登录则使用默认值
        Integer userId;
        try {
            userId = userService.getUserIdException();
        } catch (Exception e) {
            // 未登录用户使用默认ID 0
            userId = 0;
        }
        return messageService.markMessagesAsRead(sessionId, userId);
    }
}
