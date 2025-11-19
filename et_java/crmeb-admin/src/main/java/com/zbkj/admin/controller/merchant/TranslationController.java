package com.zbkj.admin.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.model.translation.Translation;
import com.zbkj.common.page.CommonPage;
import com.zbkj.common.request.BatchTranslateRequest;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.common.response.CommonResult;
import com.zbkj.common.utils.SecurityUtil;
import com.zbkj.common.vo.LoginUserVo;
import com.zbkj.service.service.TranslationService;
import com.zbkj.service.service.MerchantTranslationPointsService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 商户端翻译管理控制器
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 */
@Slf4j
@RestController
@RequestMapping("api/admin/merchant/translation")
@Api(tags = "商户端翻译管理控制器")
public class TranslationController {

    @Autowired
    private TranslationService translationService;

    @Autowired
    private MerchantTranslationPointsService merchantTranslationPointsService;

    @Autowired(required = false)
    private com.zbkj.service.service.TranslationFailureRecordService translationFailureRecordService;

    /**
     * 安全获取商户ID的工具方法
     */
    private Integer getSafeMerId() {
        try {
            org.springframework.security.core.Authentication authentication = 
                org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            
            if (authentication == null) {
                log.error("Authentication 为 null，用户未认证");
                return null;
            }
            
            Object principal = authentication.getPrincipal();
            if (principal == null || !(principal instanceof LoginUserVo)) {
                log.error("Principal 为 null 或不是 LoginUserVo 类型: {}", principal != null ? principal.getClass().getName() : "null");
                return null;
            }
            
            LoginUserVo loginUserVo = (LoginUserVo) principal;
            if (loginUserVo.getUser() != null) {
                return loginUserVo.getUser().getMerId();
            }
        } catch (Exception e) {
            log.error("获取登录用户信息失败: {}", e.getMessage(), e);
        }
        return null;
    }

    /**
     * 获取翻译积分信息（商户端查看自己的积分，无需权限验证，只需登录）
     * 注意：虽然设置了虚拟权限标识 merchant:translation:view，但这里不需要 @PreAuthorize
     * 因为 Spring Security 配置中 .anyRequest().authenticated() 只需要认证即可
     */
    @ApiOperation(value = "获取翻译积分信息")
    @RequestMapping(value = "/points", method = RequestMethod.GET)
    public CommonResult<Map<String, Object>> getPoints() {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }

