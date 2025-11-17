package com.zbkj.front.controller;

import com.zbkj.common.request.CategoryTranslationRequest;
import com.zbkj.common.result.CommonResult;
import com.zbkj.service.service.TranslationService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.Map;

/**
 * 分类翻译控制器
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 */
@Slf4j
@RestController
@RequestMapping("api/front/translation")
@Api(tags = "分类翻译控制器")
public class CategoryTranslationController {

    @Autowired
    private TranslationService translationService;

    /**
     * 单个分类名称翻译接口
     * 优先使用数据库中已存储的翻译内容，没有的才调用API翻译
     * @param request 翻译请求参数
     * @return 翻译结果
     */
    @ApiOperation(value = "单个分类名称翻译")
    @PostMapping("/category/single")
    public CommonResult<Map<String, String>> translateSingleCategory(@RequestBody @Valid CategoryTranslationRequest request) {
        try {
            log.info("开始翻译分类: {} -> {}", request.getOriginalText(), request.getTargetLang());
            
            // 优先使用数据库中的翻译内容（不调用API）
            String translatedText = translationService.getCachedTranslation(
                    request.getEntityType() != null ? request.getEntityType() : "category",
                    request.getEntityId(),
                    "name", // 分类名称字段
                    request.getTargetLang(),
                    request.getOriginalText(),
                    request.getMerId()
            );
            
            // 如果数据库中没有翻译内容且不等于原文，则调用API翻译
            if (translatedText.equals(request.getOriginalText())) {
                log.info("数据库中未找到翻译内容，调用API翻译: {} -> {}", request.getOriginalText(), request.getTargetLang());
                translatedText = translationService.getTranslation(
                        request.getEntityType() != null ? request.getEntityType() : "category",
                        request.getEntityId(),
                        "name", // 分类名称字段
                        request.getTargetLang(),
                        request.getOriginalText(),
                        request.getMerId()
                );
            } else {
                log.debug("使用数据库缓存翻译: {} -> {}", request.getOriginalText(), translatedText);
            }
            
            Map<String, String> result = new HashMap<>();
            result.put("originalText", request.getOriginalText());
            result.put("translatedText", translatedText);
            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("单个分类翻译失败: {}", e.getMessage(), e);
            return CommonResult.failed("翻译失败: " + e.getMessage());
        }
    }

