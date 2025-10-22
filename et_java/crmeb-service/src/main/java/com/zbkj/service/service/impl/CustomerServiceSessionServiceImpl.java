package com.zbkj.service.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zbkj.common.model.customerservice.CustomerServiceSession;
import com.zbkj.common.model.user.User;
import com.zbkj.common.response.customerservice.CustomerServiceSessionResponse;
import com.zbkj.service.dao.CustomerServiceSessionDao;
import com.zbkj.service.service.CustomerServiceSessionService;
import com.zbkj.service.service.UserService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

/**
 * 客服会话服务实现类
 */
@Service
public class CustomerServiceSessionServiceImpl extends ServiceImpl<CustomerServiceSessionDao, CustomerServiceSession> implements CustomerServiceSessionService {

    @Autowired
    private UserService userService;

    @Override
    public CustomerServiceSessionResponse createOrGetSession(Integer userId) {
        // 查找用户的活跃会话
        LambdaQueryWrapper<CustomerServiceSession> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CustomerServiceSession::getUserId, userId);
        wrapper.eq(CustomerServiceSession::getStatus, 1);
        wrapper.orderByDesc(CustomerServiceSession::getCreateTime);
        wrapper.last("LIMIT 1");
        
        CustomerServiceSession session = getOne(wrapper);
        
        if (session == null) {
            // 创建新会话
            session = new CustomerServiceSession();
            session.setUserId(userId);
            session.setSessionKey(generateSessionKey());
            session.setStatus(1);
            save(session);
        }
        
        CustomerServiceSessionResponse response = new CustomerServiceSessionResponse();
        BeanUtils.copyProperties(session, response);
        // 手动设置sessionId字段，因为实体类中是sessionKey
        response.setSessionId(session.getSessionKey());
        
        // 填充用户信息
        if (session.getUserId() != null) {
            User user = userService.getById(session.getUserId());
            if (user != null) {
                response.setUserName(user.getNickname());
                response.setUserAvatar(user.getAvatar());
            }
        }
        
        return response;
    }
    
    private String generateSessionKey() {
        return "session_" + UUID.randomUUID().toString().replace("-", "");
    }
    
    @Override
    public java.util.List<CustomerServiceSessionResponse> getSessionList() {
        // 获取所有活跃会话
        LambdaQueryWrapper<CustomerServiceSession> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CustomerServiceSession::getStatus, 1);
        wrapper.orderByDesc(CustomerServiceSession::getLastMessageTime);
        
        java.util.List<CustomerServiceSession> sessions = list(wrapper);
        
        return sessions.stream().map(session -> {
            CustomerServiceSessionResponse response = new CustomerServiceSessionResponse();
            org.springframework.beans.BeanUtils.copyProperties(session, response);
            // 手动设置sessionId字段，因为实体类中是sessionKey
            response.setSessionId(session.getSessionKey());
            
            // 填充用户信息
            if (session.getUserId() != null) {
                User user = userService.getById(session.getUserId());
                if (user != null) {
                    response.setUserName(user.getNickname());
                    response.setUserAvatar(user.getAvatar());
                }
            }
            
            return response;
        }).collect(java.util.stream.Collectors.toList());
    }
}