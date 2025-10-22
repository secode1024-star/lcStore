package com.zbkj.admin.controller.platform;

import com.zbkj.common.request.customerservice.CustomerServiceConfigRequest;
import com.zbkj.common.request.customerservice.SendMessageRequest;
import com.zbkj.common.result.CommonResult;
import com.zbkj.common.response.customerservice.CustomerServiceConfigResponse;
import com.zbkj.common.response.customerservice.CustomerServiceMessageResponse;
import com.zbkj.common.response.customerservice.CustomerServiceSessionResponse;
import com.zbkj.service.service.CustomerServiceConfigService;
import com.zbkj.service.service.CustomerServiceMessageService;
import com.zbkj.service.service.CustomerServiceSessionService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 平台端客服管理控制器
 */
@Slf4j
@RestController
@RequestMapping("api/admin/platform/customer-service")
@Api(tags = "平台端客服管理")
@CrossOrigin(origins = "*", maxAge = 3600)
public class PlatformCustomerServiceController {

    @Autowired
    private CustomerServiceConfigService configService;

    @Autowired
    private CustomerServiceSessionService sessionService;

    @Autowired
    private CustomerServiceMessageService messageService;

    @ApiOperation(value = "获取客服配置")
    @RequestMapping(value = "/config", method = RequestMethod.GET)
    @PreAuthorize("hasAuthority('platform:customer-service:config:list')")
    public CommonResult<CustomerServiceConfigResponse> getConfig() {
        try {
            CustomerServiceConfigResponse config = configService.getConfig();
            return CommonResult.success(config);
        } catch (Exception e) {
            log.error("获取客服配置失败", e);
            return CommonResult.failed("获取客服配置失败");
        }
    }

    @ApiOperation(value = "保存客服配置")
    @RequestMapping(value = "/config", method = RequestMethod.POST)
    @PreAuthorize("hasAuthority('platform:customer-service:config:save')")
    public CommonResult<String> saveConfig(@RequestBody @Validated CustomerServiceConfigRequest request) {
        try {
            Boolean result = configService.saveConfig(request);
            if (result) {
                return CommonResult.success("保存成功");
            } else {
                return CommonResult.failed("保存失败");
            }
        } catch (Exception e) {
            log.error("保存客服配置失败", e);
            return CommonResult.failed("保存客服配置失败");
        }
    }

    @ApiOperation(value = "获取所有会话列表")
    @RequestMapping(value = "/sessions", method = RequestMethod.GET)
    @PreAuthorize("hasAuthority('platform:customer-service:session:list')")
    public CommonResult<List<CustomerServiceSessionResponse>> getSessionList() {
        try {
            List<CustomerServiceSessionResponse> sessions = sessionService.getSessionList();
            return CommonResult.success(sessions);
        } catch (Exception e) {
            log.error("获取会话列表失败", e);
            return CommonResult.failed("获取会话列表失败");
        }
    }

    @ApiOperation(value = "获取会话消息列表")
    @RequestMapping(value = "/messages/{sessionId}", method = RequestMethod.GET)
    @PreAuthorize("hasAuthority('platform:customer-service:message:list')")
    public CommonResult<List<CustomerServiceMessageResponse>> getMessages(@PathVariable String sessionId) {
        try {
            List<CustomerServiceMessageResponse> messages = messageService.getMessageList(sessionId);
            return CommonResult.success(messages);
        } catch (Exception e) {
            log.error("获取消息列表失败", e);
            return CommonResult.failed("获取消息列表失败");
        }
    }

    @ApiOperation(value = "客服发送消息")
    @RequestMapping(value = "/message/send", method = RequestMethod.POST)
    @PreAuthorize("hasAuthority('platform:customer-service:message:send')")
    public CommonResult<String> sendMessage(@RequestBody @Validated SendMessageRequest request) {
        try {
            // 使用默认客服ID 1
            Boolean result = messageService.sendMessageByService(request, 1);
            if (result) {
                return CommonResult.success("发送成功");
            } else {
                return CommonResult.failed("发送失败");
            }
        } catch (Exception e) {
            log.error("发送消息失败", e);
            return CommonResult.failed("发送消息失败");
        }
    }

    @ApiOperation(value = "标记消息为已读")
    @RequestMapping(value = "/messages/read/{sessionId}", method = RequestMethod.POST)
    @PreAuthorize("hasAuthority('platform:customer-service:message:read')")
    public CommonResult<String> markMessagesAsRead(@PathVariable String sessionId) {
        try {
            // 使用默认客服ID 1
            Boolean result = messageService.markMessagesAsRead(sessionId, 1);
            if (result) {
                return CommonResult.success("标记成功");
            } else {
                return CommonResult.failed("标记失败");
            }
        } catch (Exception e) {
            log.error("标记消息已读失败", e);
            return CommonResult.failed("标记消息已读失败");
        }
    }
}

