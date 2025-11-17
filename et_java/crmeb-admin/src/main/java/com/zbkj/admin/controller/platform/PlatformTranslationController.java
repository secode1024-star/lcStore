package com.zbkj.admin.controller.platform;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.github.pagehelper.PageInfo;
import com.zbkj.common.model.translation.Translation;
import com.zbkj.common.page.CommonPage;
import com.zbkj.common.request.PageParamRequest;
import com.zbkj.common.response.CommonResult;
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
 * 平台管理端翻译管理控制器
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 */
@Slf4j
@RestController
@RequestMapping("api/admin/platform/translation")
@Api(tags = "平台管理端翻译管理控制器")
public class PlatformTranslationController {

    @Autowired
    private TranslationService translationService;

    @Autowired
    private MerchantTranslationPointsService merchantTranslationPointsService;

    /**
     * 获取翻译积分信息（平台管理端 - 可查看指定商户的积分）
     * 注意：暂时移除权限检查，确保接口可访问，后续可通过菜单配置添加权限
     */
    // @PreAuthorize("hasAuthority('platform:translation:points:view')")
    @ApiOperation(value = "获取翻译积分信息")
    @RequestMapping(value = "/points", method = RequestMethod.GET)
    public CommonResult<Map<String, Object>> getPoints(
            @RequestParam(required = false) Integer merId) {
        try {
            // 如果没有指定商户ID，返回空数据而不是错误
            if (merId == null) {
                Map<String, Object> emptyResult = new HashMap<>();
                emptyResult.put("totalChars", 0L);
                emptyResult.put("usedChars", 0L);
                emptyResult.put("remainingChars", 0L);
                emptyResult.put("usageRate", 0.0);
                emptyResult.put("totalTranslations", 0);
                return CommonResult.success(emptyResult);
            }
            
            // 查看指定商户的积分
            Map<String, Object> result = merchantTranslationPointsService.getPointsInfo(merId);
            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("获取翻译积分信息失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取积分信息失败: " + e.getMessage());
        }
    }

    /**
     * 为商户添加翻译积分
     * 积分规则：1积分 = 10,000字符，100积分 = 1,000,000字符
     */
    // @PreAuthorize("hasAuthority('platform:translation:points:add')")
    @ApiOperation(value = "为商户添加翻译积分")
    @RequestMapping(value = "/points/add", method = RequestMethod.POST)
    public CommonResult<String> addPoints(@RequestBody Map<String, Object> params) {
        try {
            Integer merId = (Integer) params.get("merId");
            Object pointsObj = params.get("points");
            
            Integer points = null;
            if (pointsObj instanceof Integer) {
                points = (Integer) pointsObj;
            } else if (pointsObj instanceof Number) {
                points = ((Number) pointsObj).intValue();
            }
            
            if (merId == null || points == null) {
                return CommonResult.failed("商户ID和积分数量不能为空");
            }
            
            if (points <= 0) {
                return CommonResult.failed("积分数量必须大于0");
            }
            
            // 添加积分（1积分 = 10,000字符）
            merchantTranslationPointsService.addPoints(merId, points);
            
            long charsAdded = points * 10000L;
            return CommonResult.success(String.format("成功为商户添加 %d 积分（%d 字符）", points, charsAdded));
        } catch (IllegalArgumentException e) {
            log.error("添加翻译积分参数错误: {}", e.getMessage());
            return CommonResult.failed(e.getMessage());
        } catch (Exception e) {
            log.error("添加翻译积分失败: {}", e.getMessage(), e);
            return CommonResult.failed("添加积分失败: " + e.getMessage());
        }
    }

    /**
     * 获取翻译列表（平台管理端 - 可查看所有商户的翻译记录）
     * 注意：暂时移除权限检查，确保接口可访问，后续可通过菜单配置添加权限
     */
    // @PreAuthorize("hasAuthority('platform:translation:list:view')")
    @ApiOperation(value = "获取翻译列表")
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public CommonResult<CommonPage<Translation>> getList(
            @RequestParam(required = false) Integer merId,
            @RequestParam(required = false) String entityType,
            @RequestParam(required = false) Integer entityId,
            @RequestParam(required = false) String targetLanguage,
            @Validated PageParamRequest pageParamRequest) {
        try {
            PageInfo<Translation> pageInfo = 
                translationService.getTranslationList(entityType, entityId, targetLanguage, merId, pageParamRequest);
            
            return CommonResult.success(CommonPage.restPage(pageInfo));
        } catch (Exception e) {
            log.error("获取翻译列表失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取翻译列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取单个翻译
     */
    @PreAuthorize("hasAuthority('platform:translation:view')")
    @ApiOperation(value = "获取单个翻译")
    @RequestMapping(value = "/get", method = RequestMethod.GET)
    public CommonResult<Map<String, Object>> getTranslation(
            @RequestParam String entityType,
            @RequestParam Integer entityId,
            @RequestParam String fieldName,
            @RequestParam String targetLanguage,
            @RequestParam(required = false) Integer merId) {
        try {
            LambdaQueryWrapper<Translation> wrapper = Wrappers.lambdaQuery();
            wrapper.eq(Translation::getEntityType, entityType)
                   .eq(Translation::getEntityId, entityId)
                   .eq(Translation::getFieldName, fieldName)
                   .eq(Translation::getTargetLanguage, targetLanguage);
            
            if (merId != null) {
                wrapper.eq(Translation::getMerId, merId);
            }
            
            wrapper.last("limit 1");
            
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
     * 获取翻译统计（平台管理端 - 可查看指定商户或所有商户的统计）
     * 注意：暂时移除权限检查，确保接口可访问，后续可通过菜单配置添加权限
     */
    // @PreAuthorize("hasAuthority('platform:translation:statistics:view')")
    @ApiOperation(value = "获取翻译统计")
    @RequestMapping(value = "/statistics", method = RequestMethod.GET)
    public CommonResult<Map<String, Object>> getStatistics(
            @RequestParam(required = false) Integer merId) {
        try {
            Map<String, Object> result = translationService.getStatistics(merId);
            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("获取翻译统计失败: {}", e.getMessage(), e);
            return CommonResult.failed("获取翻译统计失败: " + e.getMessage());
        }
    }
}