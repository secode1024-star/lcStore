package com.zbkj.front.controller;

import com.zbkj.common.page.CommonPage;
import com.zbkj.common.request.EditMySignatureRequest;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.common.response.CommunityUserHomePageResponse;
import com.zbkj.common.response.CommunityUserResponse;
import com.zbkj.common.utils.MessageUtils;
import com.zbkj.front.service.CommunityFrontService;
import io.swagger.annotations.Api;
import com.zbkj.common.response.CommonResult;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * @ClassName CommunityController
 * @Description 社区用户中心控制器
 * @Author HZW
 * @Date 2023/3/13 9:19
 * @Version v1.2
 */
@Slf4j
@RestController
@RequestMapping("api/front/community/user")
@Api(tags = "社区用户中心控制器")
public class CommunityUserCenterController {

    @Autowired
    private CommunityFrontService communityFrontService;

    @ApiOperation(value = "我的主页")
    @RequestMapping(value = "/my/home/page", method = RequestMethod.GET)
    public CommonResult<CommunityUserHomePageResponse> getMyHomePage() {
        return CommonResult.success(communityFrontService.getMyHomePage());
    }

    @ApiOperation(value = "我的关注列表")
    @RequestMapping(value = "/my/concerned/list", method = RequestMethod.GET)
    public CommonResult<CommonPage<CommunityUserResponse>> findMyConcernedList(PageParamRequest request) {
        return CommonResult.success(CommonPage.restPage(communityFrontService.findMyConcernedList(request)));
    }

    @ApiOperation(value = "我的粉丝列表")
    @RequestMapping(value = "/my/fans/list", method = RequestMethod.GET)
    public CommonResult<CommonPage<CommunityUserResponse>> findMyFansList(PageParamRequest request) {
        return CommonResult.success(CommonPage.restPage(communityFrontService.findMyFansList(request)));
    }

    @ApiOperation(value = "编辑个性签名")
    @RequestMapping(value = "/edit/signature", method = RequestMethod.POST)
    public CommonResult<String> editMySignature(@RequestBody @Validated EditMySignatureRequest request) {
        communityFrontService.editMySignature(request);
        return CommonResult.success(MessageUtils.message("front.communityUserCenter.error.a"));
    }
}
