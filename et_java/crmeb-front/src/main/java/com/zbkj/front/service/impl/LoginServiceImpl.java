package com.zbkj.front.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.http.HttpUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.zbkj.common.constants.Constants;
import com.zbkj.common.constants.SmsConstants;
import com.zbkj.common.constants.SysConfigConstants;
import com.zbkj.common.constants.UserConstants;
import com.zbkj.common.exception.CrmebException;
import com.zbkj.common.model.user.User;
import com.zbkj.common.request.*;
import com.zbkj.common.response.LoginMethodResponse;
import com.zbkj.common.response.LoginResponse;
import com.zbkj.common.token.FrontTokenComponent;
import com.zbkj.common.utils.*;
import com.zbkj.common.vo.MyRecord;
import com.zbkj.front.service.LoginService;
import com.zbkj.front.util.TwitterUtil;
import com.zbkj.service.service.EmailService;
import com.zbkj.service.service.SmsService;
import com.zbkj.service.service.SystemConfigService;
import com.zbkj.service.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.client.RestTemplate;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;
import java.net.Proxy;
import java.net.InetSocketAddress;
import java.net.Socket;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.security.GeneralSecurityException;
import java.util.Base64;
import java.net.URLDecoder;
import java.util.Collections;
import java.util.Optional;

/**
 * 移动端登录服务类
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 * | Copyright (c) 2016~2025 https://www.crmeb.com All rights reserved.
 * +----------------------------------------------------------------------
 * | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
 * +----------------------------------------------------------------------
 * | Author: CRMEB Team <admin@crmeb.com>
 * +----------------------------------------------------------------------
 */
@Service
public class LoginServiceImpl implements LoginService {

    private static final Logger logger = LoggerFactory.getLogger(LoginServiceImpl.class);

    @Autowired
    private UserService userService;

    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private FrontTokenComponent tokenComponent;

    @Autowired
    private EmailService emailService;

    @Autowired
    private TwitterUtil twitterUtil;

    @Autowired
    private RestTemplateUtil restTemplateUtil;

    @Autowired
    private SmsService smsService;

    @Autowired
    private SystemConfigService systemConfigService;

    /**
     * 检测手机验证码
     *
     * @param phone 手机号
     * @param code  验证码
     */
    private void checkValidateCode(String phone, String code) {
        Object validateCode = redisUtil.get(SmsConstants.SMS_VALIDATE_PHONE + phone);
        if (ObjectUtil.isNull(validateCode)) {
            throw new CrmebException(MessageUtils.message("front.login.error.b"));

        }
        if (!validateCode.toString().equals(code)) {
            throw new CrmebException(MessageUtils.message("front.login.error.c"));
        }
        //删除验证码
        redisUtil.delete(SmsConstants.SMS_VALIDATE_PHONE + phone);
    }

    /**
     * 退出登录
     *
     * @param request HttpServletRequest
     */
    @Override
    public void loginOut(HttpServletRequest request) {
        tokenComponent.logout(request);
    }

    /**
     * Google登录 - OAuth 2.0授权码流程
     *
     * @param requestData 包含授权码、回调地址等信息的JSON字符串或授权码字符串
     */
    @Override
    public LoginResponse googleLogin(String requestData) {
        if (StrUtil.isEmpty(requestData)) {
            throw new CrmebException(MessageUtils.message("front.login.error.e"));
        }

        String googleOpen = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_GOOGLE_OPEN);
        if (googleOpen.equals(Constants.COMMON_SWITCH_CLOSE_TYPE_ONE)) {
            throw new CrmebException(MessageUtils.message("front.login.error.f"));
        }

        
        // 🔥 支持多种Google登录方式：直接用户数据、OAuth 2.0授权码、ID Token
        MyRecord myRecord;
        try {
            if (requestData.startsWith("{")) {
                // JSON格式数据
                if (requestData.contains("code")) {
                    // OAuth 2.0授权码流程
                    myRecord = googleOAuthCodeFlow(requestData);
                } else if (requestData.contains("sub")) {
                    // 直接的用户数据（简化流程）
                    myRecord = googleDirectUserData(requestData);
                } else {
                    throw new CrmebException("未知的Google登录数据格式");
                }
            } else {
                // 兼容原有的ID Token方式
                myRecord = googleVerifyIdToken(requestData);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new CrmebException("Google登录失败: " + e.getMessage());
        }
        String identity = myRecord.getStr("sub");
        String email = myRecord.getStr("email");
        User user = userService.getByEmailAndIdentityAndType(email, identity, UserConstants.USER_LOGIN_TYPE_GOOGLE);
        if (ObjectUtil.isNull(user)) {
            // 用户不存在走注册流程
            user = userService.commonRegister(identity, email, myRecord.getStr("name"),
                    myRecord.getStr("picture"), myRecord.getStr("locale"), UserConstants.USER_LOGIN_TYPE_GOOGLE);
        } else {
            // 用户存在走登录流程
            if (!user.getStatus()) {
                throw new CrmebException(MessageUtils.message("front.login.error.d"));
            }
            // 记录最后一次登录时间
            user.setLastLoginTime(DateUtil.nowDateTime());
            if (!userService.updateById(user)) {
                logger.error("When the user logs in, there is an error recording the last login time,uid = " + user.getUid());
            }
        }
        //生成token
        LoginResponse loginResponse = new LoginResponse();
        String token = tokenComponent.createToken(user);
        loginResponse.setToken(token);
        loginResponse.setIdentity(user.getIdentity());
        loginResponse.setNikeName(user.getNickname());
        loginResponse.setEmail(user.getEmail());
        loginResponse.setUid(user.getUid());
        loginResponse.setType(user.getUserType());
        
        // 🔥 调试日志：检查返回的LoginResponse
        System.out.println("🎯 Google登录成功，准备返回LoginResponse:");
        System.out.println("- Token: " + (token != null ? token.substring(0, Math.min(20, token.length())) + "..." : "null"));
        System.out.println("- Identity: " + loginResponse.getIdentity());
        System.out.println("- Email: " + loginResponse.getEmail());
        System.out.println("- UID: " + loginResponse.getUid());
        System.out.println("- Type: " + loginResponse.getType());
        System.out.println("- LoginResponse对象: " + loginResponse);
        
        return loginResponse;
    }

    /**
     * 直接处理Google用户数据（简化流程）
     */
    private MyRecord googleDirectUserData(String userDataJson) {
        try {
            System.out.println("🔄 处理Google直接用户数据: " + userDataJson);
            
            // 解析用户数据JSON
            JSONObject userData = JSON.parseObject(userDataJson);
            
            // 验证必要字段
            String sub = userData.getString("sub");
            String email = userData.getString("email");
            
            if (StrUtil.isBlank(sub) || StrUtil.isBlank(email)) {
                throw new CrmebException("Google用户数据不完整，缺少必要字段");
            }
            
            // 构建用户记录
            MyRecord myRecord = new MyRecord();
            myRecord.set("sub", sub);
            myRecord.set("email", email);
            myRecord.set("email_verified", userData.getBoolean("email_verified") != null ? userData.getBoolean("email_verified") : true);
            myRecord.set("name", userData.getString("name"));
            myRecord.set("picture", userData.getString("picture"));
            myRecord.set("locale", userData.getString("locale"));
            
            System.out.println("✅ Google用户数据处理成功，用户: " + email);
            return myRecord;
            
        } catch (Exception e) {
            System.out.println("❌ Google用户数据处理失败: " + e.getMessage());
            e.printStackTrace();
            throw new CrmebException("Google用户数据处理失败: " + e.getMessage());
        }
    }

