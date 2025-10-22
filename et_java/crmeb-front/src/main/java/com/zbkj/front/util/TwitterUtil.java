package com.zbkj.front.util;

import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson.JSON;
import com.zbkj.common.constants.Constants;
import com.zbkj.common.constants.SysConfigConstants;
import com.zbkj.common.exception.CrmebException;
import com.zbkj.common.utils.MessageUtils;
import com.zbkj.service.service.SystemConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;
import twitter4j.conf.Configuration;
import twitter4j.conf.ConfigurationBuilder;

/**
 * @Author 指缝de阳光
 * @Date 2022/1/13 15:26
 * @Version v1.2
 */
@Component
public class TwitterUtil {

    @Autowired
    private SystemConfigService systemConfigService;

    /**
     * 获取requestToken
     *
     * @return RequestToken
     */
    public RequestToken getRequestToken(String end) {
        String twitterOpen = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_TWITTER_OPEN);
        System.out.println("TwitterUtil - 获取RequestToken，开关配置值: '" + twitterOpen + "'");
        // 兼容处理，支持带引号和不带引号的配置值
        if (twitterOpen.equals(Constants.COMMON_SWITCH_CLOSE_TYPE_ONE) || "0".equals(twitterOpen) || StrUtil.isBlank(twitterOpen)) {
            System.out.println("Twitter功能未开启，配置值: " + twitterOpen);
            throw new CrmebException(MessageUtils.message("front.twitter.error.a"));
        }
        String consumerKey = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_TWITTER_CONSUMER_KEY);
        String consumerSecret = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_TWITTER_CONSUMER_SECRET);
        System.out.println("Twitter Consumer Key: '" + (StrUtil.isNotBlank(consumerKey) ? "已配置" : "未配置") + "'");
        System.out.println("Twitter Consumer Secret: '" + (StrUtil.isNotBlank(consumerSecret) ? "已配置" : "未配置") + "'");
        if (StrUtil.isBlank(consumerKey) || StrUtil.isBlank(consumerSecret)) {
            System.out.println("Twitter API Key或Secret未配置");
            throw new CrmebException(MessageUtils.message("front.twitter.error.b"));
        }

        ConfigurationBuilder builder = new ConfigurationBuilder();
        builder.setOAuthConsumerKey(consumerKey);
        builder.setOAuthConsumerSecret(consumerSecret);
        Configuration configuration = builder.build();
        TwitterFactory twitterFactory = new TwitterFactory(configuration);
        Twitter twitter = twitterFactory.getInstance();
        RequestToken requestToken = null;
        try {
            // H5端Twitter登录已注释 - 暂时不支持H5端
            // String h5CallBackUrl = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_TWITTER_CALLBACK_URL_H5);
            String pcCallbackUrl = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_TWITTER_CALLBACK_URL_PC);
            System.out.println("PC回调地址配置: '" + pcCallbackUrl + "'");
            System.out.println("请求端类型: '" + end + "'");
            String resultCallBack = null;
            // 根据参数获取对应回调 - H5端已注释
            // if ("h5".equals(end) && ObjectUtil.isNotNull(h5CallBackUrl)) {
            //     resultCallBack = h5CallBackUrl;
            // }
            if ("pc".equals(end) && ObjectUtil.isNotNull(pcCallbackUrl)) {
                resultCallBack = pcCallbackUrl;
            }
            System.out.println("最终使用的回调地址: '" + resultCallBack + "'");
            if (ObjectUtil.isNull(resultCallBack)) {
                System.out.println("回调地址为空，抛出异常");
                throw new CrmebException("Twitter回调地址未配置");
            }
            requestToken = twitter.getOAuthRequestToken(resultCallBack);
            System.out.println("requestToken" + JSON.toJSONString(requestToken));
        } catch (TwitterException e) {
            System.out.println("Get requestToken exception");
            e.printStackTrace();
            throw new CrmebException(MessageUtils.message("front.twitter.error.d", e.getErrorMessage()));
        }
        return requestToken;
    }

    /**
     * 官方SDK疑似获取不到userId
     *
     * @param requestToken  requestToken
     * @param oauthVerifier oauthVerifier
     * @return RequestToken
     */
    public AccessToken getOAuth1AccessToken(RequestToken requestToken, String oauthVerifier) {
        String twitterOpen = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_TWITTER_OPEN);
        // 兼容处理，支持带引号和不带引号的配置值
        if (twitterOpen.equals(Constants.COMMON_SWITCH_CLOSE_TYPE_ONE) || "0".equals(twitterOpen) || StrUtil.isBlank(twitterOpen)) {
            throw new CrmebException(MessageUtils.message("front.twitter.error.a"));
        }
        String consumerKey = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_TWITTER_CONSUMER_KEY);
        String consumerSecret = systemConfigService.getValueByKey(SysConfigConstants.CONFIG_KEY_TWITTER_CONSUMER_SECRET);
        if (StrUtil.isBlank(consumerKey) || StrUtil.isBlank(consumerSecret)) {
            throw new CrmebException(MessageUtils.message("front.twitter.error.b"));
        }

        ConfigurationBuilder builder = new ConfigurationBuilder();
        builder.setOAuthConsumerKey(consumerKey);
        builder.setOAuthConsumerSecret(consumerSecret);
        Configuration configuration = builder.build();
        TwitterFactory twitterFactory = new TwitterFactory(configuration);
        Twitter twitter = twitterFactory.getInstance();
        AccessToken accessToken = null;
        try {
            accessToken = twitter.getOAuthAccessToken(requestToken, oauthVerifier);
        } catch (TwitterException e) {
            e.printStackTrace();
            System.out.println("Get accessToken exception");
        }
        return accessToken;
    }

}
