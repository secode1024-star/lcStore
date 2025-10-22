package com.zbkj.service.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zbkj.common.model.customerservice.CustomerServiceMessage;
import com.zbkj.common.model.customerservice.CustomerServiceSession;
import com.zbkj.common.model.user.User;
import com.zbkj.common.request.customerservice.SendMessageRequest;
import com.zbkj.common.response.customerservice.CustomerServiceMessageResponse;
import com.zbkj.service.dao.CustomerServiceMessageDao;
import com.zbkj.service.dao.CustomerServiceSessionDao;
import com.zbkj.service.service.CustomerServiceMessageService;
import com.zbkj.service.service.UserService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;

/**
 * 客服消息服务实现类
 */
@Slf4j
@Service
public class CustomerServiceMessageServiceImpl extends ServiceImpl<CustomerServiceMessageDao, CustomerServiceMessage> implements CustomerServiceMessageService {

    @Autowired
    private CustomerServiceSessionDao sessionDao;
    
    @Autowired
    private UserService userService;

    @Override
    public List<CustomerServiceMessageResponse> getMessageList(String sessionId) {
        // 根据sessionId查找session
        LambdaQueryWrapper<CustomerServiceSession> sessionWrapper = new LambdaQueryWrapper<>();
        sessionWrapper.eq(CustomerServiceSession::getSessionKey, sessionId);
        CustomerServiceSession session = sessionDao.selectOne(sessionWrapper);
        
        if (session == null) {
            return new ArrayList<>();
        }
        
        // 查询消息列表
        LambdaQueryWrapper<CustomerServiceMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CustomerServiceMessage::getSessionId, session.getId());
        wrapper.orderByAsc(CustomerServiceMessage::getCreateTime);
        
        List<CustomerServiceMessage> messages = list(wrapper);
        
        return messages.stream().map(message -> {
            CustomerServiceMessageResponse response = new CustomerServiceMessageResponse();
            BeanUtils.copyProperties(message, response);
            
            // 填充发送者信息
            if (message.getSenderType() == 1 && message.getSenderId() != null) {
                // 用户消息
                User user = userService.getById(message.getSenderId());
                if (user != null) {
                    response.setSenderName(user.getNickname());
                    response.setSenderAvatar(user.getAvatar());
                }
            } else if (message.getSenderType() == 2) {
                // 客服消息
                response.setSenderName("客服");
                response.setSenderAvatar(""); // 可以设置默认客服头像
            }
            
            return response;
        }).collect(Collectors.toList());
    }

    @Override
    public Boolean sendMessage(SendMessageRequest request, Integer userId) {
        try {
            // 根据sessionId查找session
            LambdaQueryWrapper<CustomerServiceSession> sessionWrapper = new LambdaQueryWrapper<>();
            sessionWrapper.eq(CustomerServiceSession::getSessionKey, request.getSessionId());
            CustomerServiceSession session = sessionDao.selectOne(sessionWrapper);
            
            if (session == null) {
                return false;
            }
            
            // 创建消息记录
            CustomerServiceMessage message = new CustomerServiceMessage();
            message.setSessionId(session.getId());
            message.setSenderType(1); // 1-用户
            message.setSenderId(userId); // sender_id是int类型，直接传入userId
            message.setMessageType(1); // 1-文本消息
            message.setContent(request.getContent());
            message.setIsRead(false);
            
            // 手动设置创建时间为当前时间（北京时间）
            Date currentTime = new Date();
            message.setCreateTime(currentTime);
            
            boolean result = save(message);
            
            if (result) {
                // 更新会话的最后消息时间
                LambdaUpdateWrapper<CustomerServiceSession> updateWrapper = new LambdaUpdateWrapper<>();
                updateWrapper.eq(CustomerServiceSession::getId, session.getId());
                updateWrapper.set(CustomerServiceSession::getLastMessageTime, currentTime);
                sessionDao.update(null, updateWrapper);
            }
            
            return result;
        } catch (Exception e) {
            log.error("发送消息失败", e);
            return false;
        }
    }

    @Override
    public Boolean markMessagesAsRead(String sessionId, Integer userId) {
        try {
            // 根据sessionId查找session
            LambdaQueryWrapper<CustomerServiceSession> sessionWrapper = new LambdaQueryWrapper<>();
            sessionWrapper.eq(CustomerServiceSession::getSessionKey, sessionId);
            CustomerServiceSession session = sessionDao.selectOne(sessionWrapper);
            
            if (session == null) {
                return false;
            }
            
            // 标记用户未读的消息为已读
            LambdaUpdateWrapper<CustomerServiceMessage> updateWrapper = new LambdaUpdateWrapper<>();
            updateWrapper.eq(CustomerServiceMessage::getSessionId, session.getId());
            updateWrapper.eq(CustomerServiceMessage::getSenderType, 2); // 2-客服发送的消息
            updateWrapper.eq(CustomerServiceMessage::getIsRead, false);
            updateWrapper.set(CustomerServiceMessage::getIsRead, true);
            
            return update(null, updateWrapper);
        } catch (Exception e) {
            log.error("标记消息已读失败", e);
            return false;
        }
    }
    
    @Override
    public Boolean sendMessageByService(SendMessageRequest request, int adminId) {
        try {
            // 根据sessionId查找session
            LambdaQueryWrapper<CustomerServiceSession> sessionWrapper = new LambdaQueryWrapper<>();
            sessionWrapper.eq(CustomerServiceSession::getSessionKey, request.getSessionId());
            CustomerServiceSession session = sessionDao.selectOne(sessionWrapper);
            
            if (session == null) {
                log.error("会话不存在: {}", request.getSessionId());
                return false;
            }
            
            // 创建消息记录
            CustomerServiceMessage message = new CustomerServiceMessage();
            message.setSessionId(session.getId());
            message.setSenderType(2); // 2-客服
            message.setSenderId(adminId); // sender_id是int类型，直接传入adminId
            message.setMessageType(1); // 1-文本消息
            message.setContent(request.getContent());
            message.setIsRead(false);
            
            // 手动设置创建时间为当前时间（北京时间）
            Date currentTime = new Date();
            message.setCreateTime(currentTime);
            
            boolean result = save(message);
            
            if (result) {
                // 更新会话的最后消息时间
                session.setLastMessageTime(currentTime);
                sessionDao.updateById(session);
            }
            
            return result;
        } catch (Exception e) {
            log.error("客服发送消息失败", e);
            return false;
        }
    }
}