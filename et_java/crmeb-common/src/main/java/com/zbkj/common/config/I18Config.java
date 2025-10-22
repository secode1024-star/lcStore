package com.zbkj.common.config;

import cn.hutool.core.util.StrUtil;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.web.servlet.LocaleResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Locale;

/**
 * 国际化配置
 *
 * @author 张泽鹏
 */

@Configuration
public class I18Config {

    @Bean
    public LocaleResolver localeResolver() {
        return new I18nLocaleResolver();
    }

    static class I18nLocaleResolver implements LocaleResolver {

        /**
         * 本地解析 , 根据经请求头进行判断国家和语言控制
         */
        @Override
        public Locale resolveLocale(HttpServletRequest httpServletRequest) {
            String language = httpServletRequest.getHeader("content-language");
            Locale locale = Locale.getDefault();   //默认“zh_CN”
            //Locale locale = Locale.US; //默认“en_US”
            if (StrUtil.isNotBlank(language)) {
                String[] split = language.split("_");
                locale = new Locale(split[0], split[1]);
            }
            return locale;
        }

        @Override
        public void setLocale(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Locale locale) {

        }
    }
}