    /**
     * 翻译分类名称（旧接口，保持兼容性）
     */
    @ApiOperation(value = "翻译分类名称")
    @PostMapping("/category")
    public CommonResult<Map<String, Object>> translateCategory(@RequestBody Map<String, Object> request) {
        try {
            Integer categoryId = (Integer) request.get("categoryId");
            String categoryName = (String) request.get("categoryName");
            String targetLanguage = (String) request.get("targetLanguage");
            String entityType = (String) request.get("entityType");
            Integer entityId = (Integer) request.get("entityId");
            String fieldName = (String) request.get("fieldName");

            log.info("开始翻译分类: categoryId={}, categoryName={}, targetLanguage={}", 
                    categoryId, categoryName, targetLanguage);

            // 如果是中文，直接返回原文
            if ("zh-CN".equals(targetLanguage)) {
                Map<String, Object> result = new HashMap<>();
                result.put("translatedText", categoryName);
                result.put("fromCache", false);
                result.put("language", targetLanguage);
                return CommonResult.success(result);
            }

            // 优先使用数据库缓存，然后才调用翻译API
            String translatedText = translationService.getCachedTranslation(
                entityType != null ? entityType : "category",
                entityId != null ? entityId : categoryId,
                fieldName != null ? fieldName : "name",
                targetLanguage,
                categoryName,
                null // 分类翻译不需要商户ID
            );
            
            // 如果数据库中没有翻译内容，则调用API翻译
            if (translatedText.equals(categoryName)) {
                log.info("数据库中未找到翻译内容，调用API翻译: {} -> {}", categoryName, targetLanguage);
                translatedText = translationService.getTranslation(
                    entityType != null ? entityType : "category",
                    entityId != null ? entityId : categoryId,
                    fieldName != null ? fieldName : "name",
                    targetLanguage,
                    categoryName,
                    null // 分类翻译不需要商户ID
                );
            } else {
                log.debug("使用数据库缓存翻译: {} -> {}", categoryName, translatedText);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("translatedText", translatedText);
            result.put("originalText", categoryName);
            result.put("language", targetLanguage);
            result.put("categoryId", categoryId);
            
            // 判断是否来自缓存
            boolean fromCache = !translatedText.equals(categoryName);
            result.put("fromCache", fromCache);

            log.info("分类翻译完成: {} -> {}, fromCache={}", categoryName, translatedText, fromCache);

            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("分类翻译失败", e);
            return CommonResult.failed("翻译失败: " + e.getMessage());
        }
    }

    /**
     * 批量翻译分类
     */
    @ApiOperation(value = "批量翻译分类")
    @PostMapping("/category/batch")
    public CommonResult<Map<String, Object>> batchTranslateCategories(@RequestBody Map<String, Object> request) {
        try {
            @SuppressWarnings("unchecked")
            java.util.List<Map<String, Object>> categories = 
                (java.util.List<Map<String, Object>>) request.get("categories");
            String targetLanguage = (String) request.get("targetLanguage");

            log.info("开始批量翻译分类: {} 个分类 -> {}", categories.size(), targetLanguage);

            Map<String, String> translations = new HashMap<>();
            
            // 如果是中文，直接返回原文
            if ("zh-CN".equals(targetLanguage)) {
                for (Map<String, Object> category : categories) {
                    Integer categoryId = (Integer) category.get("id");
                    String categoryName = (String) category.get("name");
                    if (categoryId != null && categoryName != null) {
                        translations.put(categoryId.toString(), categoryName);
                    }
                }
            } else {
                // 逐个翻译分类
                for (Map<String, Object> category : categories) {
                    Integer categoryId = (Integer) category.get("id");
                    String categoryName = (String) category.get("name");
                    
                    if (categoryId != null && categoryName != null) {
                        try {
                            // 优先使用数据库缓存
                            String translatedText = translationService.getCachedTranslation(
                                "category",
                                categoryId,
                                "name",
                                targetLanguage,
                                categoryName,
                                null
                            );
                            
                            // 如果数据库中没有翻译内容，则调用API翻译
                            if (translatedText.equals(categoryName)) {
                                log.debug("数据库中未找到翻译内容，调用API翻译: {} -> {}", categoryName, targetLanguage);
                                translatedText = translationService.getTranslation(
                                    "category",
                                    categoryId,
                                    "name",
                                    targetLanguage,
                                    categoryName,
                                    null
                                );
                            } else {
                                log.debug("使用数据库缓存翻译: {} -> {}", categoryName, translatedText);
                            }
                            
                            translations.put(categoryId.toString(), translatedText);
                        } catch (Exception e) {
                            log.warn("单个分类翻译失败: categoryId={}, categoryName={}, error={}", 
                                    categoryId, categoryName, e.getMessage());
                            // 翻译失败时使用原名称
                            translations.put(categoryId.toString(), categoryName);
                        }
                    }
                }
            }

            Map<String, Object> result = new HashMap<>();
            result.put("translations", translations);
            result.put("language", targetLanguage);
            result.put("total", translations.size());

            log.info("批量分类翻译完成: {} 个分类", translations.size());

            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("批量分类翻译失败", e);
            return CommonResult.failed("批量翻译失败: " + e.getMessage());
        }
    }

    /**
     * 通用翻译接口（兼容DynamicTranslate组件）
     */
    @ApiOperation(value = "通用翻译接口")
    @PostMapping("/translate")
    public CommonResult<Map<String, Object>> translate(@RequestBody Map<String, Object> request) {
        try {
            String text = (String) request.get("text");
            String targetLanguage = (String) request.get("targetLanguage");
            String sourceLanguage = (String) request.get("sourceLanguage");
            String type = (String) request.get("type");
            Integer entityId = (Integer) request.get("entityId");

            log.info("通用翻译请求: text={}, targetLanguage={}, type={}, entityId={}", 
                    text, targetLanguage, type, entityId);

            // 如果是中文，直接返回原文
            if ("zh-CN".equals(targetLanguage)) {
                Map<String, Object> result = new HashMap<>();
                result.put("translatedText", text);
                result.put("originalText", text);
                result.put("language", targetLanguage);
                return CommonResult.success(result);
            }

            // 优先使用数据库缓存
            String translatedText = translationService.getCachedTranslation(
                type != null ? type : "general",
                entityId,
                "content",
                targetLanguage,
                text,
                null
            );
            
            // 如果数据库中没有翻译内容，则调用API翻译
            if (translatedText.equals(text)) {
                log.info("数据库中未找到翻译内容，调用API翻译: {} -> {}", text, targetLanguage);
                translatedText = translationService.getTranslation(
                    type != null ? type : "general",
                    entityId,
                    "content",
                    targetLanguage,
                    text,
                    null
                );
            } else {
                log.debug("使用数据库缓存翻译: {} -> {}", text, translatedText);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("translatedText", translatedText);
            result.put("originalText", text);
            result.put("language", targetLanguage);
            result.put("type", type);
            result.put("entityId", entityId);

            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("通用翻译失败", e);
            return CommonResult.failed("翻译失败: " + e.getMessage());
        }
    }

    /**
     * 获取翻译内容
     */
    @ApiOperation(value = "获取翻译内容")
    @GetMapping("/get")
    public CommonResult<Map<String, Object>> getTranslation(
            @RequestParam String type,
            @RequestParam Integer entityId,
            @RequestParam String locale) {
        try {
            // 这里可以实现获取已存储翻译的逻辑
            // 目前先返回空结果
            Map<String, Object> result = new HashMap<>();
            result.put("type", type);
            result.put("entityId", entityId);
            result.put("locale", locale);
            result.put("translation", null);

            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("获取翻译内容失败", e);
            return CommonResult.failed("获取翻译失败: " + e.getMessage());
        }
    }

    /**
     * 保存翻译内容
     */
    @ApiOperation(value = "保存翻译内容")
    @PostMapping("/save")
    public CommonResult<String> saveTranslation(@RequestBody Map<String, Object> request) {
        try {
            String type = (String) request.get("type");
            Integer entityId = (Integer) request.get("entityId");
            String locale = (String) request.get("locale");
            String translation = (String) request.get("translation");

            log.info("保存翻译内容: type={}, entityId={}, locale={}, translation={}", 
                    type, entityId, locale, translation);

            // 这里可以实现保存翻译的逻辑
            // 目前只记录日志
            
            return CommonResult.success("保存成功");
        } catch (Exception e) {
            log.error("保存翻译内容失败", e);
            return CommonResult.failed("保存失败: " + e.getMessage());
        }
    }

    /**
     * 获取分类翻译缓存
     */
    @ApiOperation(value = "获取分类翻译缓存")
    @GetMapping("/category/cache")
    public CommonResult<Map<String, Object>> getCategoryTranslationCache(
            @RequestParam Integer categoryId,
            @RequestParam String targetLanguage) {
        try {
            // 这里可以实现获取缓存的逻辑
            // 目前先返回空结果，表示没有缓存
            Map<String, Object> result = new HashMap<>();
            result.put("categoryId", categoryId);
            result.put("language", targetLanguage);
            result.put("cached", false);
            result.put("translatedText", null);

            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("获取分类翻译缓存失败", e);
            return CommonResult.failed("获取缓存失败: " + e.getMessage());
        }
    }
}










