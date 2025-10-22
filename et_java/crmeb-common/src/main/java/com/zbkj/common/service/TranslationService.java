package com.zbkj.common.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import java.util.HashMap;
import java.util.Map;

/**
 * 翻译服务接口
 * 支持多种第三方翻译API
 * 
 * @author CRMEB Team
 */
@Service
public class TranslationService {
    
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;
    
    // 配置信息 - 实际使用时应从配置文件读取
    private static final String GOOGLE_TRANSLATE_API_KEY = "YOUR_GOOGLE_API_KEY";
    private static final String BAIDU_APP_ID = "YOUR_BAIDU_APP_ID";
    private static final String BAIDU_SECRET_KEY = "YOUR_BAIDU_SECRET_KEY";
    
    public TranslationService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }
    
    /**
     * 使用Google翻译API翻译文本
     * 
     * @param text 待翻译文本
     * @param targetLanguage 目标语言代码
     * @param sourceLanguage 源语言代码，默认为中文
     * @return 翻译结果
     */
    public String translateWithGoogle(String text, String targetLanguage, String sourceLanguage) {
        try {
            String url = "https://translation.googleapis.com/language/translate/v2";
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("q", text);
            requestBody.put("target", convertLanguageCode(targetLanguage));
            requestBody.put("source", convertLanguageCode(sourceLanguage));
            requestBody.put("key", GOOGLE_TRANSLATE_API_KEY);
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);
            
            if (response.getStatusCode() == HttpStatus.OK) {
                JsonNode jsonNode = objectMapper.readTree(response.getBody());
                return jsonNode.path("data").path("translations").get(0).path("translatedText").asText();
            }
        } catch (Exception e) {
            System.err.println("Google翻译失败: " + e.getMessage());
        }
        return text; // 翻译失败时返回原文
    }
    
    /**
     * 使用百度翻译API翻译文本
     * 
     * @param text 待翻译文本
     * @param targetLanguage 目标语言代码
     * @param sourceLanguage 源语言代码
     * @return 翻译结果
     */
    public String translateWithBaidu(String text, String targetLanguage, String sourceLanguage) {
        try {
            String salt = String.valueOf(System.currentTimeMillis());
            String sign = generateBaiduSign(BAIDU_APP_ID + text + salt + BAIDU_SECRET_KEY);
            
            String url = "https://fanyi-api.baidu.com/api/trans/vip/translate" +
                    "?q=" + text +
                    "&from=" + convertToBaiduLanguageCode(sourceLanguage) +
                    "&to=" + convertToBaiduLanguageCode(targetLanguage) +
                    "&appid=" + BAIDU_APP_ID +
                    "&salt=" + salt +
                    "&sign=" + sign;
            
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
            
            if (response.getStatusCode() == HttpStatus.OK) {
                JsonNode jsonNode = objectMapper.readTree(response.getBody());
                JsonNode transResult = jsonNode.path("trans_result");
                if (transResult.isArray() && transResult.size() > 0) {
                    return transResult.get(0).path("dst").asText();
                }
            }
        } catch (Exception e) {
            System.err.println("百度翻译失败: " + e.getMessage());
        }
        return text;
    }
    
    /**
     * 批量翻译商品信息
     * 
     * @param productId 商品ID
     * @param storeName 商品名称
     * @param storeInfo 商品描述
     * @param targetLanguages 目标语言列表
     */
    public Map<String, Map<String, String>> batchTranslateProduct(
            Integer productId, String storeName, String storeInfo, String[] targetLanguages) {
        
        Map<String, Map<String, String>> translations = new HashMap<>();
        
        for (String lang : targetLanguages) {
            Map<String, String> langTranslations = new HashMap<>();
            
            // 翻译商品名称
            String translatedName = translateWithGoogle(storeName, lang, "zh-CN");
            langTranslations.put("storeName", translatedName);
            
            // 翻译商品描述
            if (storeInfo != null && !storeInfo.isEmpty()) {
                String translatedInfo = translateWithGoogle(storeInfo, lang, "zh-CN");
                langTranslations.put("storeInfo", translatedInfo);
            }
            
            translations.put(lang, langTranslations);
        }
        
        return translations;
    }
    
    /**
     * 转换语言代码为Google翻译API格式
     */
    private String convertLanguageCode(String language) {
        Map<String, String> languageMap = new HashMap<>();
        languageMap.put("zh-CN", "zh");
        languageMap.put("en", "en");
        languageMap.put("fr", "fr");
        languageMap.put("th", "th");
        languageMap.put("lao", "lo");
        languageMap.put("ja", "ja");
        languageMap.put("ko", "ko");
        languageMap.put("ar", "ar");
        
        return languageMap.getOrDefault(language, "en");
    }
    
    /**
     * 转换语言代码为百度翻译API格式
     */
    private String convertToBaiduLanguageCode(String language) {
        Map<String, String> languageMap = new HashMap<>();
        languageMap.put("zh-CN", "zh");
        languageMap.put("en", "en");
        languageMap.put("fr", "fra");
        languageMap.put("th", "th");
        languageMap.put("lao", "lo");
        languageMap.put("ja", "jp");
        languageMap.put("ko", "kor");
        languageMap.put("ar", "ara");
        
        return languageMap.getOrDefault(language, "en");
    }
    
    /**
     * 生成百度翻译API签名
     */
    private String generateBaiduSign(String input) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] digest = md.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }
}
