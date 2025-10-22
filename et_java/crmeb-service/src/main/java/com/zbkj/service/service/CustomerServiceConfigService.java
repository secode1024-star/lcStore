package com.zbkj.service.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.zbkj.common.model.customerservice.CustomerServiceConfig;
import com.zbkj.common.response.customerservice.CustomerServiceConfigResponse;

/**
 * 客服配置服务接口
 */
public interface CustomerServiceConfigService extends IService<CustomerServiceConfig> {
    
    /**
     * 获取客服配置
     */
    CustomerServiceConfigResponse getConfig();
    
    /**
     * 保存客服配置
     */
    Boolean saveConfig(com.zbkj.common.request.customerservice.CustomerServiceConfigRequest request);
}