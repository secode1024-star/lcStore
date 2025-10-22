package com.zbkj.admin.controller.merchant;

import com.github.pagehelper.PageInfo;
import com.zbkj.common.request.MerchantPosterRequest;
import com.zbkj.common.request.MerchantPosterSearchRequest;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.common.response.CommonResult;
import com.zbkj.common.response.MerchantPosterResponse;
import com.zbkj.common.response.StoreProductWithCouponResponse;
import com.zbkj.common.utils.SecurityUtil;
import com.zbkj.service.service.MerchantPosterService;
import com.zbkj.service.service.StoreProductService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 商户海报管理 前端控制器
 * @author: ZhongYehai
 * @since: 2025-09-23
 */
@Slf4j
@RestController
@RequestMapping("api/admin/merchant/poster")
@Api(tags = "商户端 - 海报管理")
@Validated
public class MerchantPosterController {

    @Autowired
    private MerchantPosterService merchantPosterService;

    @Autowired
    private StoreProductService storeProductService;

    /**
     * 安全获取商户ID的工具方法
     */
    private Integer getSafeMerId() {
        try {
            if (SecurityUtil.getLoginUserVo() != null && 
                SecurityUtil.getLoginUserVo().getUser() != null) {
                return SecurityUtil.getLoginUserVo().getUser().getMerId();
            }
        } catch (Exception e) {
            log.error("获取登录用户信息失败: {}", e.getMessage());
        }
        return null;
    }

