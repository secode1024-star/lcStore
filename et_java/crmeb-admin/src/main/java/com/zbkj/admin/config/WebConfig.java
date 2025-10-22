package com.zbkj.admin.config;

import com.zbkj.admin.filter.ResponseFilter;
import com.zbkj.common.config.CrmebConfig;
import com.zbkj.common.constants.Constants;
import com.zbkj.common.interceptor.SwaggerInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.handler.MappedInterceptor;

/**
 * token验证拦截器
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
@Configuration
public class WebConfig implements WebMvcConfigurer {

    // 这里使用一个Bean为的是可以在拦截器中自由注入，也可以在拦截器中使用SpringUtil.getBean 获取
    // 但是觉得这样更优雅

    @Autowired
    CrmebConfig crmebConfig;

    @Bean
    public ResponseFilter responseFilter(){ return new ResponseFilter(); }

    @Value("${swagger.basic.username}")
    private String username;
    @Value("${swagger.basic.password}")
    private String password;
    @Value("${swagger.basic.check}")
    private Boolean check;


    @Override
    public void addInterceptors(InterceptorRegistry registry) {

    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
        registry.addResourceHandler("doc.html")
                .addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");

        /** 本地文件上传路径 - 支持Canvas图片跨域访问 */
        registry.addResourceHandler(Constants.UPLOAD_TYPE_IMAGE + "/**")
                .addResourceLocations("file:" + crmebConfig.getImagePath() + Constants.UPLOAD_TYPE_IMAGE + "/")
                .setCacheControl(org.springframework.http.CacheControl.maxAge(java.time.Duration.ofDays(365)))
                .resourceChain(true);

        registry.addResourceHandler(Constants.UPLOAD_TYPE_FILE + "/**")
                .addResourceLocations("file:" +crmebConfig.getImagePath() + Constants.UPLOAD_TYPE_FILE + "/" );
    }

    @Bean
    public FilterRegistrationBean filterRegister()
    {
        //注册过滤器
        FilterRegistrationBean registration = new FilterRegistrationBean(responseFilter());
        // 仅仅api前缀的请求才会拦截
        registration.addUrlPatterns("/api/*");
        return registration;
    }

    // 🔥 已禁用静态资源CORS过滤器，改用CorsConfig统一处理，避免响应头重复
    // @Bean
    // public FilterRegistrationBean staticResourceCorsFilterRegister()
    // {
    //     //注册静态资源CORS过滤器
    //     FilterRegistrationBean registration = new FilterRegistrationBean(new com.zbkj.admin.filter.StaticResourceCorsFilter());
    //     // 对静态资源路径进行拦截
    //     registration.addUrlPatterns("/crmebimage/*");
    //     registration.setOrder(1); // 设置较高优先级
    //     return registration;
    // }

    /* 必须在此处配置拦截器,要不然拦不到swagger的静态资源 */
    @Bean
    @ConditionalOnProperty(name = "swagger.basic.enable", havingValue = "true")
    public MappedInterceptor getMappedInterceptor() {
        return new MappedInterceptor(new String[]{"/doc.html", "/webjars/**"}, new SwaggerInterceptor(username, password, check));
    }
}