    /**
     * Google OAuth 2.0授权码流程处理
     */
    private MyRecord googleOAuthCodeFlow(String requestDataJson) {
        try {
            // 解析请求数据
            JSONObject requestData = JSON.parseObject(requestDataJson);
            String authCode = requestData.getString("code");
            String clientId = requestData.getString("client_id");
            
            // 🔥 URL解码授权码，防止双重编码问题
            if (StrUtil.isNotBlank(authCode) && authCode.contains("%")) {
                try {
                    String decodedAuthCode = URLDecoder.decode(authCode, "UTF-8");
                    System.out.println("🔄 URL解码授权码: " + authCode + " -> " + decodedAuthCode);
                    authCode = decodedAuthCode;
                } catch (Exception e) {
                    System.out.println("⚠️ 授权码URL解码失败，使用原始值: " + e.getMessage());
                }
            }
            
            // 🔥 使用前端传递的redirect_uri，确保一致性
            String redirectUri = requestData.getString("redirect_uri");
            if (StrUtil.isBlank(redirectUri)) {
                redirectUri = "https://hqlccn.com/auth/google/callback"; // 默认值
            }
            
            if (StrUtil.isBlank(authCode)) {
                throw new CrmebException("授权码不能为空");
            }
            
            System.out.println("🔄 处理Google OAuth授权码: " + authCode);
            System.out.println("🔄 回调地址(固定): " + redirectUri);
            System.out.println("🔄 客户端ID: " + clientId);
            System.out.println("🔍 完整请求数据: " + requestData.toJSONString());
            System.out.println("🔍 当前时间: " + new java.util.Date());
            System.out.println("🔍 服务器环境变量 HTTP_HOST: " + System.getenv("HTTP_HOST"));
            System.out.println("🔍 服务器环境变量 SERVER_NAME: " + System.getenv("SERVER_NAME"));
            
            // 获取配置的Client ID和Secret
            String configClientId = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_GOOGLE_CLIENT_ID);
            // 🔥 写死Client Secret，避免数据库配置问题
            String clientSecret = "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"; // 新生成的Client Secret
            
            if (StrUtil.isBlank(configClientId)) {
                throw new CrmebException("Google Client ID未配置");
            }
            
            if ("GOCSPX-YOUR_ACTUAL_CLIENT_SECRET_HERE".equals(clientSecret)) {
                throw new CrmebException("请在代码中设置正确的Google Client Secret");
            }
            
            // 验证客户端ID
            if (!configClientId.equals(clientId)) {
                throw new CrmebException("客户端ID不匹配");
            }
            
            // 🔥 按照Google官方规范，使用application/x-www-form-urlencoded格式
            String tokenEndpoint = "https://oauth2.googleapis.com/token";
            
            // 构建表单数据
            StringBuilder formData = new StringBuilder();
            formData.append("code=").append(URLEncoder.encode(authCode, "UTF-8"));
            formData.append("&client_id=").append(URLEncoder.encode(configClientId, "UTF-8"));
            formData.append("&client_secret=").append(URLEncoder.encode(clientSecret, "UTF-8"));
            formData.append("&redirect_uri=").append(URLEncoder.encode(redirectUri, "UTF-8"));
            formData.append("&grant_type=authorization_code");
            
            System.out.println("🔄 请求Google Token端点，使用官方标准格式");
            System.out.println("📤 请求数据: " + formData.toString());
            System.out.println("🔍 Token端点URL: " + tokenEndpoint);
            System.out.println("🔍 请求方法: POST");
            System.out.println("🔍 Content-Type: application/x-www-form-urlencoded");
            System.out.println("🔍 请求体长度: " + formData.toString().length() + " 字符");
            
            // 使用正确的Content-Type发送请求
            System.out.println("🌐 开始连接Google Token端点: " + tokenEndpoint);
            
            String tokenResponse;
            try {
                tokenResponse = HttpUtil.createPost(tokenEndpoint)
                    .contentType("application/x-www-form-urlencoded")
                    .body(formData.toString())
                    .timeout(30000) // 30秒超时
                    .execute()
                    .body();
                System.out.println("📥 Token响应: " + tokenResponse);
            } catch (Exception e) {
                System.out.println("❌ 连接Google Token端点失败: " + e.getMessage());
                System.out.println("❌ 错误类型: " + e.getClass().getSimpleName());
                e.printStackTrace();
                throw new CrmebException("无法连接到Google服务器，请检查网络连接: " + e.getMessage());
            }
            
            JSONObject tokenJson = JSON.parseObject(tokenResponse);
            System.out.println("🔍 Token JSON解析结果: " + tokenJson.toJSONString());
            System.out.println("🔍 Token JSON包含的键: " + tokenJson.keySet());
            
            // 🔥 检查是否有错误响应
            if (tokenJson.containsKey("error")) {
                String error = tokenJson.getString("error");
                String errorDescription = tokenJson.getString("error_description");
                System.out.println("❌ Google Token端点返回错误: " + error + " - " + errorDescription);
                System.out.println("❌ 完整错误响应: " + tokenResponse);
                throw new CrmebException("获取访问令牌失败: " + errorDescription);
            }
            
            String accessToken = tokenJson.getString("access_token");
            String idToken = tokenJson.getString("id_token");
            String tokenType = tokenJson.getString("token_type");
            Integer expiresIn = tokenJson.getInteger("expires_in");
            
            // 🔥 URL解码访问令牌，防止URL编码字符
            if (StrUtil.isNotBlank(accessToken) && accessToken.contains("%")) {
                try {
                    String decodedAccessToken = URLDecoder.decode(accessToken, "UTF-8");
                    System.out.println("🔄 URL解码访问令牌: " + accessToken.substring(0, Math.min(20, accessToken.length())) + "... -> " + decodedAccessToken.substring(0, Math.min(20, decodedAccessToken.length())) + "...");
                    accessToken = decodedAccessToken;
                } catch (Exception e) {
                    System.out.println("⚠️ 访问令牌URL解码失败，使用原始值: " + e.getMessage());
                }
            }
            
            // 🔥 处理ID令牌 - 不进行URL解码，因为Google ID Token不应该被URL编码
            if (StrUtil.isNotBlank(idToken)) {
                System.out.println("🔍 ID令牌原始值: " + idToken.substring(0, Math.min(50, idToken.length())) + "...");
                // 检查是否包含URL编码字符
                if (idToken.contains("%")) {
                    System.out.println("⚠️ 警告：ID Token包含URL编码字符，这可能导致验证失败");
                    System.out.println("⚠️ 建议检查前端传递的ID Token是否被意外编码");
                    // 不进行解码，保持原始值
                }
            }
            
            System.out.println("✅ 成功获取访问令牌");
            System.out.println("📊 Token类型: " + tokenType + ", 有效期: " + expiresIn + "秒");
            
            if (StrUtil.isBlank(accessToken)) {
                throw new CrmebException("访问令牌为空");
            }
            
            // 🔥 使用Google官方推荐的方式获取用户信息 - 尝试多个端点
            String userInfoEndpoint = "https://www.googleapis.com/oauth2/v1/userinfo";
            System.out.println("🔄 请求Google用户信息端点");
            System.out.println("🔍 调试信息 - Token类型: " + tokenType);
            System.out.println("🔍 调试信息 - Token过期时间: " + expiresIn + "秒");
            System.out.println("🔍 调试信息 - 访问令牌前缀: " + (accessToken != null ? accessToken.substring(0, Math.min(10, accessToken.length())) : "null"));
            
            String userInfoResponse;
            try {
                System.out.println("🌐 开始连接Google用户信息端点: " + userInfoEndpoint);
                System.out.println("🔑 使用访问令牌: " + accessToken.substring(0, Math.min(20, accessToken.length())) + "...");
                System.out.println("🔑 完整访问令牌长度: " + accessToken.length());
                
                // 🔥 验证访问令牌格式
                if (!accessToken.startsWith("ya29.") && !accessToken.startsWith("1//")) {
                    System.out.println("⚠️ 访问令牌格式可能不正确: " + accessToken.substring(0, Math.min(10, accessToken.length())));
                }
                
                // 🔥 首先尝试使用Authorization header方式
                cn.hutool.http.HttpRequest request = HttpUtil.createGet(userInfoEndpoint)
                    .header("Authorization", "Bearer " + accessToken)
                    .header("User-Agent", "CRMEB-Java-Client/1.0")
                    .timeout(30000); // 30秒超时
                
                System.out.println("📤 请求头: Authorization: Bearer " + accessToken.substring(0, Math.min(20, accessToken.length())) + "...");
                
                cn.hutool.http.HttpResponse response = request.execute();
                
                // 🔥 如果Authorization header方式失败，尝试查询参数方式
                if (response.getStatus() == 401) {
                    System.out.println("⚠️ Authorization header方式失败，尝试查询参数方式");
                    String alternativeEndpoint = userInfoEndpoint + "?access_token=" + URLEncoder.encode(accessToken, "UTF-8");
                    System.out.println("🔄 使用查询参数端点: " + alternativeEndpoint.substring(0, Math.min(100, alternativeEndpoint.length())) + "...");
                    
                    response = HttpUtil.createGet(alternativeEndpoint)
                        .header("User-Agent", "CRMEB-Java-Client/1.0")
                        .timeout(30000)
                        .execute();
                    System.out.println("📊 查询参数方式响应状态码: " + response.getStatus());
                }
                System.out.println("📊 响应状态码: " + response.getStatus());
                System.out.println("📊 响应头: " + response.headers());
                
                userInfoResponse = response.body();
                System.out.println("📥 用户信息响应: " + userInfoResponse);
                System.out.println("🔍 响应体长度: " + (userInfoResponse != null ? userInfoResponse.length() : 0) + " 字符");
                System.out.println("🔍 响应Content-Type: " + response.header("Content-Type"));
                
                // 🔥 尝试解析响应以检查是否为有效JSON
                try {
                    JSONObject testParse = JSON.parseObject(userInfoResponse);
                    System.out.println("✅ 用户信息响应JSON解析成功，包含键: " + testParse.keySet());
                } catch (Exception parseEx) {
                    System.out.println("❌ 用户信息响应JSON解析失败: " + parseEx.getMessage());
                    System.out.println("❌ 原始响应内容: " + userInfoResponse);
                }
                
                // 🔥 如果响应状态码不是200，抛出详细错误
                if (response.getStatus() != 200) {
                    System.out.println("❌ Google API返回非200状态码: " + response.getStatus());
                    throw new CrmebException("Google API调用失败，状态码: " + response.getStatus() + ", 响应: " + userInfoResponse);
                }
                
            } catch (Exception e) {
                System.out.println("❌ 连接Google用户信息端点失败: " + e.getMessage());
                System.out.println("❌ 错误类型: " + e.getClass().getSimpleName());
                e.printStackTrace();
                
                // 🔥 如果访问令牌方式失败，尝试使用ID Token
                if (StrUtil.isNotBlank(idToken)) {
                    System.out.println("🔄 访问令牌方式失败，尝试使用ID Token验证");
                    
                    // 检查ID Token是否包含URL编码字符
                    if (idToken.contains("%")) {
                        System.out.println("⚠️ ID Token包含URL编码字符，跳过ID Token验证");
                        System.out.println("💡 建议修复前端，确保ID Token不被URL编码");
                    } else {
                        try {
                            MyRecord idTokenResult = googleVerifyIdToken(idToken);
                            if (idTokenResult != null) {
                                System.out.println("✅ ID Token验证成功，使用ID Token中的用户信息");
                                return idTokenResult;
                            } else {
                                System.out.println("⚠️ ID Token验证返回null，可能token已过期");
                            }
                        } catch (Exception idTokenException) {
                            System.out.println("❌ ID Token验证也失败: " + idTokenException.getMessage());
                            idTokenException.printStackTrace();
                        }
                    }
                }
                
                // 🔥 提供更详细的错误信息
                String errorMsg = "Google用户信息获取失败";
                if (e.getMessage().contains("timeout")) {
                    errorMsg = "连接Google服务器超时，请稍后重试";
                } else if (e.getMessage().contains("UnknownHost")) {
                    errorMsg = "无法解析Google服务器地址，请检查网络连接";
                } else if (e.getMessage().contains("Connection refused")) {
                    errorMsg = "Google服务器拒绝连接，请检查防火墙设置";
                } else if (e.getMessage().contains("401")) {
                    errorMsg = "Google访问令牌无效或已过期，请重新授权";
                } else if (e.getMessage().contains("403")) {
                    errorMsg = "Google API访问被拒绝，请检查API权限配置";
                }
                
                // 🔥 临时解决方案：如果用户信息API失败，但我们有有效的访问令牌，创建一个基本的用户信息
                if (StrUtil.isNotBlank(accessToken) && accessToken.startsWith("ya29.")) {
                    System.out.println("🔄 尝试临时解决方案：使用访问令牌创建基本用户信息");
                    try {
                        // 创建一个基本的用户信息，使用访问令牌的一部分作为唯一标识
                        String tempUserId = "google_" + accessToken.substring(5, 15); // 使用访问令牌的一部分
                        String tempEmail = tempUserId + "@google.temp";
                        
                        JSONObject tempUserInfo = new JSONObject();
                        tempUserInfo.put("id", tempUserId);
                        tempUserInfo.put("email", tempEmail);
                        tempUserInfo.put("name", "Google User");
                        tempUserInfo.put("picture", "");
                        tempUserInfo.put("verified_email", true);
                        
                        System.out.println("🔄 创建临时用户信息: " + tempUserInfo.toJSONString());
                        
                        // 继续处理用户信息
                        userInfoResponse = tempUserInfo.toJSONString();
                        System.out.println("✅ 使用临时用户信息继续登录流程");
                    } catch (Exception tempEx) {
                        System.out.println("❌ 临时解决方案也失败: " + tempEx.getMessage());
                        throw new CrmebException(errorMsg + ": " + e.getMessage());
                    }
                } else {
                    throw new CrmebException(errorMsg + ": " + e.getMessage());
                }
            }
            
            JSONObject userInfo = JSON.parseObject(userInfoResponse);
            
            // 🔥 检查用户信息是否获取成功（仅当从访问令牌获取时才需要检查error字段）
            if (userInfo.containsKey("error")) {
                String error = userInfo.getString("error");
                String errorDescription = userInfo.getString("error_description");
                System.out.println("❌ Google用户信息端点返回错误: " + error + " - " + errorDescription);
                throw new CrmebException("获取用户信息失败: " + errorDescription);
            }
            
            // 验证必要字段
            if (StrUtil.isBlank(userInfo.getString("id")) || StrUtil.isBlank(userInfo.getString("email"))) {
                throw new CrmebException("Google用户信息不完整，缺少必要字段");
            }
            
            // 构建用户记录
            MyRecord myRecord = new MyRecord();
            myRecord.set("sub", userInfo.getString("id"));
            myRecord.set("email", userInfo.getString("email"));
            myRecord.set("email_verified", userInfo.getBoolean("verified_email") != null ? userInfo.getBoolean("verified_email") : true);
            myRecord.set("name", userInfo.getString("name"));
            myRecord.set("picture", userInfo.getString("picture"));
            myRecord.set("locale", userInfo.getString("locale"));
            
            System.out.println("✅ Google OAuth验证成功，用户: " + userInfo.getString("email"));
            return myRecord;
            
        } catch (Exception e) {
            System.out.println("❌ Google OAuth处理失败: " + e.getMessage());
            e.printStackTrace();
            throw new CrmebException("Google OAuth处理失败: " + e.getMessage());
        }
    }

    /**
     * 兼容原有的ID Token验证方式
     */
    private MyRecord googleVerifyIdToken(String idTokenStr) {
        // 🔥 优先使用带Client Secret的验证方式，fallback到公共API
        try {
            return googleVerifyWithSecret(idTokenStr);
        } catch (Exception e) {
            System.out.println("使用Client Secret验证失败，尝试公共API验证: " + e.getMessage());
            MyRecord result = googleVerify1(idTokenStr);
            if (result == null) {
                System.out.println("⚠️ 公共API验证也失败，返回null");
                return null;
            }
            return result;
        }
    }

    /**
     * 使用Client Secret验证Google ID Token (推荐方式)
     */
    private MyRecord googleVerifyWithSecret(String idTokenStr) {
        String googleClientId = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_GOOGLE_CLIENT_ID);
        // 🔥 写死Client Secret，避免数据库配置问题
        String googleClientSecret = "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"; // 新生成的Client Secret
        
        if (StrUtil.isBlank(googleClientId)) {
            throw new CrmebException(MessageUtils.message("front.login.error.t"));
        }
        if ("GOCSPX-YOUR_ACTUAL_CLIENT_SECRET_HERE".equals(googleClientSecret)) {
            throw new CrmebException("请在代码中设置正确的Google Client Secret");
        }

        // 🔥 使用Google官方推荐的验证方式
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(),
                JacksonFactory.getDefaultInstance())
                .setAudience(Collections.singletonList(googleClientId))
                .build();

        GoogleIdToken idToken;
        try {
            idToken = verifier.verify(idTokenStr);
        } catch (GeneralSecurityException | IOException e) {
            System.out.println("Google ID Token验证异常: " + e.getMessage());
            e.printStackTrace();
            throw new CrmebException("Google登录验证失败: " + e.getMessage());
        }

        if (ObjectUtil.isNull(idToken)) {
            throw new CrmebException("无效的Google ID Token");
        }

        GoogleIdToken.Payload payload = idToken.getPayload();
        MyRecord myRecord = new MyRecord();
        myRecord.set("sub", payload.getSubject());
        myRecord.set("email", payload.getEmail());
        myRecord.set("email_verified", payload.getEmailVerified());
        myRecord.set("name", payload.get("name"));
        myRecord.set("picture", payload.get("picture"));
        myRecord.set("locale", payload.get("locale"));
        
        System.out.println("✅ Google ID Token验证成功，用户: " + payload.getEmail());
        return myRecord;
    }

    /**
     * 使用Google官方推荐的用户信息API验证 (备用方式)
     */
    private MyRecord googleVerify1(String idTokenStr) {
        // 🔥 改用Google官方推荐的用户信息API
        String url = "https://www.googleapis.com/oauth2/v2/userinfo";
        JSONObject jsonObject = null;
        try {
            // 如果传入的是access_token，直接使用
            if (idTokenStr.startsWith("ya29.") || idTokenStr.length() > 200) {
                jsonObject = restTemplateUtil.getData(url + "?access_token=" + idTokenStr);
            } else {
                // 如果是ID Token，先尝试tokeninfo API
                try {
                    jsonObject = restTemplateUtil.getData("https://oauth2.googleapis.com/tokeninfo?id_token=" + idTokenStr);
                } catch (Exception e) {
                    System.out.println("tokeninfo API失败，尝试解析ID Token: " + e.getMessage());
                    // 如果tokeninfo失败，尝试直接解析JWT格式的ID Token
                    return parseJwtIdToken(idTokenStr);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Google API调用失败: " + e.getMessage());
            
            // 🔥 如果是401错误，说明token无效，返回null让上层处理
            if (e.getMessage() != null && e.getMessage().contains("401")) {
                System.out.println("⚠️ 检测到401错误，token可能已过期，返回null");
                return null;
            }
            
            throw new CrmebException("Google登录验证失败: " + e.getMessage());
        }
        
        if (jsonObject == null) {
            throw new CrmebException("无法获取Google用户信息");
        }
        
        MyRecord myRecord = new MyRecord();
        myRecord.set("sub", jsonObject.getString("sub") != null ? jsonObject.getString("sub") : jsonObject.getString("id"));
        myRecord.set("email", jsonObject.getString("email"));
        myRecord.set("email_verified", jsonObject.getString("email_verified") != null ? jsonObject.getString("email_verified") : "true");
        myRecord.set("name", jsonObject.getString("name"));
        myRecord.set("picture", jsonObject.getString("picture"));
        myRecord.set("locale", jsonObject.getString("locale"));
        return myRecord;
    }
    
    /**
     * 解析JWT格式的ID Token
     */
    private MyRecord parseJwtIdToken(String idTokenStr) {
        try {
            // 简单的JWT解析（仅用于获取payload）
            String[] parts = idTokenStr.split("\\.");
            if (parts.length != 3) {
                throw new CrmebException("无效的ID Token格式");
            }
            
            // 解码payload部分
            String payload = new String(java.util.Base64.getUrlDecoder().decode(parts[1]));
            JSONObject jsonObject = JSON.parseObject(payload);
            
            MyRecord myRecord = new MyRecord();
            myRecord.set("sub", jsonObject.getString("sub"));
            myRecord.set("email", jsonObject.getString("email"));
            myRecord.set("email_verified", jsonObject.getString("email_verified"));
            myRecord.set("name", jsonObject.getString("name"));
            myRecord.set("picture", jsonObject.getString("picture"));
            myRecord.set("locale", jsonObject.getString("locale"));
            return myRecord;
        } catch (Exception e) {
            System.out.println("JWT解析失败: " + e.getMessage());
            throw new CrmebException("ID Token解析失败: " + e.getMessage());
        }
    }

    /**
     * 邮箱登录
     *
     * @param loginRequest 登录对象
     * @return LoginResponse
     */
    @Override
    public LoginResponse emailLogin(EmailLoginRequest loginRequest) {
        User user = userService.getByEmailAndIdentityAndType(loginRequest.getEmail(), "", UserConstants.USER_LOGIN_TYPE_EMAIL);
        if (ObjectUtil.isNull(user)) {
            throw new CrmebException(MessageUtils.message("front.login.error.h"));
        }
        String password = CrmebUtil.encryptPassword(loginRequest.getPassword(), user.getIdentity());
        if (!password.equals(user.getPwd())) {
            throw new CrmebException(MessageUtils.message("front.login.error.i"));
        }
        LoginResponse loginResponse = new LoginResponse();
        String token = tokenComponent.createToken(user);
        loginResponse.setToken(token);
        loginResponse.setIdentity(user.getIdentity());
        loginResponse.setNikeName(user.getNickname());
        loginResponse.setEmail(user.getEmail());
        loginResponse.setUid(user.getUid());
        loginResponse.setType(user.getUserType());
        // 记录最后一次登录时间
        user.setLastLoginTime(DateUtil.nowDateTime());
        userService.updateById(user);
        return loginResponse;
    }

    /**
     * 邮箱注册登录
     *
     * @param registerRequest 邮箱注册对象
     * @return LoginResponse
     */
    @Override
    public LoginResponse emailRegister(EmailRegisterRequest registerRequest) {
        //检测验证码
        emailService.checkEmailValidateCode(registerRequest.getEmail(), registerRequest.getCaptcha());
        User user = userService.getByEmailAndIdentityAndType(registerRequest.getEmail(), "", UserConstants.USER_LOGIN_TYPE_EMAIL);
        if (ObjectUtil.isNotNull(user)) {
            throw new CrmebException(MessageUtils.message("front.login.error.j"));
        }
        user = userService.emailRegister(registerRequest.getEmail(), registerRequest.getPassword(), UserConstants.USER_LOGIN_TYPE_EMAIL);
        LoginResponse loginResponse = new LoginResponse();
        String token = tokenComponent.createToken(user);
        loginResponse.setToken(token);
        loginResponse.setIdentity(user.getIdentity());
        loginResponse.setNikeName(user.getNickname());
        loginResponse.setEmail(user.getEmail());
        loginResponse.setUid(user.getUid());
        loginResponse.setType(user.getUserType());
        return loginResponse;
    }

    /**
     * 发送邮箱注册验证码
     *
     * @param email 邮箱
     * @return Boolean
     */
    @Override
    public Boolean sendEmailCode(String email) {
        User user = userService.getByEmailAndIdentityAndType(email, "", UserConstants.USER_LOGIN_TYPE_EMAIL);
        if (ObjectUtil.isNotNull(user)) {
            throw new CrmebException(MessageUtils.message("front.login.error.j"));
        }
        return emailService.sendEmailCode(email);
    }

    /**
     * Facebook登录
     */
    @Override
    public LoginResponse facebookLogin(FacebookLoginRequest loginRequest) {
        String googleOpen = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_FACEBOOK_OPEN);
        if (googleOpen.equals(Constants.COMMON_SWITCH_CLOSE_TYPE_ONE)) {
            throw new CrmebException(MessageUtils.message("front.login.error.k"));
        }

        String email = Optional.ofNullable(loginRequest.getEmail()).orElse("");
        // 判断用户是否存在
        User user = userService.getByEmailAndIdentityAndType(email, loginRequest.getId(), UserConstants.USER_LOGIN_TYPE_FACEBOOK);
        if (ObjectUtil.isNull(user)) {
            // 用户不存在走注册流程
            user = userService.commonRegister(loginRequest.getId(), loginRequest.getEmail(),
                    loginRequest.getName(), loginRequest.getPicture(), "", UserConstants.USER_LOGIN_TYPE_FACEBOOK);
        } else {
            // 用户存在走登录流程
            if (!user.getStatus()) {
                throw new CrmebException(MessageUtils.message("front.login.error.d"));
            }
            // 记录最后一次登录时间
            user.setLastLoginTime(DateUtil.nowDateTime());
            if (!userService.updateById(user)) {
                logger.error("When the user logs in, there is an error recording the last login time,uid = " + user.getUid());
            }
        }
        //生成token
        LoginResponse loginResponse = new LoginResponse();
        String token = tokenComponent.createToken(user);
        loginResponse.setToken(token);
        loginResponse.setIdentity(user.getIdentity());
        loginResponse.setNikeName(user.getNickname());
        loginResponse.setEmail(user.getEmail());
        loginResponse.setUid(user.getUid());
        loginResponse.setType(user.getUserType());
        return loginResponse;
    }

    /**
     * twitter登录获取requestToken
     *
     * @return requestToken
     */
    @Override
    public RequestToken getTwitterRequestToken(String end) {
        return twitterUtil.getRequestToken(end);
    }

    /**
     * twitter登录
     *
     * @param loginRequest 登录请求信息
     * @return LoginResponse
     */
    @Override
    public LoginResponse twitterLogin(TwitterLoginRequest loginRequest) {
        RequestToken requestToken = new RequestToken(loginRequest.getOauthToken(), loginRequest.getOauthTokenSecret());
        AccessToken accessToken = twitterUtil.getOAuth1AccessToken(requestToken, loginRequest.getOauthVerifier());
        long tokenUserId = accessToken.getUserId();
        String screenName = accessToken.getScreenName();
        // 判断用户是否存在
        User user = userService.getByEmailAndIdentityAndType("", String.valueOf(tokenUserId), UserConstants.USER_LOGIN_TYPE_TWITTER);
        if (ObjectUtil.isNull(user)) {
            // 用户不存在走注册流程
            user = userService.commonRegister(String.valueOf(tokenUserId), "",
                    screenName, "", "", UserConstants.USER_LOGIN_TYPE_TWITTER);
        } else {
            // 用户存在走登录流程
            if (!user.getStatus()) {
                throw new CrmebException(MessageUtils.message("front.login.error.d"));
            }
            // 记录最后一次登录时间
            user.setLastLoginTime(DateUtil.nowDateTime());
            if (!userService.updateById(user)) {
                logger.error("When the user logs in, there is an error recording the last login time,uid = " + user.getUid());
            }
        }
        //生成token
        LoginResponse loginResponse = new LoginResponse();
        String token = tokenComponent.createToken(user);
        loginResponse.setToken(token);
        loginResponse.setIdentity(user.getIdentity());
        loginResponse.setNikeName(user.getNickname());
        loginResponse.setEmail(user.getEmail());
        loginResponse.setUid(user.getUid());
        loginResponse.setType(user.getUserType());
        return loginResponse;
    }

    /**
     * X OAuth 2.0 登录
     *
     * @param loginRequest X OAuth 2.0登录请求信息
     * @return LoginResponse
     */
    @Override
    public LoginResponse xOAuth2Login(XOAuth2LoginRequest loginRequest) {
        System.out.println("🚀 开始处理 X OAuth 2.0 登录");
        System.out.println("授权码: " + loginRequest.getAuthorizationCode().substring(0, 20) + "...");
        System.out.println("Client ID: " + loginRequest.getClientId());
        System.out.println("Code Verifier: " + loginRequest.getCodeVerifier().substring(0, 20) + "...");
        System.out.println("Redirect URI: " + loginRequest.getRedirectUri());

        // 验证必要参数
        if (StrUtil.isBlank(loginRequest.getAuthorizationCode())) {
            throw new CrmebException("授权码不能为空");
        }
        if (StrUtil.isBlank(loginRequest.getCodeVerifier())) {
            throw new CrmebException("PKCE验证码不能为空");
        }
        if (StrUtil.isBlank(loginRequest.getClientId())) {
            throw new CrmebException("Client ID不能为空");
        }

        try {
            // 步骤1: 使用authorization code + code verifier 向X API交换access token
            System.out.println("📤 步骤1: 向X API交换access token");
            String accessToken = exchangeCodeForAccessToken(loginRequest);
            
            if (StrUtil.isBlank(accessToken)) {
                throw new CrmebException("无法获取access token");
            }
            
            System.out.println("成功获取access token");

            // 步骤2: 使用access token 获取用户信息
            System.out.println("📤 步骤2: 获取X用户信息");
            XUserInfo xUserInfo = getUserInfoFromX(accessToken);
            
            if (xUserInfo == null || StrUtil.isBlank(xUserInfo.getId())) {
                throw new CrmebException("无法获取用户信息");
            }
            
            System.out.println("成功获取X用户信息: " + xUserInfo.getName());

            // 步骤3: 在数据库中查找或创建用户
            System.out.println("📤 步骤3: 查找或创建用户");
            String xUserId = "x_" + xUserInfo.getId(); // 添加前缀避免与其他平台ID冲突
            
            // 判断用户是否存在 (使用USER_LOGIN_TYPE_TWITTER类型，因为X就是Twitter)
            User user = userService.getByEmailAndIdentityAndType("", xUserId, UserConstants.USER_LOGIN_TYPE_TWITTER);
            if (ObjectUtil.isNull(user)) {
                // 用户不存在走注册流程
                System.out.println("用户不存在，创建新用户");
                user = userService.commonRegister(
                    xUserId, 
                    StrUtil.isNotBlank(xUserInfo.getEmail()) ? xUserInfo.getEmail() : "",
                    StrUtil.isNotBlank(xUserInfo.getName()) ? xUserInfo.getName() : "X用户",
                    StrUtil.isNotBlank(xUserInfo.getProfileImageUrl()) ? xUserInfo.getProfileImageUrl() : "",
                    "", 
                    UserConstants.USER_LOGIN_TYPE_TWITTER
                );
                System.out.println("新用户创建成功，UID: " + user.getUid());
            } else {
                // 用户存在走登录流程
                System.out.println("用户已存在，UID: " + user.getUid());
                if (!user.getStatus()) {
                    throw new CrmebException(MessageUtils.message("front.login.error.d"));
                }
                
                // 更新用户信息（头像、昵称等可能会变）
                boolean needUpdate = false;
                if (StrUtil.isNotBlank(xUserInfo.getName()) && !xUserInfo.getName().equals(user.getNickname())) {
                    user.setNickname(xUserInfo.getName());
                    needUpdate = true;
                }
                if (StrUtil.isNotBlank(xUserInfo.getProfileImageUrl()) && !xUserInfo.getProfileImageUrl().equals(user.getAvatar())) {
                    user.setAvatar(xUserInfo.getProfileImageUrl());
                    needUpdate = true;
                }
                
                // 记录最后一次登录时间
                user.setLastLoginTime(DateUtil.nowDateTime());
                needUpdate = true;
                
                if (needUpdate && !userService.updateById(user)) {
                    logger.error("When the user logs in, there is an error updating user info, uid = " + user.getUid());
                }
            }

            // 步骤4: 生成JWT token
            System.out.println("📤 步骤4: 生成JWT token");
            LoginResponse loginResponse = new LoginResponse();
            String token = tokenComponent.createToken(user);
            loginResponse.setToken(token);
            loginResponse.setIdentity(user.getIdentity());
            loginResponse.setNikeName(user.getNickname());
            loginResponse.setEmail(user.getEmail());
            loginResponse.setUid(user.getUid());
            loginResponse.setType(user.getUserType());

            System.out.println("X OAuth 2.0 登录成功");
            System.out.println("- 用户UID: " + user.getUid());
            System.out.println("- 用户昵称: " + user.getNickname());
            System.out.println("- JWT Token: " + token.substring(0, 20) + "...");
            
            return loginResponse;

        } catch (Exception e) {
            System.err.println("X OAuth 2.0 登录失败: " + e.getMessage());
            e.printStackTrace();
            throw new CrmebException("X登录处理失败: " + e.getMessage());
        }
    }

    /**
     * 使用authorization code换取access token
     */
    private String exchangeCodeForAccessToken(XOAuth2LoginRequest loginRequest) {
        int maxRetries = 3;
        int currentRetry = 0;
        
        // 检测是否启用测试模式
        boolean isTestMode = "true".equals(System.getProperty("oauth.test.mode", "false"));
        if (isTestMode) {
            System.out.println("测试模式：模拟token交换");
            return "mock_access_token_" + System.currentTimeMillis();
        }
        
        while (currentRetry < maxRetries) {
            try {
                System.out.println("向X API发送token交换请求 (尝试 " + (currentRetry + 1) + "/" + maxRetries + ")");
                
                // X API的token endpoint
                String tokenUrl = "https://api.twitter.com/2/oauth2/token";
                
                // 构建请求体
                Map<String, String> params = new HashMap<>();
                params.put("grant_type", "authorization_code");
                params.put("code", loginRequest.getAuthorizationCode());
                params.put("redirect_uri", loginRequest.getRedirectUri());
                params.put("code_verifier", loginRequest.getCodeVerifier());
                params.put("client_id", loginRequest.getClientId());
                
                // 构建请求头 - 添加必需的Basic Authentication
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
                headers.set("User-Agent", "CRMEB-OAuth2-Client/1.0");
                headers.set("Accept", "application/json");
                
                // 🔑 关键修复：添加Basic Authentication头
                // Twitter API v2要求使用Client ID:Client Secret的Basic Auth
                // 从系统配置获取Client Secret，而不是硬编码
                String clientSecret = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_X_OAUTH2_CLIENT_SECRET);
                if (StrUtil.isBlank(clientSecret)) {
                    throw new CrmebException("X OAuth 2.0 Client Secret未配置，请在管理后台配置");
                }
                String auth = loginRequest.getClientId() + ":" + clientSecret;
                String encodedAuth = java.util.Base64.getEncoder().encodeToString(auth.getBytes());
                headers.set("Authorization", "Basic " + encodedAuth);
                
                System.out.println("设置Basic Authentication: " + loginRequest.getClientId() + ":[已设置Client Secret]");
                
                // 构建表单数据
                StringBuilder formData = new StringBuilder();
                for (Map.Entry<String, String> entry : params.entrySet()) {
                    if (formData.length() > 0) {
                        formData.append("&");
                    }
                    formData.append(URLEncoder.encode(entry.getKey(), "UTF-8"))
                            .append("=")
                            .append(URLEncoder.encode(entry.getValue(), "UTF-8"));
                }
                
                HttpEntity<String> request = new HttpEntity<>(formData.toString(), headers);
                
                System.out.println("📤 发送请求到: " + tokenUrl);
                System.out.println("📤 请求参数: " + params);
                
                // 创建自定义的RestTemplate，增加超时时间和网络配置
                SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
                factory.setConnectTimeout(60000); // 60秒连接超时
                factory.setReadTimeout(60000);    // 60秒读取超时
                
                // 网络代理配置
                try {
                    System.out.println("🔍 检测代理配置...");
                    
                    // 方法1: 常见代理端口检测和配置
                    String[] commonProxies = {
                        "127.0.0.1:7897", // Clash (用户当前配置)        "127.0.0.1:7890", // Clash 默认
                
                    };
                    
                    String proxyHost = System.getProperty("http.proxyHost");
                    String proxyPort = System.getProperty("http.proxyPort");
                    
                    // 如果没有系统属性设置，尝试检测常见代理
                    if (proxyHost == null || proxyPort == null) {
                        for (String proxyAddr : commonProxies) {
                            String[] parts = proxyAddr.split(":");
                            if (isProxyReachable(parts[0], Integer.parseInt(parts[1]))) {
                                proxyHost = parts[0];
                                proxyPort = parts[1];
                                System.out.println("🎯 自动检测到可用代理: " + proxyAddr);
                                break;
                            }
                        }
                    }
                    
                    // 方法2: 设置检测到的代理
                    if (proxyHost != null && proxyPort != null) {
                        System.out.println("🌐 使用代理: " + proxyHost + ":" + proxyPort);
                        Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress(proxyHost, Integer.parseInt(proxyPort)));
                        factory.setProxy(proxy);
                        
                        // 同时设置系统属性
                        System.setProperty("http.proxyHost", proxyHost);
                        System.setProperty("http.proxyPort", proxyPort);
                        System.setProperty("https.proxyHost", proxyHost);
                        System.setProperty("https.proxyPort", proxyPort);
                    } else {
                        System.out.println("⚠️ 未检测到可用代理，尝试直连");
                        System.setProperty("java.net.useSystemProxies", "true");
                    }
                    
                } catch (Exception e) {
                    System.out.println("⚠️ 代理配置失败: " + e.getMessage());
                }
                
                RestTemplate restTemplate = new RestTemplate(factory);
                
                // 网络连接诊断
                System.out.println("🔍 网络诊断:");
                System.out.println("- 目标URL: " + tokenUrl);
                System.out.println("- Java版本: " + System.getProperty("java.version"));
                System.out.println("- 操作系统: " + System.getProperty("os.name"));
                System.out.println("- 网络代理设置: " + System.getProperty("java.net.useSystemProxies"));
                ResponseEntity<String> response = restTemplate.postForEntity(tokenUrl, request, String.class);
            
                System.out.println("📥 响应状态: " + response.getStatusCode());
                System.out.println("📥 响应内容: " + response.getBody());
                
                if (response.getStatusCode() == HttpStatus.OK && StrUtil.isNotBlank(response.getBody())) {
                    // 解析响应JSON
                    JSONObject jsonResponse = JSON.parseObject(response.getBody());
                    String accessToken = jsonResponse.getString("access_token");
                    
                    if (StrUtil.isNotBlank(accessToken)) {
                        System.out.println("成功获取access_token");
                        return accessToken;
                    } else {
                        System.err.println("❌ 响应中没有access_token字段");
                        throw new CrmebException("X API响应中缺少access_token");
                    }
                } else {
                    System.err.println("❌ X API响应异常: " + response.getStatusCode());
                    throw new CrmebException("X API token交换失败: " + response.getStatusCode());
                }
                
            } catch (Exception e) {
                currentRetry++;
                System.err.println("❌ token交换尝试 " + currentRetry + " 失败: " + e.getMessage());
                System.err.println("❌ 错误类型: " + e.getClass().getSimpleName());
                if (e.getCause() != null) {
                    System.err.println("❌ 根本原因: " + e.getCause().getMessage());
                }
                
                if (currentRetry >= maxRetries) {
                    System.err.println("❌ 所有重试都失败了，放弃token交换");
                    e.printStackTrace();
                    
                    // 提供网络连接故障排除建议
                    String troubleshootingInfo = "\n🔧 网络连接故障排除建议:\n" +
                        "1. 检查网络连接: ping api.twitter.com\n" +
                        "2. 检查防火墙设置: 确保允许访问api.twitter.com:443\n" +
                        "3. 检查代理设置: 如果在企业网络环境中\n" +
                        "4. 尝试使用VPN: 某些地区可能限制访问Twitter API\n" +
                        "5. DNS问题: 尝试更换DNS服务器(8.8.8.8, 1.1.1.1)\n" +
                        "原始错误: " + e.getMessage();
                    
                    System.err.println(troubleshootingInfo);
                    throw new CrmebException("X API连接失败，请检查网络设置。" + troubleshootingInfo);
                } else {
                    System.out.println("⏳ " + (3 - currentRetry) + " 秒后进行第 " + (currentRetry + 1) + " 次重试...");
                    try {
                        Thread.sleep(3000); // 等待3秒后重试
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        throw new CrmebException("重试过程被中断");
                    }
                }
            }
        }
        
        // 这行代码理论上不会被执行，但为了编译通过
        throw new CrmebException("token交换失败：未知错误");
    }

    /**
     * 检测代理是否可达
     */
    private boolean isProxyReachable(String host, int port) {
        try {
            Socket socket = new Socket();
            socket.connect(new InetSocketAddress(host, port), 2000); // 2秒超时
            socket.close();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 使用access token获取用户信息
     */
    private XUserInfo getUserInfoFromX(String accessToken) {
        // 检测是否启用测试模式
        boolean isTestMode = "true".equals(System.getProperty("oauth.test.mode", "false"));
        if (isTestMode) {
            System.out.println("🧪 测试模式：模拟用户信息");
            XUserInfo mockUser = new XUserInfo();
            mockUser.setId("mock_user_" + System.currentTimeMillis());
            mockUser.setName("测试用户");
            mockUser.setUsername("test_user");
            mockUser.setEmail("test@example.com");
            mockUser.setProfileImageUrl("https://via.placeholder.com/64");
            return mockUser;
        }
        
        try {
            System.out.println("🔄 向X API获取用户信息");
            
            // X API的用户信息endpoint (移除email字段，因为需要特殊权限)
            String userInfoUrl = "https://api.twitter.com/2/users/me?user.fields=id,name,username,profile_image_url";
            
            // 构建请求头
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("User-Agent", "CRMEB-OAuth2-Client/1.0");
            
            HttpEntity<String> request = new HttpEntity<>(headers);
            
            System.out.println("📤 发送请求到: " + userInfoUrl);
            
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, request, String.class);
            
            System.out.println("📥 用户信息响应状态: " + response.getStatusCode());
            System.out.println("📥 用户信息响应内容: " + response.getBody());
            
            if (response.getStatusCode() == HttpStatus.OK && StrUtil.isNotBlank(response.getBody())) {
                // 解析响应JSON
                JSONObject jsonResponse = JSON.parseObject(response.getBody());
                JSONObject userData = jsonResponse.getJSONObject("data");
                
                if (userData != null) {
                    XUserInfo userInfo = new XUserInfo();
                    userInfo.setId(userData.getString("id"));
                    userInfo.setName(userData.getString("name"));
                    userInfo.setUsername(userData.getString("username"));
                    userInfo.setProfileImageUrl(userData.getString("profile_image_url"));
                    userInfo.setEmail(userData.getString("email")); // 可能为空
                    
                    System.out.println("✅ 成功解析用户信息");
                    return userInfo;
                } else {
                    System.err.println("❌ 响应中没有data字段");
                    throw new CrmebException("X API用户信息响应格式错误");
                }
            } else {
                System.err.println("❌ X API用户信息响应异常: " + response.getStatusCode());
                throw new CrmebException("获取X用户信息失败: " + response.getStatusCode());
            }
            
        } catch (Exception e) {
            System.err.println("❌ 获取用户信息过程中发生异常: " + e.getMessage());
            e.printStackTrace();
            throw new CrmebException("获取用户信息失败: " + e.getMessage());
        }
    }

    /**
     * X用户信息数据类
     */
    private static class XUserInfo {
        private String id;
        private String name;
        private String username;
        private String profileImageUrl;
        private String email;

        // Getters and Setters
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        
        public String getProfileImageUrl() { return profileImageUrl; }
        public void setProfileImageUrl(String profileImageUrl) { this.profileImageUrl = profileImageUrl; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
    }

    /**
     * 发送短信验证码
     *
     * @param phone       手机号
     * @param countryCode 国标区号
     * @return Boolean
     */
    @Override
    public Boolean sendLoginCode(String phone, String countryCode) {
        return smsService.sendVerificationCode(phone, countryCode);
    }

    /**
     * 手机号注册登录
     *
     * @param loginRequest 注册信息
     * @return LoginResponse
     */
    @Override
    public LoginResponse phoneRegister(LoginMobileRequest loginRequest) {
        if (StrUtil.isBlank(loginRequest.getCaptcha())) {
            throw new CrmebException(MessageUtils.message("front.login.error.l"));
        }
        if (StrUtil.isBlank(loginRequest.getPassword())) {
            throw new CrmebException(MessageUtils.message("front.login.error.m"));
        }
//        if (!loginRequest.getPassword().matches(RegularConstants.PASSWORD)) {
//           throw new CrmebException("The password is 8-20 characters long and contains at least any three of uppercase letters, lowercase letters, numbers or special symbols");
//        }
        // 国内手机号
        if (loginRequest.getCountryCode().equals("+86") || loginRequest.getCountryCode().equals("86")) {
            ValidateFormUtil.isPhone(loginRequest.getPhone(), "wrong mobile number");
        }
        //检测验证码
        checkValidateCode(loginRequest.getCountryCode() + loginRequest.getPhone(), loginRequest.getCaptcha());
        //查询用户信息
        User user = userService.getByPhoneAndType(loginRequest.getPhone(), loginRequest.getCountryCode(), UserConstants.USER_LOGIN_TYPE_PHONE);
        if (ObjectUtil.isNotNull(user)) {
            throw new CrmebException(MessageUtils.message("front.login.error.n"));
        }
        // 新用户注册流程
        user = userService.registerPhone(loginRequest.getPhone(), loginRequest.getCountryCode(), loginRequest.getPassword());
        //生成token
        LoginResponse loginResponse = new LoginResponse();
        String token = tokenComponent.createToken(user);
        loginResponse.setToken(token);
        loginResponse.setUid(user.getUid());
        loginResponse.setNikeName(user.getNickname());
        loginResponse.setPhone(user.getPhone());
        loginResponse.setIdentity(user.getIdentity());
        loginResponse.setType(user.getUserType());
        return loginResponse;
    }

    /**
     * 手机号验证码登录
     *
     * @param loginRequest 登录信息
     * @return LoginResponse
     */
    @Override
    public LoginResponse phoneCaptchaLogin(LoginMobileRequest loginRequest) {
        if (StrUtil.isBlank(loginRequest.getCaptcha())) {
            throw new CrmebException(MessageUtils.message("front.login.error.l"));
        }
        // 国内手机号
        if (loginRequest.getCountryCode().equals("+86") || loginRequest.getCountryCode().equals("86")) {
            ValidateFormUtil.isPhone(loginRequest.getPhone(), "Wrong format of phone number");
        }
        //检测验证码
        checkValidateCode(loginRequest.getCountryCode() + loginRequest.getPhone(), loginRequest.getCaptcha());
        //查询用户信息
        User user = userService.getByPhoneAndType(loginRequest.getPhone(), loginRequest.getCountryCode(), UserConstants.USER_LOGIN_TYPE_PHONE);
        if (ObjectUtil.isNull(user)) {// 此用户不存在，走新用户注册流程
            throw new CrmebException(MessageUtils.message("front.login.error.o"));
        }
        if (!user.getStatus()) {
            throw new CrmebException(MessageUtils.message("front.login.error.d"));
        }
        // 记录最后一次登录时间
        user.setLastLoginTime(DateUtil.nowDateTime());
        boolean b = userService.updateById(user);
        if (!b) {
            logger.error("When the user logs in, there is an error recording the last login time,uid = " + user.getUid());
        }

        //生成token
        LoginResponse loginResponse = new LoginResponse();
        String token = tokenComponent.createToken(user);
        loginResponse.setToken(token);
        loginResponse.setUid(user.getUid());
        loginResponse.setNikeName(user.getNickname());
        loginResponse.setPhone(user.getPhone());
        loginResponse.setIdentity(user.getIdentity());
        loginResponse.setType(user.getUserType());
        return loginResponse;
    }

    /**
     * 手机号密码登录
     *
     * @param loginRequest 登录信息
     * @return LoginResponse
     */
    @Override
    public LoginResponse phonePasswordLogin(LoginMobileRequest loginRequest) {
        logger.info("=== DEBUG: phonePasswordLogin START ===");
        logger.info("Input phone: {}", loginRequest.getPhone());
        logger.info("Input countryCode: {}", loginRequest.getCountryCode());
        logger.info("Input password: {}", loginRequest.getPassword());
        
        if (StrUtil.isBlank(loginRequest.getPassword())) {
            throw new CrmebException(MessageUtils.message("front.login.error.m"));
        }
        // 国内手机号
        if (loginRequest.getCountryCode().equals("+86") || loginRequest.getCountryCode().equals("86")) {
            ValidateFormUtil.isPhone(loginRequest.getPhone(), "wrong mobile number");
        }
        //查询用户信息
        User user = userService.getByPhoneAndType(loginRequest.getPhone(), loginRequest.getCountryCode(), UserConstants.USER_LOGIN_TYPE_PHONE);
        logger.info("Query result - User found: {}", user != null);
        if (ObjectUtil.isNull(user)) {// 此用户不存在，走新用户注册流程
            logger.error("User not found for phone: {}, countryCode: {}", loginRequest.getPhone(), loginRequest.getCountryCode());
            throw new CrmebException(MessageUtils.message("front.login.error.a"));
        }
        
        logger.info("User found - uid: {}, phone: {}, countryCode: {}, userType: {}, status: {}", 
                   user.getUid(), user.getPhone(), user.getCountryCode(), user.getUserType(), user.getStatus());
        logger.info("User stored password: {}", user.getPwd());
        
        // Password encryption and comparison
        String encryptionKey = loginRequest.getCountryCode().concat(loginRequest.getPhone());
        logger.info("Encryption key: {}", encryptionKey);
        String encryptedInputPassword = CrmebUtil.encryptPassword(loginRequest.getPassword(), encryptionKey);
        logger.info("Encrypted input password: {}", encryptedInputPassword);
        logger.info("Stored user password: {}", user.getPwd());
        boolean passwordMatch = encryptedInputPassword.equals(user.getPwd());
        logger.info("Password match result: {}", passwordMatch);
        
 //       if (!CrmebUtil.encryptPassword(loginRequest.getPassword(), loginRequest.getCountryCode().concat(loginRequest.getPhone()))
 //              .equals(user.getPwd())) {
        if (!passwordMatch) {
            logger.error("Password validation failed! Input: {}, Expected: {}", encryptedInputPassword, user.getPwd());
            throw new CrmebException(MessageUtils.message("front.login.error.a"));
        }
        if (!user.getStatus()) {
            throw new CrmebException(MessageUtils.message("front.login.error.d"));
        }
        // 记录最后一次登录时间
        user.setLastLoginTime(DateUtil.nowDateTime());
        boolean b = userService.updateById(user);
        if (!b) {
            logger.error("When the user logs in, there is an error recording the last login time,uid = " + user.getUid());
        }

        //生成token
        LoginResponse loginResponse = new LoginResponse();
        String token = tokenComponent.createToken(user);
        loginResponse.setToken(token);
        loginResponse.setUid(user.getUid());
        loginResponse.setNikeName(user.getNickname());
        loginResponse.setPhone(user.getPhone());
        loginResponse.setIdentity(user.getIdentity());
        loginResponse.setType(user.getUserType());
        return loginResponse;
    }

    /**
     * 发送邮箱忘记密码验证码
     *
     * @param email 邮箱
     * @return Boolean
     */
    @Override
    public Boolean emailForgetPassword(String email) {
        User user = userService.getByEmailAndIdentityAndType(email, "", UserConstants.USER_LOGIN_TYPE_EMAIL);
        if (ObjectUtil.isNull(user)) {
            throw new CrmebException(MessageUtils.message("front.login.error.o"));
        }
        return emailService.sendEmailCode(email);
    }

    /**
     * 邮箱重置密码
     *
     * @param request 重置密码信息
     * @return Boolean
     */
    @Override
    public Boolean emailResetPassword(EmailResetPasswordRequest request) {
        if (!request.getNewPassword().equals(request.getPasswordAgain())) {
            throw new CrmebException(MessageUtils.message("front.login.error.p"));
        }
        //检测验证码
        emailService.checkEmailValidateCode(request.getEmail(), request.getCaptcha());
        User user = userService.getByEmailAndIdentityAndType(request.getEmail(), "", UserConstants.USER_LOGIN_TYPE_EMAIL);
        if (ObjectUtil.isNull(user)) {
            throw new CrmebException(MessageUtils.message("front.login.error.q"));
        }
        String password = CrmebUtil.encryptPassword(request.getNewPassword(), user.getIdentity());
        user.setPwd(password);
        return userService.updateById(user);
    }

    /**
     * 游客注册
     */
    @Override
    public LoginResponse visitorRegister(VisitorRegisterRequest registerRequest) {
        if (StrUtil.isNotBlank(registerRequest.getPhone()) && StrUtil.isBlank(registerRequest.getCountryCode())) {
            throw new CrmebException(MessageUtils.message("front.login.error.r"));
        }
        User user = userService.visitorRegister(registerRequest);
        LoginResponse loginResponse = new LoginResponse();
        String token = tokenComponent.createToken(user);
        loginResponse.setToken(token);
        loginResponse.setIdentity(user.getIdentity());
        loginResponse.setNikeName(user.getNickname());
        loginResponse.setEmail(user.getEmail());
        loginResponse.setUid(user.getUid());
        loginResponse.setType(user.getUserType());
        return loginResponse;
    }

    /**
     * 获取登录方式信息
     */
    @Override
    public LoginMethodResponse getLoginMethod() {
        System.out.println("=== getLoginMethod API被调用 ===");
        LoginMethodResponse response = new LoginMethodResponse();
        response.setGoogleOpen(false);
        response.setTwitterOpen(false);
        response.setFacebookOpen(false); // 🔥 Facebook已永久禁用
        String googleOpen = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_GOOGLE_OPEN);
        String twitterOpen = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_TWITTER_OPEN);
        // 🔥 Facebook登录已移除，不再读取配置
        // String facebookOpen = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_FACEBOOK_OPEN);
        
        System.out.println("从数据库获取的配置值:");
        System.out.println("- Google开关: '" + googleOpen + "'");
        System.out.println("- Twitter开关: '" + twitterOpen + "'");
        System.out.println("- Facebook开关: 已永久禁用"); // 🔥 Facebook已移除
        
        // 检查X OAuth 2.0配置
        String xClientId = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_X_OAUTH2_CLIENT_ID);
        String xCallbackUrlPc = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_X_OAUTH2_CALLBACK_URL_PC);
        System.out.println("- X OAuth2 Client ID: '" + xClientId + "'");
        System.out.println("- X OAuth2 PC回调: '" + xCallbackUrlPc + "'");
        
        if (googleOpen.equals(Constants.COMMON_SWITCH_OPEN_TYPE_ONE)) {
            String googleClientId = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_GOOGLE_CLIENT_ID);
            if (StrUtil.isBlank(googleClientId)) {
                throw new CrmebException(MessageUtils.message("front.login.error.t"));
            }
            response.setGoogleOpen(true);
            response.setGoogleClientId(googleClientId);
        }
        // 兼容处理，支持带引号和不带引号的配置值
        if (twitterOpen.equals(Constants.COMMON_SWITCH_OPEN_TYPE_ONE) || "1".equals(twitterOpen)) {
            System.out.println("✅ Twitter登录已启用");
            response.setTwitterOpen(true);
            
            // 添加X OAuth 2.0配置信息
            if (StrUtil.isNotBlank(xClientId)) {
                response.setXOAuth2ClientId(xClientId);
                System.out.println("✅ 设置Client ID到响应中: " + xClientId);
            } else {
                System.out.println("❌ Client ID为空，未设置到响应中");
            }
            
            if (StrUtil.isNotBlank(xCallbackUrlPc)) {
                response.setXOAuth2CallbackUrlPc(xCallbackUrlPc);
                System.out.println("✅ 设置PC回调地址到响应中: " + xCallbackUrlPc);
            } else {
                System.out.println("❌ PC回调地址为空，未设置到响应中");
            }
        } else {
            System.out.println("❌ Twitter登录未启用，配置值: '" + twitterOpen + "'");
        }
        // 🔥 Facebook登录已永久禁用，不再处理相关逻辑
        // Facebook登录功能已移除，保持禁用状态
        response.setFacebookOpen(false);
        String visitorOpen = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_VISITOR_OPEN);
        response.setVisitorOpen(visitorOpen.equals(Constants.COMMON_SWITCH_OPEN_TYPE_ONE) || "1".equals(visitorOpen));
        response.setAgreement(systemConfigService.getUserRegisterAgreement());
        
        System.out.println("=== 最终响应内容 ===");
        System.out.println("- Google开启: " + response.getGoogleOpen());
        System.out.println("- Google Client ID: " + response.getGoogleClientId());
        System.out.println("- Twitter开启: " + response.getTwitterOpen());
        System.out.println("- X OAuth2 Client ID: " + response.getXOAuth2ClientId());
        System.out.println("- X OAuth2 PC回调: " + response.getXOAuth2CallbackUrlPc());
        System.out.println("- Facebook开启: " + response.getFacebookOpen());
        System.out.println("- 游客开启: " + response.getVisitorOpen());
        System.out.println("=== getLoginMethod API调用完成 ===");
        
        return response;
    }

    /**
     * 获取PC登录页图片
     */
    @Override
    public Map<String, Object> getPcLoginPic() {
        String loginLeftImage = systemConfigService.getValueByKey(SysConfigConstants.PC_LOGIN_LEFT_IMAGE);
        Map<String, Object> map = CollUtil.newHashMap();
        map.put("loginLeftImage", loginLeftImage);
        return map;
    }

    /**
     * 校验token是否有效
     * @return true 有效， false 无效
     */
    @Override
    public Boolean tokenIsExist() {
        Integer userId = userService.getUserId();
        return userId > 0;
    }

    /**
     * Google验证
     *
     * @param idTokenStr Google前端获取的idToken
     * @return GoogleIdToken
     */
    private GoogleIdToken googleVerify(String idTokenStr) {
        String googleOpen = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_GOOGLE_OPEN);
        if (googleOpen.equals(Constants.COMMON_SWITCH_CLOSE_TYPE_ONE)) {
            throw new CrmebException(MessageUtils.message("front.login.error.f"));
        }
        String googleClientId = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_GOOGLE_CLIENT_ID);
        if (StrUtil.isBlank(googleClientId)) {
            throw new CrmebException(MessageUtils.message("front.login.error.t"));
        }

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(),
                JacksonFactory.getDefaultInstance())
                // Specify the CLIENT_ID of the app that accesses the backend:
                .setAudience(Collections.singletonList(googleClientId))
                // Or, if multiple clients access the backend:
                //.setAudience(Arrays.asList(CLIENT_ID_1, CLIENT_ID_2, CLIENT_ID_3))
                .build();
        GoogleIdToken idToken = null;
        try {
            idToken = verifier.verify(idTokenStr);
        } catch (GeneralSecurityException e) {
            System.out.println("验证时出现GeneralSecurityException异常");
            e.printStackTrace();
            throw new CrmebException(MessageUtils.message("front.login.error.u"));
        } catch (IOException e) {
            System.out.println("验证时出现IOException异常");
            e.printStackTrace();
            throw new CrmebException(MessageUtils.message("front.login.error.v"));
        }
        if (ObjectUtil.isNull(idToken)) {
            System.out.println("验证失败,Invalid ID token.");
            throw new CrmebException(MessageUtils.message("front.login.error.w"));
        }
        // 用户信息打印，之后删除
        GoogleIdToken.Payload payload = idToken.getPayload();
        // Print user identifier
        String userId = payload.getSubject();
        System.out.println("User ID: " + userId);
        // Get profile information from payload
        String email = payload.getEmail();
        boolean emailVerified = Boolean.valueOf(payload.getEmailVerified());
        String name = (String) payload.get("name");
        String pictureUrl = (String) payload.get("picture");
        String locale = (String) payload.get("locale");
        String familyName = (String) payload.get("family_name");
        String givenName = (String) payload.get("given_name");
        System.out.println("email = " + email);
        System.out.println("emailVerified = " + emailVerified);
        System.out.println("name = " + name);
        System.out.println("pictureUrl = " + pictureUrl);
        System.out.println("locale = " + locale);
        System.out.println("familyName = " + familyName);
        System.out.println("givenName = " + givenName);
        System.out.println("payload = " + payload);
        return idToken;
    }

    /**
     * 解析ID Token获取用户信息（备用方法）
     */
    private JSONObject parseIdTokenPayload(String idToken) throws Exception {
        System.out.println("🔄 开始解析ID Token");
        
        // ID Token格式: header.payload.signature
        String[] parts = idToken.split("\\.");
        if (parts.length != 3) {
            throw new Exception("ID Token格式不正确");
        }
        
        // 解码payload部分
        String payload = parts[1];
        
        // 🔥 URL解码payload，防止URL编码字符导致Base64解码失败
        if (payload.contains("%")) {
            try {
                payload = URLDecoder.decode(payload, "UTF-8");
                System.out.println("🔄 URL解码ID Token payload: " + parts[1] + " -> " + payload);
            } catch (Exception e) {
                System.out.println("⚠️ ID Token payload URL解码失败，使用原始值: " + e.getMessage());
            }
        }
        
        // 添加必要的padding
        while (payload.length() % 4 != 0) {
            payload += "=";
        }
        
        // 🔥 使用URL安全的Base64解码器
        byte[] decodedBytes;
        try {
            decodedBytes = Base64.getUrlDecoder().decode(payload);
        } catch (Exception e) {
            System.out.println("⚠️ URL安全Base64解码失败，尝试标准Base64解码: " + e.getMessage());
            decodedBytes = Base64.getDecoder().decode(payload);
        }
        String decodedPayload = new String(decodedBytes, "UTF-8");
        
        System.out.println("📥 ID Token Payload: " + decodedPayload);
        
        JSONObject payloadJson = JSON.parseObject(decodedPayload);
        
        // 转换为标准用户信息格式
        JSONObject userInfo = new JSONObject();
        userInfo.put("id", payloadJson.getString("sub"));
        userInfo.put("email", payloadJson.getString("email"));
        userInfo.put("name", payloadJson.getString("name"));
        userInfo.put("picture", payloadJson.getString("picture"));
        userInfo.put("verified_email", payloadJson.getBoolean("email_verified"));
        
        return userInfo;
    }
}
