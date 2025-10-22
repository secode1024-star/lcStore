package com.zbkj.front.config;

import com.zbkj.common.config.CrmebConfig;
import com.zbkj.common.constants.Constants;
import com.zbkj.common.interceptor.SwaggerInterceptor;
import com.zbkj.front.filter.ResponseFilter;
import com.zbkj.front.interceptor.FrontTokenInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.ContentNegotiationConfigurer;
import org.springframework.http.MediaType;
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
    public HandlerInterceptor frontTokenInterceptor(){
        return new FrontTokenInterceptor();
    }

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
        //添加token拦截器
        //addPathPatterns添加需要拦截的命名空间；
        //excludePathPatterns添加排除拦截命名空间

        //前端用户登录token
        registry.addInterceptor(frontTokenInterceptor()).
                addPathPatterns("/api/front/**").
                addPathPatterns("/api/pc/**").
                excludePathPatterns("/api/front/activity/list/*").
                excludePathPatterns("/api/front/activity/index/list").
                excludePathPatterns("/api/front/captcha/**").
                excludePathPatterns("/api/front/coupons").
                excludePathPatterns("/api/front/index/**").
                excludePathPatterns("/api/front/search/keyword").
                excludePathPatterns("/api/front/image/domain").
                excludePathPatterns("/api/front/login/**").
                excludePathPatterns("/api/front/merchant/search/list").
                excludePathPatterns("/api/front/merchant/street").
                excludePathPatterns("/api/front/merchant/index/info/*").
                excludePathPatterns("/api/front/merchant/detail/*").
                excludePathPatterns("/api/front/merchant/all/type/list").
                excludePathPatterns("/api/front/merchant/all/category/list").
                excludePathPatterns("/api/front/merchant/settled/agreement").
                excludePathPatterns("/api/front/merchant/customer/service/info/*").
                excludePathPatterns("/api/front/pay/paypal/cancel").
                excludePathPatterns("/api/front/product/**").
                excludePathPatterns("/api/front/order/visitor/master/detail").
                excludePathPatterns("/api/front/order/visitor/detail").
                excludePathPatterns("/api/front/upload/**").
                excludePathPatterns("/api/front/pay/method").
                excludePathPatterns("/api/front/login/token/is/exist").

                excludePathPatterns("/api/front/community/category/list").
                excludePathPatterns("/api/front/community/user/home/page/*").
                excludePathPatterns("/api/front/community/topic/count/*").
                excludePathPatterns("/api/front/community/topic/recommend/list").
                excludePathPatterns("/api/front/community/topic/list").
                excludePathPatterns("/api/front/community/note/discover/list").
                excludePathPatterns("/api/front/community/note/author/list/*").
                excludePathPatterns("/api/front/community/note/user/detail/*").
                excludePathPatterns("/api/front/community/note/reply/list/*").
                excludePathPatterns("/api/front/community/note/topic/list").
                excludePathPatterns("/api/front/community/note/discover/list/recommend/*").

                excludePathPatterns("/api/pc/home/index").
                excludePathPatterns("/api/pc/activity/detail/*").
                excludePathPatterns("/api/pc/login/getLoginPic").
                excludePathPatterns("/swagger-resources/**", "/webjars/**", "/v2/**", "/swagger-ui.html/**");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
        registry.addResourceHandler("doc.html")
                .addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");

        /** 本地文件上传路径 */
        registry.addResourceHandler(Constants.UPLOAD_TYPE_IMAGE + "/**")
                .addResourceLocations("file:" + crmebConfig.getImagePath() + Constants.UPLOAD_TYPE_IMAGE + "/");

        registry.addResourceHandler(Constants.UPLOAD_TYPE_FILE + "/**")
                .addResourceLocations("file:" +crmebConfig.getImagePath() + Constants.UPLOAD_TYPE_FILE + "/" );
    }

    @Override
    public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
        configurer
                .favorPathExtension(true)
                .favorParameter(false)
                .ignoreAcceptHeader(false)
                .useRegisteredExtensionsOnly(false)
                .defaultContentType(MediaType.APPLICATION_JSON)
                .mediaType("json", MediaType.APPLICATION_JSON)
                .mediaType("xml", MediaType.APPLICATION_XML)
                .mediaType("png", MediaType.IMAGE_PNG)
                .mediaType("jpg", MediaType.IMAGE_JPEG)
                .mediaType("jpeg", MediaType.IMAGE_JPEG)
                .mediaType("gif", MediaType.IMAGE_GIF)
                .mediaType("webp", MediaType.valueOf("image/webp"))
                .mediaType("bmp", MediaType.valueOf("image/bmp"));
    }

    @Bean
    public FilterRegistrationBean filterRegister()
    {
        //注册过滤器
        FilterRegistrationBean registration = new FilterRegistrationBean(responseFilter());
        registration.addUrlPatterns("/*");
        return registration;
    }

    // 🔥 已禁用静态资源CORS过滤器，改用CorsConfig统一处理，避免响应头重复
    // @Bean
    // public FilterRegistrationBean staticResourceCorsFilterRegister()
    // {
    //     //注册静态资源CORS过滤器
    //     FilterRegistrationBean registration = new FilterRegistrationBean(new com.zbkj.front.filter.StaticResourceCorsFilter());
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
