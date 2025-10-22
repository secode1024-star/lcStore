package com.zbkj.service.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zbkj.common.model.customerservice.CustomerServiceConfig;
import com.zbkj.common.response.customerservice.CustomerServiceConfigResponse;
import com.zbkj.service.dao.CustomerServiceConfigDao;
import com.zbkj.service.service.CustomerServiceConfigService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.time.LocalTime;

/**
 * 客服配置服务实现类
 */
@Slf4j
@Service
public class CustomerServiceConfigServiceImpl extends ServiceImpl<CustomerServiceConfigDao, CustomerServiceConfig> implements CustomerServiceConfigService {

    @Override
    public CustomerServiceConfigResponse getConfig() {
        // 获取第一条配置记录
        LambdaQueryWrapper<CustomerServiceConfig> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByAsc(CustomerServiceConfig::getId);
        wrapper.last("LIMIT 1");
        
        CustomerServiceConfig config = getOne(wrapper);
        if (config == null) {
            // 如果没有配置，返回默认配置
            return getDefaultConfig();
        }
        
        CustomerServiceConfigResponse response = new CustomerServiceConfigResponse();
        BeanUtils.copyProperties(config, response);
        
        // 保持用户设置的状态，不自动修改
        // 用户可以手动设置在线/离线状态，系统不应该自动覆盖
        // 将数据库的Integer类型转换为Boolean类型返回给前端
        Integer dbStatus = config.getStatus() != null ? config.getStatus() : 1;
        Boolean finalStatus = dbStatus == 1;
        log.info("getConfig - 数据库中的status: {}, 转换后返回的status: {}", dbStatus, finalStatus);
        response.setStatus(finalStatus);
        
        return response;
    }
    
    private CustomerServiceConfigResponse getDefaultConfig() {
        CustomerServiceConfigResponse response = new CustomerServiceConfigResponse();
        response.setTitle("在线客服");
        response.setServiceName("客服小助手");
        response.setWelcomeMessage("您好！欢迎咨询，我是您的专属客服，有什么可以帮助您的吗？");
        response.setOfflineMessage("客服暂时离线，请留言或稍后再试。");
        response.setStatus(true); // 默认在线
        response.setAutoReply(true);
        response.setAutoReplyMessage("您好，我已收到您的消息，稍后会为您详细解答。");
        response.setIsEnabled(true);
        return response;
    }
    
    @Override
    public Boolean saveConfig(com.zbkj.common.request.customerservice.CustomerServiceConfigRequest request) {
        try {
            log.info("开始保存客服配置，请求数据: {}", request);
            
            // 获取第一条配置记录
            LambdaQueryWrapper<CustomerServiceConfig> wrapper = new LambdaQueryWrapper<>();
            wrapper.orderByAsc(CustomerServiceConfig::getId);
            wrapper.last("LIMIT 1");
            
            CustomerServiceConfig config = getOne(wrapper);
            log.info("查询到的现有配置: {}", config);
            
            if (config == null) {
                // 创建新配置
                config = new CustomerServiceConfig();
                log.info("创建新的配置对象");
            }
            
            // 更新配置
            if (request.getTitle() != null) {
                config.setTitle(request.getTitle());
                log.debug("设置标题: {}", request.getTitle());
            }
            if (request.getServiceName() != null) {
                config.setServiceName(request.getServiceName());
                log.debug("设置客服名称: {}", request.getServiceName());
            }
            if (request.getWelcomeMessage() != null) {
                config.setWelcomeMessage(request.getWelcomeMessage());
                log.debug("设置欢迎消息: {}", request.getWelcomeMessage());
            }
            if (request.getOfflineMessage() != null) {
                config.setOfflineMessage(request.getOfflineMessage());
                log.debug("设置离线消息: {}", request.getOfflineMessage());
            }
            if (request.getStatus() != null) {
                log.info("接收到的status值: {}, 类型: {}", request.getStatus(), request.getStatus().getClass().getSimpleName());
                // 将Boolean类型转换为Integer类型存储到数据库
                Integer statusValue = request.getStatus() ? 1 : 0;
                log.info("Boolean转Integer: {} -> {}", request.getStatus(), statusValue);
                config.setStatus(statusValue);
                log.info("设置后的config.status: {}", config.getStatus());
            }
            if (request.getAutoReply() != null) {
                config.setAutoReply(request.getAutoReply());
                log.debug("设置自动回复: {}", request.getAutoReply());
            }
            if (request.getAutoReplyMessage() != null) {
                config.setAutoReplyMessage(request.getAutoReplyMessage());
                log.debug("设置自动回复消息: {}", request.getAutoReplyMessage());
            }
            if (request.getIsEnabled() != null) {
                config.setIsEnabled(request.getIsEnabled());
                log.debug("设置是否启用: {}", request.getIsEnabled());
            }
            if (request.getWorkingHoursStart() != null) {
                try {
                    config.setWorkingHoursStart(java.sql.Time.valueOf(request.getWorkingHoursStart()));
                    log.debug("设置工作开始时间: {}", request.getWorkingHoursStart());
                } catch (Exception e) {
                    log.error("工作开始时间格式错误: {}", request.getWorkingHoursStart(), e);
                    throw new RuntimeException("工作开始时间格式错误: " + request.getWorkingHoursStart());
                }
            }
            if (request.getWorkingHoursEnd() != null) {
                try {
                    config.setWorkingHoursEnd(java.sql.Time.valueOf(request.getWorkingHoursEnd()));
                    log.debug("设置工作结束时间: {}", request.getWorkingHoursEnd());
                } catch (Exception e) {
                    log.error("工作结束时间格式错误: {}", request.getWorkingHoursEnd(), e);
                    throw new RuntimeException("工作结束时间格式错误: " + request.getWorkingHoursEnd());
                }
            }
            
            log.info("准备保存的配置对象: {}", config);
            Boolean result = saveOrUpdate(config);
            log.info("保存结果: {}", result);
            
            return result;
        } catch (Exception e) {
            log.error("保存客服配置失败", e);
            throw e;
        }
    }
}