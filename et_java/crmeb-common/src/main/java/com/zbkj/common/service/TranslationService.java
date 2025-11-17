package com.zbkj.common.service;

import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import cn.hutool.core.util.StrUtil;
import java.net.URLEncoder;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.InputStream;
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
    
    private final ObjectMapper objectMapper;
    
    // 百度翻译API配置（测试用，实际应该从配置文件读取）
    private static final String BAIDU_APP_ID = "20251103002489605";
    private static final String BAIDU_SECRET_KEY = "oKUGN3P3Tiv3Goy2LBBt";
    
    public TranslationService() {
        this.objectMapper = new ObjectMapper();
    }
    
    /**
     * 使用Google翻译API翻译文本（暂时禁用，专注百度翻译）
     */
    public String translateWithGoogle(String text, String targetLanguage, String sourceLanguage) {
        System.out.println("Google翻译暂时禁用，请使用百度翻译");
        return text;
    }
    
    /**
     * 使用百度翻译API翻译文本（完全按照官方Demo实现）
     * 
     * @param text 待翻译文本
     * @param targetLanguage 目标语言代码
     * @param sourceLanguage 源语言代码
     * @return 翻译结果
     */
    public String translateWithBaidu(String text, String targetLanguage, String sourceLanguage) {
        try {
            // 完全按照官方Demo的buildParams方法实现
            Map<String, String> params = buildBaiduParams(text, 
                convertToBaiduLanguageCode(sourceLanguage), 
                convertToBaiduLanguageCode(targetLanguage));
            
            // 使用官方Demo的HttpGet.get方法逻辑
            String result = getBaiduTransResult("https://fanyi-api.baidu.com/api/trans/vip/translate", params);
            
            // 如果返回空字符串，说明请求失败
            if (StrUtil.isBlank(result)) {
                System.err.println("百度翻译API返回空响应");
                return null;
            }
            
            // 解析结果
            JsonNode jsonNode = objectMapper.readTree(result);
            
            // 检查是否有错误
            JsonNode errorCode = jsonNode.path("error_code");
            if (!errorCode.isMissingNode()) {
                String errorCodeStr = errorCode.asText();
                String errorMsg = jsonNode.path("error_msg").asText("未知错误");
                
                // 根据错误类型给出不同的提示
                if ("58001".equals(errorCodeStr)) {
                    System.err.println("百度翻译API错误: 不支持的目标语言 (58001)，错误信息: " + errorMsg);
                    System.err.println("提示: 百度翻译API可能不支持该语言，建议使用Google翻译或其他翻译服务");
                } else if ("54003".equals(errorCodeStr)) {
                    System.err.println("百度翻译API错误: 频率限制 (54003)，错误信息: " + errorMsg);
                    System.err.println("提示: 请求过于频繁，请稍后重试或增加请求间隔");
                } else {
                    System.err.println("百度翻译API错误: error_code=" + errorCodeStr + ", error_msg=" + errorMsg);
                }
                
                // 返回null表示翻译失败，让调用方可以尝试备用翻译服务
                return null;
            }
            
            JsonNode transResult = jsonNode.path("trans_result");
            if (transResult.isArray() && transResult.size() > 0) {
                String translatedText = transResult.get(0).path("dst").asText();
                if (StrUtil.isNotBlank(translatedText) && !translatedText.equals(text)) {
                    System.out.println("翻译成功: " + text + " -> " + translatedText);
                    return translatedText;
                } else {
                    System.err.println("翻译返回原文或空: " + text + " -> " + translatedText);
                    return null;
                }
            }
            
            System.err.println("百度翻译API返回结果格式异常");
            return null;
        } catch (Exception e) {
            System.err.println("百度翻译异常: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 构建百度翻译API请求参数（完全按照官方Demo的buildParams方法实现）
     */
    private Map<String, String> buildBaiduParams(String query, String from, String to) {
        Map<String, String> params = new HashMap<>();
        params.put("q", query);
        params.put("from", from);
        params.put("to", to);
        params.put("appid", BAIDU_APP_ID);
        
        // 生成随机数（官方Demo使用UUID，这里简化为时间戳+随机数）
        String salt = String.valueOf(System.currentTimeMillis());
        params.put("salt", salt);
        
        // 生成签名（官方Demo的sign方法）
        String signStr = BAIDU_APP_ID + query + salt + BAIDU_SECRET_KEY;
        String sign = md5(signStr);
        params.put("sign", sign);
        
        return params;
    }
    
    /**
     * 获取百度翻译结果（完全按照官方Demo的HttpGet.get方法实现，增加重试机制）
     * 
     * @param url 请求URL
     * @param params 请求参数
     * @return 翻译结果JSON字符串
     */
    public String getBaiduTransResult(String url, Map<String, String> params) {
        int maxRetries = 4; // 最多重试4次（共5次尝试）
        
        for (int attempt = 1; attempt <= maxRetries; attempt++) {
            try {
                // 构建完整URL
                String fullUrl = getUrlWithQueryString(url, params);
                
                // 创建连接
                URL urlObj = new URL(fullUrl);
                HttpURLConnection conn = (HttpURLConnection) urlObj.openConnection();
                conn.setRequestMethod("GET");
                conn.setConnectTimeout(5000);
                conn.setReadTimeout(10000);
                
                // 发送请求并读取响应
                InputStream is = conn.getInputStream();
                BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                StringBuilder builder = new StringBuilder();
                String line = null;
                while ((line = br.readLine()) != null) {
                    builder.append(line);
                }
                
                String responseBody = builder.toString();
                br.close();
                is.close();
                conn.disconnect();
                
                System.out.println("百度翻译响应内容: " + responseBody);
                
                // 检查错误类型
                if (responseBody.contains("\"error_code\":\"54003\"")) {
                    // 频率限制错误：可以重试
                    System.err.println("检测到百度翻译API错误: 频率限制 (54003)，尝试重试 (第 " + attempt + "/" + maxRetries + " 次)...");
                    if (attempt < maxRetries) {
                        // 由于频繁出现54003错误，使用更保守的延迟策略
                        // 第1次重试：1秒，第2次：2秒，第3次：4秒，第4次：8秒
                        long backoffDelay = 1000 * (long) Math.pow(2, attempt - 1);
                        try {
                            System.out.println("等待 " + backoffDelay + " 毫秒后重试...");
                            Thread.sleep(backoffDelay);
                        } catch (InterruptedException ie) {
                            Thread.currentThread().interrupt();
                            return "{\"error_code\":\"54003\",\"error_msg\":\"请求被中断\"}";
                        }
                        continue; // 继续重试
                    } else {
                        // 所有重试都失败
                        System.err.println("百度翻译API重试 " + maxRetries + " 次后仍失败: 频率限制 (54003)");
                        return responseBody;
                    }
                } else if (responseBody.contains("\"error_code\":\"54001\"")) {
                    // 签名错误：不重试，直接返回
                    System.err.println("检测到百度翻译API错误: 签名错误 (54001)，不进行重试");
                    return responseBody;
                } else if (responseBody.contains("\"error_code\":\"58001\"")) {
                    // 无效的语言参数：不重试，直接返回（如：不支持的语言）
                    System.err.println("检测到百度翻译API错误: 无效的语言参数 (58001)，可能是不支持的目标语言，不进行重试");
                    return responseBody;
                }
                
                // 成功响应，返回结果
                return responseBody;
                
            } catch (Exception e) {
                System.err.println("百度翻译请求异常 (尝试 " + attempt + "/" + maxRetries + "): " + e.getMessage());
                if (attempt < maxRetries) {
                    try {
                        // 异常时使用指数退避延迟
                        long backoffDelay = 1000 * (long) Math.pow(2, attempt - 1);
                        Thread.sleep(backoffDelay);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        return "{\"error_code\":\"54003\",\"error_msg\":\"请求被中断\"}";
                    }
                    continue;
                }
                e.printStackTrace();
                // 所有重试失败，返回包含错误的响应
                return "{\"error_code\":\"54003\",\"error_msg\":\"请求异常: " + e.getMessage().replace("\"", "'") + "\"}";
            }
        }
        
        // 所有重试都失败，返回错误响应
        System.err.println("百度翻译API所有重试都失败");
        return "{\"error_code\":\"54003\",\"error_msg\":\"所有重试都失败\"}";
    }
    
    /**
     * 构建带查询参数的URL（完全按照官方Demo的getUrlWithQueryString方法）
     */
    public String getUrlWithQueryString(String url, Map<String, String> params) {
        if (params == null) {
            return url;
        }
        
        StringBuilder builder = new StringBuilder(url);
        if (url.contains("?")) {
            builder.append("&");
        } else {
            builder.append("?");
        }
        
        int i = 0;
        for (String key : params.keySet()) {
            String value = params.get(key);
            if (value == null) { // 过滤空的key
                continue;
            }
            
            if (i != 0) {
                builder.append('&');
            }
            
            builder.append(key);
            builder.append('=');
            builder.append(encode(value));
            
            i++;
        }
        
        return builder.toString();
    }
    
    /**
     * MD5编码（完全按照官方Demo的MD5.md5方法）
     */
    public String md5(String input) {
        if (input == null)
            return null;
        
        try {
            // 拿到一个MD5转换器（如果想要SHA1参数换成"SHA1"）
            java.security.MessageDigest messageDigest = java.security.MessageDigest.getInstance("MD5");
            // 输入的字符串转换成字节数组
            byte[] inputByteArray = input.getBytes("utf-8");
            // inputByteArray是输入字符串转换得到的字节数组
            messageDigest.update(inputByteArray);
            // 转换并返回结果，也是字节数组，包含16个元素
            byte[] resultByteArray = messageDigest.digest();
            // 字符数组转换成字符串返回
            return byteArrayToHex(resultByteArray);
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 批量翻译商品信息
     * 
     * @param productId 商品ID
     * @param storeName 商品名称
     * @param storeInfo 商品描述
     * @param content 商品详情（HTML富文本）
     * @param targetLanguages 目标语言列表
     */
    public Map<String, Map<String, String>> batchTranslateProduct(
            Integer productId, String storeName, String storeInfo, String content, String[] targetLanguages) {
        
        Map<String, Map<String, String>> translations = new HashMap<>();
        
        for (String lang : targetLanguages) {
            Map<String, String> langTranslations = new HashMap<>();
            
            // 翻译商品名称
            String translatedName = translateWithBaidu(storeName, lang, "zh-CN");
            langTranslations.put("storeName", translatedName);
            
            // 翻译商品描述
            if (storeInfo != null && !storeInfo.isEmpty()) {
                String translatedInfo = translateWithBaidu(storeInfo, lang, "zh-CN");
                langTranslations.put("storeInfo", translatedInfo);
            }
            
            // 翻译商品详情内容
            if (content != null && !content.isEmpty()) {
                String translatedContent = translateWithBaidu(content, lang, "zh-CN");
                langTranslations.put("content", translatedContent);
            }
            
            translations.put(lang, langTranslations);
        }
        
        return translations;
    }
    
    
    /**
     * 转换语言代码为百度翻译API格式
     * 严格按照百度官方语言缩写规范：https://fanyi-api.baidu.com/doc/21
     * 2024年最新版本支持的语言代码
     */
    private String convertToBaiduLanguageCode(String language) {
        if (language == null || language.trim().isEmpty()) {
            return "en"; // 默认英语
        }
        
        // 转换为小写以便匹配
        String lang = language.toLowerCase().trim();
        
        Map<String, String> languageMap = new HashMap<>();
        
        // === 百度翻译API官方支持的语言代码（2024年版本） ===
        
        // 中文相关（百度官方代码）
        languageMap.put("zh-cn", "zh");     // 中文简体
        languageMap.put("zh", "zh");        // 中文简体
        languageMap.put("cht", "cht");      // 中文繁体
        languageMap.put("zh-tw", "cht");    // 中文繁体（台湾）
        languageMap.put("yue", "yue");      // 中文粤语
        languageMap.put("wyw", "wyw");      // 中文文言文
        
        // 英语（百度官方代码）
        languageMap.put("en", "en");        // 英语
        languageMap.put("eng", "en");       // 英语
        
        // 日语（百度官方代码）
        languageMap.put("jp", "jp");        // 日语
        languageMap.put("ja", "jp");        // 日语
        languageMap.put("jpn", "jp");       // 日语
        
        // 韩语（百度官方代码）
        languageMap.put("kor", "kor");      // 韩语
        languageMap.put("ko", "kor");       // 韩语
        languageMap.put("kr", "kor");       // 韩语
        
        // 法语（百度官方代码）
        languageMap.put("fra", "fra");      // 法语
        languageMap.put("fr", "fra");       // 法语
        languageMap.put("fre", "fra");      // 法语
        
        // 泰语（百度官方代码）
        languageMap.put("th", "th");        // 泰语
        languageMap.put("tha", "th");       // 泰语
        
        // 阿拉伯语（百度官方代码）
        languageMap.put("ara", "ara");      // 阿拉伯语
        languageMap.put("ar", "ara");       // 阿拉伯语
        
        // 俄语（百度官方代码）
        languageMap.put("ru", "ru");           // 俄语
        languageMap.put("rus", "ru");          // 俄语
        
        // 德语（百度官方代码）
        languageMap.put("de", "de");           // 德语
        languageMap.put("ger", "de");          // 德语
        languageMap.put("deu", "de");          // 德语
        
        // 西班牙语（百度官方代码）
        languageMap.put("spa", "spa");         // 西班牙语
        languageMap.put("es", "spa");          // 西班牙语
        
        // 意大利语
        languageMap.put("it", "it");
        languageMap.put("ita", "it");
        
        // 葡萄牙语
        languageMap.put("pt", "pt");
        languageMap.put("por", "pt");
        
        // 越南语
        languageMap.put("vie", "vie");
        languageMap.put("vi", "vie");
        
        // 印尼语
        languageMap.put("id", "id");
        languageMap.put("ind", "id");
        
        // 印地语
        languageMap.put("hi", "hi");
        languageMap.put("hin", "hi");
        
        // 荷兰语
        languageMap.put("nl", "nl");
        languageMap.put("dut", "nl");
        
        // 瑞典语
        languageMap.put("swe", "swe");
        languageMap.put("sv", "swe");
        
        // 芬兰语
        languageMap.put("fin", "fin");
        languageMap.put("fi", "fin");
        
        // 丹麦语
        languageMap.put("dan", "dan");
        languageMap.put("da", "dan");
        
        // 波兰语
        languageMap.put("pl", "pl");
        languageMap.put("pol", "pl");
        
        // 希腊语
        languageMap.put("el", "el");
        languageMap.put("gre", "el");
        
        // 匈牙利语
        languageMap.put("hu", "hu");
        languageMap.put("hun", "hu");
        
        // 捷克语
        languageMap.put("cs", "cs");
        languageMap.put("cze", "cs");
        
        // 罗马尼亚语
        languageMap.put("rom", "rom");
        languageMap.put("ro", "rom");
        
        // 保加利亚语
        languageMap.put("bul", "bul");
        languageMap.put("bg", "bul");
        
        // 克罗地亚语
        languageMap.put("hrv", "hrv");
        languageMap.put("hr", "hrv");
        
        // 塞尔维亚语
        languageMap.put("srp", "srp");
        languageMap.put("sr", "srp");
        
        // 斯洛伐克语
        languageMap.put("sk", "sk");
        languageMap.put("slo-sk", "sk"); // 斯洛伐克语（使用完整代码避免冲突）
        
        // 斯洛文尼亚语
        languageMap.put("slo", "slo");
        languageMap.put("sl", "slo");
        languageMap.put("slv", "slo"); // 斯洛文尼亚语（ISO 639-2代码）
        
        // 乌克兰语
        languageMap.put("ukr", "ukr");
        languageMap.put("uk", "ukr");
        
        // 土耳其语
        languageMap.put("tr", "tr");
        languageMap.put("tur", "tr");
        
        // 希伯来语
        languageMap.put("heb", "heb");
        languageMap.put("he", "heb");
        
        // 马来语
        languageMap.put("may", "may");
        languageMap.put("ms", "may");
        
        // 菲律宾语
        languageMap.put("fil", "fil");
        languageMap.put("tl", "fil");
        
        // 高棉语
        languageMap.put("hkm", "hkm");
        languageMap.put("km", "hkm");
        
        // 自动检测
        languageMap.put("auto", "auto");
        
        // 查找映射
        String baiduCode = languageMap.get(lang);
        
        // 如果没找到映射，检查是否是百度官方支持的语言代码
        if (baiduCode == null) {
            // 百度翻译API官方支持的语言代码列表（2024年版本）
            String[] supportedCodes = {
                "zh", "cht", "yue", "wyw", "en", "jp", "kor", "fra", "th", "ara", 
                "ru", "de", "spa", "it", "pt", "vie", "id", "hi", "nl", "swe", 
                "fin", "dan", "pl", "el", "hu", "cs", "rom", "bul", "hrv", "srp", 
                "sk", "slo", "ukr", "tr", "heb", "may", "fil", "hkm", "auto"
            };
            
            // 检查是否是支持的代码
            boolean isSupported = false;
            for (String supportedCode : supportedCodes) {
                if (supportedCode.equals(lang)) {
                    isSupported = true;
                    break;
                }
            }
            
            if (isSupported) {
                baiduCode = lang;
            } else {
                // 不支持的语言，抛出异常
                System.err.println("不支持的语言代码: " + language + " (转换后: " + lang + ")");
                throw new RuntimeException("百度翻译API不支持的语言代码: " + language + 
                    "。请使用支持的语言代码，如: zh, en, jp, kor, fra, th, ara, ru, de, spa 等");
            }
        }
        
        System.out.println("语言代码转换: " + language + " -> " + baiduCode);
        return baiduCode;
    }
    
    
    /**
     * 字节数组转16进制字符串（按照官方Demo实现）
     */
    private static final char[] hexDigits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
    
    private String byteArrayToHex(byte[] byteArray) {
        char[] resultCharArray = new char[byteArray.length * 2];
        int index = 0;
        for (byte b : byteArray) {
            resultCharArray[index++] = hexDigits[b >>> 4 & 0xf];
            resultCharArray[index++] = hexDigits[b & 0xf];
        }
        return new String(resultCharArray);
    }
    
    /**
     * URL编码（按照官方Demo实现）
     */
    public String encode(String input) {
        if (input == null) {
            return "";
        }
        
        try {
            return URLEncoder.encode(input, "utf-8");
        } catch (java.io.UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        
        return input;
    }
}
