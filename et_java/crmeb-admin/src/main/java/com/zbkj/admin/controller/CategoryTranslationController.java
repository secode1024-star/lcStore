package com.zbkj.admin.controller;

import com.zbkj.common.result.CommonResult;
import com.zbkj.service.service.TranslationService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("api/admin/translation/category")
@Api(tags = "管理端分类翻译控制器")
public class CategoryTranslationController {

    @Autowired
    private TranslationService translationService;

    /**
     * 单个分类翻译
     */
    @ApiOperation(value = "单个分类翻译")
    @PostMapping("/single")
    public CommonResult<Map<String, Object>> translateSingleCategory(@RequestBody Map<String, Object> request) {
        try {
            Integer categoryId = (Integer) request.get("categoryId");
            String categoryName = (String) request.get("categoryName");
            String sourceLang = (String) request.get("sourceLang");
            List<String> targetLangs = (List<String>) request.get("targetLangs");
            String provider = (String) request.get("provider");

            log.info("单个分类翻译请求: categoryId={}, categoryName={}, targetLangs={}", 
                    categoryId, categoryName, targetLangs);

            Map<String, String> translations = new HashMap<>();
            
            for (String targetLang : targetLangs) {
                try {
                    String translatedText = translationService.getTranslation(
                        "category",
                        categoryId,
                        "name",
                        targetLang,
                        categoryName,
                        null
                    );
                    translations.put(targetLang, translatedText);
                    log.info("分类翻译成功: {} -> {} = {}", categoryName, targetLang, translatedText);
                } catch (Exception e) {
                    log.error("分类翻译失败: {} -> {}", categoryName, targetLang, e);
                    translations.put(targetLang, categoryName); // 失败时使用原文
                }
            }

            Map<String, Object> result = new HashMap<>();
            result.put("categoryId", categoryId);
            result.put("categoryName", categoryName);
            result.put("translations", translations);

            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("单个分类翻译失败", e);
            return CommonResult.failed("翻译失败: " + e.getMessage());
        }
    }

    /**
     * 批量分类翻译
     */
    @ApiOperation(value = "批量分类翻译")
    @PostMapping("/batch")
    public CommonResult<Map<String, Object>> batchTranslateCategories(@RequestBody Map<String, Object> request) {
        try {
            List<Map<String, Object>> categories = (List<Map<String, Object>>) request.get("categories");
            String sourceLang = (String) request.get("sourceLang");
            List<String> targetLangs = (List<String>) request.get("targetLangs");
            String provider = (String) request.get("provider");

            log.info("批量分类翻译请求: categories={}, targetLangs={}", categories.size(), targetLangs);

            int successCount = 0;
            int failCount = 0;
            Map<String, Object> results = new HashMap<>();

            for (Map<String, Object> category : categories) {
                Integer categoryId = (Integer) category.get("id");
                String categoryName = (String) category.get("name");
                
                try {
                    Map<String, String> translations = new HashMap<>();
                    
                    for (String targetLang : targetLangs) {
                        try {
                            String translatedText = translationService.getTranslation(
                                "category",
                                categoryId,
                                "name",
                                targetLang,
                                categoryName,
                                null
                            );
                            translations.put(targetLang, translatedText);
                        } catch (Exception e) {
                            log.error("分类翻译失败: {} -> {}", categoryName, targetLang, e);
                            translations.put(targetLang, categoryName); // 失败时使用原文
                        }
                    }
                    
                    results.put(categoryId.toString(), translations);
                    successCount++;
                    
                    log.info("分类批量翻译成功: {} (ID: {})", categoryName, categoryId);
                    
                    // 添加延迟避免频率限制
                    Thread.sleep(100);
                    
                } catch (Exception e) {
                    log.error("分类翻译失败: {} (ID: {})", categoryName, categoryId, e);
                    failCount++;
                }
            }

            Map<String, Object> result = new HashMap<>();
            result.put("successCount", successCount);
            result.put("failCount", failCount);
            result.put("totalCount", categories.size());
            result.put("results", results);

            return CommonResult.success(result);
        } catch (Exception e) {
            log.error("批量分类翻译失败", e);
            return CommonResult.failed("批量翻译失败: " + e.getMessage());
        }
    }
}









