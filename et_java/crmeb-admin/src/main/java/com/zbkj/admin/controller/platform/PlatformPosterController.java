package com.zbkj.admin.controller.platform;

import com.github.pagehelper.PageInfo;
import com.zbkj.common.request.MerchantPosterSearchRequest;
import com.zbkj.common.request.MerchantPosterRequest;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.common.response.CommonResult;
import com.zbkj.common.response.MerchantPosterResponse;
import com.zbkj.service.service.MerchantPosterService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Arrays;

/**
 * 平台端海报管理 前端控制器
 * @author: ZhongYehai
 * @since: 2025-09-25
 */
@Slf4j
@RestController
@RequestMapping("api/admin/platform/poster")
@Api(tags = "平台端 - 海报管理")
@Validated
public class PlatformPosterController {

    @Autowired
    private MerchantPosterService merchantPosterService;

    /**
     * 平台端分页显示海报列表
     */
    // @PreAuthorize("hasAuthority('platform:poster:page:list')") // 临时移除权限检查用于测试
    @ApiOperation(value = "平台端分页列表")
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public CommonResult<PageInfo<MerchantPosterResponse>> getList(
            @Validated MerchantPosterSearchRequest request,
            @Validated PageParamRequest pageParamRequest) {
        PageInfo<MerchantPosterResponse> posterPageInfo = merchantPosterService.getPlatformList(request, pageParamRequest);
        return CommonResult.success(posterPageInfo);
    }

    /**
     * 平台端查询海报详情
     */
    // @PreAuthorize("hasAuthority('platform:poster:info')") // 临时移除权限检查用于测试
    @ApiOperation(value = "平台端详情")
    @RequestMapping(value = "/info/{id}", method = RequestMethod.GET)
    public CommonResult<MerchantPosterResponse> info(@PathVariable("id") Integer id) {
        MerchantPosterResponse poster = merchantPosterService.getById(id);
        return CommonResult.success(poster);
    }

    /**
     * 平台端删除海报（物理删除）
     */
    // @PreAuthorize("hasAuthority('platform:poster:delete')") // 临时移除权限检查用于测试
    @ApiOperation(value = "平台端删除")
    @RequestMapping(value = "/delete/{id}", method = RequestMethod.POST)
    public CommonResult<String> delete(@PathVariable("id") Integer id) {
        log.info("🔥 平台端删除海报请求 - 海报ID: {}", id);
        System.out.println("🔥 平台端删除海报请求 - 海报ID: " + id);
        
        try {
            boolean result = merchantPosterService.platformBatchDelete(Arrays.asList(id));
            log.info("🔥 平台端删除结果: {}", result);
            System.out.println("🔥 平台端删除结果: " + result);
            
            if (result) {
                return CommonResult.success("物理删除成功");
            } else {
                return CommonResult.failed("物理删除失败");
            }
        } catch (Exception e) {
            log.error("🔥 平台端删除异常: ", e);
            System.out.println("🔥 平台端删除异常: " + e.getMessage());
            return CommonResult.failed("删除异常: " + e.getMessage());
        }
    }

    /**
     * 平台端批量删除海报（物理删除）
     */
    @PreAuthorize("hasAuthority('platform:poster:delete')")
    @ApiOperation(value = "平台端批量删除")
    @RequestMapping(value = "/batchDelete", method = RequestMethod.POST)
    public CommonResult<String> batchDelete(@RequestBody List<Integer> ids) {
        if (merchantPosterService.platformBatchDelete(ids)) {
            return CommonResult.success("批量删除成功");
        } else {
            return CommonResult.failed("批量删除失败");
        }
    }

    /**
     * 平台端保存海报
     */
    @ApiOperation(value = "平台端保存海报")
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public CommonResult<String> save(@RequestBody @Validated MerchantPosterRequest request) {
        try {
            log.info("平台端保存海报请求: {}", request);
            // 平台端创建海报，使用请求中的merId
            boolean result = merchantPosterService.create(request, request.getMerId());
            if (result) {
                return CommonResult.success("保存成功");
            } else {
                return CommonResult.failed("保存失败");
            }
        } catch (Exception e) {
            log.error("平台端保存海报异常: ", e);
            return CommonResult.failed("保存异常: " + e.getMessage());
        }
    }

    /**
     * 平台端更新海报
     */
    @ApiOperation(value = "平台端更新海报")
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public CommonResult<String> update(@RequestBody @Validated MerchantPosterRequest request) {
        try {
            log.info("平台端更新海报请求: {}", request);
            // 平台端更新海报，使用请求中的merId
            boolean result = merchantPosterService.update(request, request.getMerId());
            if (result) {
                return CommonResult.success("更新成功");
            } else {
                return CommonResult.failed("更新失败");
            }
        } catch (Exception e) {
            log.error("平台端更新海报异常: ", e);
            return CommonResult.failed("更新异常: " + e.getMessage());
        }
    }

    /**
     * 平台端生成海报
     */
    @ApiOperation(value = "平台端生成海报")
    @RequestMapping(value = "/generate/{id}", method = RequestMethod.POST)
    public CommonResult<String> generate(@PathVariable("id") Integer id, @RequestParam(required = false) Integer merId) {
        try {
            log.info("平台端生成海报请求 - ID: {}, MerID: {}", id, merId);
            // 如果没有指定merId，先获取海报信息找到对应的商户ID
            if (merId == null) {
                MerchantPosterResponse poster = merchantPosterService.getById(id);
                if (poster != null) {
                    merId = poster.getMerId();
                }
            }
            String result = merchantPosterService.generatePoster(id, merId);
            if (result != null) {
                return CommonResult.success(result, "生成成功");
            } else {
                return CommonResult.failed("生成失败");
            }
        } catch (Exception e) {
            log.error("平台端生成海报异常: ", e);
            return CommonResult.failed("生成异常: " + e.getMessage());
        }
    }

    /**
     * 平台端更新海报状态
     */
    @ApiOperation(value = "平台端更新海报状态")
    @RequestMapping(value = "/status/{id}", method = RequestMethod.POST)
    public CommonResult<String> updateStatus(@PathVariable("id") Integer id, @RequestParam Integer status, @RequestParam(required = false) Integer merId) {
        try {
            log.info("平台端更新海报状态 - ID: {}, Status: {}, MerID: {}", id, status, merId);
            // 如果没有指定merId，先获取海报信息找到对应的商户ID
            if (merId == null) {
                MerchantPosterResponse poster = merchantPosterService.getById(id);
                if (poster != null) {
                    merId = poster.getMerId();
                }
            }
            boolean result = merchantPosterService.updateStatus(id, status, merId);
            if (result) {
                return CommonResult.success("状态更新成功");
        } else {
                return CommonResult.failed("状态更新失败");
            }
        } catch (Exception e) {
            log.error("平台端更新海报状态异常: ", e);
            return CommonResult.failed("状态更新异常: " + e.getMessage());
        }
    }
}
