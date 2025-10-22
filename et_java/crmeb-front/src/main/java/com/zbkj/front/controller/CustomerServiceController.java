package com.zbkj.front.controller;

import com.zbkj.common.request.customerservice.SendMessageRequest;
import com.zbkj.common.response.CommonResult;
import com.zbkj.common.response.customerservice.CustomerServiceConfigResponse;
import com.zbkj.common.response.customerservice.CustomerServiceMessageResponse;
import com.zbkj.common.response.customerservice.CustomerServiceSessionResponse;
import com.zbkj.front.service.CustomerServiceFrontService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 客服相关接口 - 前端用户
 */
@Slf4j
@RestController
@RequestMapping("api/front/customer-service")
@Api(tags = "客服相关接口")
@CrossOrigin(origins = "*", maxAge = 3600)
public class CustomerServiceController {

    @Autowired
    private CustomerServiceFrontService customerServiceFrontService;

    @ApiOperation(value = "获取客服配置")
    @RequestMapping(value = "/config", method = RequestMethod.GET)
    public CommonResult<CustomerServiceConfigResponse> getConfig() {
        try {
            CustomerServiceConfigResponse config = customerServiceFrontService.getConfig();
            return CommonResult.success(config);
        } catch (Exception e) {
            log.error("获取客服配置失败", e);
            return CommonResult.failed("获取客服配置失败");
        }
    }

    @ApiOperation(value = "创建或获取会话")
    @RequestMapping(value = "/session/create", method = RequestMethod.POST)
    public CommonResult<CustomerServiceSessionResponse> createSession() {
        try {
            CustomerServiceSessionResponse session = customerServiceFrontService.createOrGetSession();
            return CommonResult.success(session);
        } catch (Exception e) {
            log.error("创建会话失败", e);
            return CommonResult.failed("创建会话失败");
        }
    }

    @ApiOperation(value = "获取会话消息列表")
    @RequestMapping(value = "/messages/{sessionId}", method = RequestMethod.GET)
    public CommonResult<List<CustomerServiceMessageResponse>> getMessages(@PathVariable String sessionId) {
        try {
            List<CustomerServiceMessageResponse> messages = customerServiceFrontService.getMessages(sessionId);
            return CommonResult.success(messages);
        } catch (Exception e) {
            log.error("获取消息列表失败", e);
            return CommonResult.failed("获取消息列表失败");
        }
    }

    @ApiOperation(value = "发送消息")
    @RequestMapping(value = "/message/send", method = RequestMethod.POST)
    public CommonResult<String> sendMessage(@RequestBody @Validated SendMessageRequest request) {
        try {
            Boolean result = customerServiceFrontService.sendMessage(request);
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
    public CommonResult<String> markMessagesAsRead(@PathVariable String sessionId) {
        try {
            Boolean result = customerServiceFrontService.markMessagesAsRead(sessionId);
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






