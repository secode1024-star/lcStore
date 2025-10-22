package com.zbkj.service.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.zbkj.common.model.customerservice.CustomerServiceSession;
import com.zbkj.common.response.customerservice.CustomerServiceSessionResponse;

/**
 * 客服会话服务接口
 */
public interface CustomerServiceSessionService extends IService<CustomerServiceSession> {
    
    /**
     * 创建或获取用户会话
     */
    CustomerServiceSessionResponse createOrGetSession(Integer userId);
    
    /**
     * 获取会话列表
     */
    java.util.List<CustomerServiceSessionResponse> getSessionList();
}