            log.info("获取商户翻译积分信息: merId={}", merId);
            Map<String, Object> result = merchantTranslationPointsService.getPointsInfo(merId);
            log.info("商户翻译积分信息: merId={}, result={}", merId, result);
            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("获取翻译积分信息失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取积分信息失败: " + e.getMessage());
        }
    }

    /**
     * 获取翻译列表（商户端查看自己的翻译记录，无需权限验证，只需登录）
     */
    @ApiOperation(value = "获取翻译列表")
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public CommonResult<CommonPage<Translation>> getList(
            @RequestParam(required = false) String entityType,
            @RequestParam(required = false) Integer entityId,
            @RequestParam(required = false) String targetLanguage,
            @Validated PageParamRequest pageParamRequest) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            
            PageInfo<Translation> pageInfo = 
                translationService.getTranslationList(entityType, entityId, targetLanguage, merId, pageParamRequest);
            
            return CommonResult.success(CommonPage.restPage(pageInfo));
        } catch (Exception e) {
            log.error("获取翻译列表失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取翻译列表失败: " + e.getMessage());
        }
    }

    /**
     * 批量翻译（优化版：优先查询缓存，只翻译未缓存的内容）
     * 用于商品添加页面的多语言翻译转换功能
     */
    @ApiOperation(value = "批量翻译（优化缓存查询）")
    @RequestMapping(value = "/batch", method = RequestMethod.POST)
    public CommonResult<Map<String, Map<String, String>>> batchTranslate(
            @RequestBody BatchTranslateRequest request) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }

            Map<String, Map<String, String>> result = translationService.batchTranslate(request, merId);
            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("批量翻译失败: {}", e.getMessage(), e);
            return CommonResult.failed("批量翻译失败: " + e.getMessage());
        }
    }

    /**
     * 批量翻译商品（已保存的商品）
     */
    @PreAuthorize("hasAuthority('merchant:translation:manage')")
    @ApiOperation(value = "批量翻译商品")
    @RequestMapping(value = "/batch/product", method = RequestMethod.POST)
    public CommonResult<String> batchTranslateProduct(
            @RequestBody Map<String, Object> params) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }

            Integer productId = (Integer) params.get("productId");
            String storeName = (String) params.get("storeName");
            String storeInfo = (String) params.get("storeInfo");
            String keyword = (String) params.get("keyword");
            String content = (String) params.get("content");  // 获取商品详情内容
            String[] targetLanguages = ((java.util.List<String>) params.get("targetLanguages"))
                                      .toArray(new String[0]);

            translationService.batchTranslateProduct(productId, storeName, storeInfo, 
                                                   keyword, content, targetLanguages, merId);

            return CommonResult.success("翻译成功");
        } catch (Exception e) {
            log.error("批量翻译失败: {}", e.getMessage(), e);
            return CommonResult.failed("批量翻译失败: " + e.getMessage());
        }
    }

    /**
     * 获取单个翻译（商户端查看自己的翻译，无需权限验证，只需登录）
     */
    @ApiOperation(value = "获取单个翻译")
    @RequestMapping(value = "/get", method = RequestMethod.GET)
    public CommonResult<Map<String, Object>> getTranslation(
            @RequestParam String entityType,
            @RequestParam Integer entityId,
            @RequestParam String fieldName,
            @RequestParam String targetLanguage) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }

            LambdaQueryWrapper<Translation> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Translation::getEntityType, entityType)
                   .eq(Translation::getEntityId, entityId)
                   .eq(Translation::getFieldName, fieldName)
                   .eq(Translation::getTargetLanguage, targetLanguage)
                   .eq(Translation::getMerId, merId)
                   .last("limit 1");
            
            Translation translation = translationService.getOne(wrapper);
            
            Map<String, Object> result = new HashMap<>();
            if (translation != null) {
                result.put("translation", translation.getTranslatedText());
                result.put("sourceText", translation.getSourceText());
                result.put("createTime", translation.getCreateTime());
            } else {
                result.put("translation", "");
            }

            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("获取单个翻译失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取翻译失败: " + e.getMessage());
        }
    }

    /**
     * 获取翻译统计（商户端查看自己的统计，无需权限验证，只需登录）
     */
    @ApiOperation(value = "获取翻译统计")
    @RequestMapping(value = "/statistics", method = RequestMethod.GET)
    public CommonResult<Map<String, Object>> getStatistics() {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            
            Map<String, Object> result = translationService.getStatistics(merId);
            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("获取翻译统计失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取翻译统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取翻译失败记录列表
     */
    @ApiOperation(value = "获取翻译失败记录列表")
    @RequestMapping(value = "/failure/list", method = RequestMethod.GET)
    public CommonResult<CommonPage<com.zbkj.common.model.translation.TranslationFailureRecord>> getFailureList(
            @RequestParam(required = false) String status,
            @Validated PageParamRequest pageParamRequest) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            
            if (translationFailureRecordService == null) {
                return CommonResult.failed("翻译失败记录服务未启用");
            }
            
            PageInfo<com.zbkj.common.model.translation.TranslationFailureRecord> pageInfo = 
                translationFailureRecordService.getFailureList(merId, status, pageParamRequest);
            
            return CommonResult.success(CommonPage.restPage(pageInfo));
        } catch (Exception e) {
            log.error("获取翻译失败记录列表失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取翻译失败记录列表失败: " + e.getMessage());
        }
    }

    /**
     * 重试单个失败的翻译
     */
    @ApiOperation(value = "重试单个失败的翻译")
    @RequestMapping(value = "/failure/retry", method = RequestMethod.POST)
    public CommonResult<String> retryTranslation(@RequestParam Integer recordId) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            
            if (translationFailureRecordService == null) {
                return CommonResult.failed("翻译失败记录服务未启用");
            }
            
            String result = translationFailureRecordService.retryTranslation(recordId, merId);
            return CommonResult.success(result, "重试翻译成功");
        } catch (Exception e) {
            log.error("重试翻译失败: {}", e.getMessage(), e);
            return CommonResult.failed("重试翻译失败: " + e.getMessage());
        }
    }

    /**
     * 批量重试失败的翻译
     */
    @ApiOperation(value = "批量重试失败的翻译")
    @RequestMapping(value = "/failure/batch-retry", method = RequestMethod.POST)
    public CommonResult<Integer> batchRetryTranslations(@RequestParam(required = false) String status) {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            
            if (translationFailureRecordService == null) {
                return CommonResult.failed("翻译失败记录服务未启用");
            }
            
            int successCount = translationFailureRecordService.batchRetryTranslations(merId, status);
            return CommonResult.success(successCount, "批量重试完成，成功 " + successCount + " 个");
        } catch (Exception e) {
            log.error("批量重试翻译失败: {}", e.getMessage(), e);
            return CommonResult.failed("批量重试翻译失败: " + e.getMessage());
        }
    }

    /**
     * 获取翻译失败统计
     */
    @ApiOperation(value = "获取翻译失败统计")
    @RequestMapping(value = "/failure/statistics", method = RequestMethod.GET)
    public CommonResult<Map<String, Object>> getFailureStatistics() {
        try {
            Integer merId = getSafeMerId();
            if (merId == null) {
                log.error("获取商户ID失败，用户未正确登录或不是商户用户");
                return CommonResult.failed("用户未正确登录或不是商户用户");
            }
            
            if (translationFailureRecordService == null) {
                return CommonResult.failed("翻译失败记录服务未启用");
            }
            
            Map<String, Object> result = translationFailureRecordService.getFailureStatistics(merId);
            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("获取翻译失败统计失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取翻译失败统计失败: " + e.getMessage());
        }
    }
}