    /**
     * 分页显示海报列表
     */
    // 临时移除权限验证，等权限配置完成后再启用
    // @PreAuthorize("hasAuthority('merchant:poster:page:list')")
    @ApiOperation(value = "分页列表")
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public CommonResult<PageInfo<MerchantPosterResponse>> getList(
            @Validated MerchantPosterSearchRequest request,
            @Validated PageParamRequest pageParamRequest) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            
            PageInfo<MerchantPosterResponse> posterPageInfo = merchantPosterService.getMerchantList(merId, request, pageParamRequest);
            return CommonResult.success(posterPageInfo);
        } catch (Exception e) {
            log.error("获取海报列表失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取海报列表失败: " + e.getMessage());
        }
    }

    /**
     * 查询海报详情
     */
    // @PreAuthorize("hasAuthority('merchant:poster:info')")
    @ApiOperation(value = "详情")
    @RequestMapping(value = "/info/{id}", method = RequestMethod.GET)
    public CommonResult<MerchantPosterResponse> info(@PathVariable("id") Integer id) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            MerchantPosterResponse poster = merchantPosterService.getByIdAndMerId(id, merId);
            return CommonResult.success(poster);
        } catch (Exception e) {
            log.error("获取海报详情失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取海报详情失败: " + e.getMessage());
        }
    }

    /**
     * 新增海报
     */
    // @PreAuthorize("hasAuthority('merchant:poster:save')")
    @ApiOperation(value = "新增")
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public CommonResult<String> save(@RequestBody @Valid MerchantPosterRequest request) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            if (merchantPosterService.create(request, merId)) {
                return CommonResult.success();
            } else {
                return CommonResult.failed();
            }
        } catch (Exception e) {
            log.error("新增海报失败: {}", e.getMessage(), e);
            return CommonResult.failed("新增海报失败: " + e.getMessage());
        }
    }

    /**
     * 修改海报
     */
    // @PreAuthorize("hasAuthority('merchant:poster:update')")
    @ApiOperation(value = "修改")
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public CommonResult<String> update(@RequestBody @Valid MerchantPosterRequest request) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            if (merchantPosterService.update(request, merId)) {
                return CommonResult.success();
            } else {
                return CommonResult.failed();
            }
        } catch (Exception e) {
            log.error("修改海报失败: {}", e.getMessage(), e);
            return CommonResult.failed("修改海报失败: " + e.getMessage());
        }
    }

    /**
     * 删除海报
     */
    // @PreAuthorize("hasAuthority('merchant:poster:delete')")
    @ApiOperation(value = "删除")
    @RequestMapping(value = "/delete/{id}", method = RequestMethod.POST)
    public CommonResult<String> delete(@PathVariable("id") Integer id) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            if (merchantPosterService.delete(id, merId)) {
                return CommonResult.success();
            } else {
                return CommonResult.failed();
            }
        } catch (Exception e) {
            log.error("删除海报失败: {}", e.getMessage(), e);
            return CommonResult.failed("删除海报失败: " + e.getMessage());
        }
    }

    /**
     * 批量删除海报
     */
    // @PreAuthorize("hasAuthority('merchant:poster:delete')")
    @ApiOperation(value = "批量删除")
    @RequestMapping(value = "/batch/delete", method = RequestMethod.POST)
    public CommonResult<String> batchDelete(@RequestBody List<Integer> ids) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            if (merchantPosterService.batchDelete(ids, merId)) {
                return CommonResult.success();
            } else {
                return CommonResult.failed();
            }
        } catch (Exception e) {
            log.error("批量删除海报失败: {}", e.getMessage(), e);
            return CommonResult.failed("批量删除海报失败: " + e.getMessage());
        }
    }

    /**
     * 生成海报
     */
    // @PreAuthorize("hasAuthority('merchant:poster:generate')")
    @ApiOperation(value = "生成海报")
    @RequestMapping(value = "/generate/{id}", method = RequestMethod.POST)
    public CommonResult<String> generatePoster(@PathVariable("id") Integer id) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            String posterUrl = merchantPosterService.generatePoster(id, merId);
            return CommonResult.success(posterUrl);
        } catch (Exception e) {
            log.error("生成海报失败: {}", e.getMessage(), e);
            return CommonResult.failed("生成海报失败: " + e.getMessage());
        }
    }

    /**
     * 更新海报状态
     */
    // @PreAuthorize("hasAuthority('merchant:poster:status')")
    @ApiOperation(value = "更新状态")
    @RequestMapping(value = "/status/{id}", method = RequestMethod.POST)
    public CommonResult<String> updateStatus(@PathVariable("id") Integer id, @RequestParam("status") Boolean status) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            if (merchantPosterService.updateStatus(id, status ? 1 : 0, merId)) {
                return CommonResult.success();
            } else {
                return CommonResult.failed();
            }
        } catch (Exception e) {
            log.error("更新海报状态失败: {}", e.getMessage(), e);
            return CommonResult.failed("更新海报状态失败: " + e.getMessage());
        }
    }

    /**
     * 获取商品详情（包含优惠券信息）- 用于海报生成
     */
    @ApiOperation(value = "获取商品详情（含优惠券信息）")
    @RequestMapping(value = "/product-detail/{productId}", method = RequestMethod.GET)
    public CommonResult<StoreProductWithCouponResponse> getProductDetailWithCoupon(@PathVariable("productId") Integer productId) {
        System.out.println("=== 🎯🎯🎯 CONTROLLER被调用了!!! 商品ID: " + productId + " ===");
        log.info("🎯 Controller被调用 - 商品ID: {}", productId);
        try {
            StoreProductWithCouponResponse productDetail = storeProductService.getProductDetailWithCoupon(productId);
            System.out.println("=== ✅✅✅ Controller调用成功!!! 商品ID: " + productId + " ===");
            log.info("✅ Controller调用成功 - 商品ID: {}", productId);
            return CommonResult.success(productDetail);
        } catch (Exception e) {
            System.out.println("=== ❌❌❌ Controller调用失败!!! 商品ID: " + productId + ", 错误: " + e.getMessage() + " ===");
            log.error("❌ Controller调用失败，商品ID: {}, 错误: {}", productId, e.getMessage(), e);
            return CommonResult.failed("获取商品详情失败: " + e.getMessage());
        }
    }

    @ApiOperation(value = "测试接口")
    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public CommonResult<String> test() {
        System.out.println("=== 🧪🧪🧪 测试接口被调用了!!! ===");
        return CommonResult.success("测试成功！新接口工作正常！");
    }

}















