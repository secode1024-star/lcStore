package com.zbkj.front.filter;

import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 静态资源CORS过滤器
 * 专门为图片等静态资源添加CORS响应头，解决Canvas跨域问题
 * 
 * 🔥 已禁用：@Component注解被移除，改用CorsConfig统一处理CORS，避免响应头重复
 * 
 * @author CRMEB Team
 */
// @Component
public class StaticResourceCorsFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        
        // 只对图片资源添加CORS头
        if (requestURI.startsWith("/crmebimage/") || 
            requestURI.contains("/public/") || 
            requestURI.endsWith(".jpg") || 
            requestURI.endsWith(".jpeg") || 
            requestURI.endsWith(".png") || 
            requestURI.endsWith(".gif") || 
            requestURI.endsWith(".webp")) {
            
            // 获取请求来源
            String origin = httpRequest.getHeader("Origin");
            
            // 允许的域名列表
            if (isAllowedOrigin(origin)) {
                httpResponse.setHeader("Access-Control-Allow-Origin", origin);
            } else {
                // 如果没有Origin头或不在允许列表中，设置为通配符（仅对图片资源）
                httpResponse.setHeader("Access-Control-Allow-Origin", "*");
            }
            
            httpResponse.setHeader("Access-Control-Allow-Methods", "GET, HEAD, OPTIONS");
            httpResponse.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization");
            httpResponse.setHeader("Access-Control-Allow-Credentials", "false"); // 图片资源不需要凭证
            httpResponse.setHeader("Access-Control-Max-Age", "3600");
            
            // 添加缓存控制
            httpResponse.setHeader("Cache-Control", "public, max-age=86400"); // 缓存1天
            
            // 处理预检请求
            if ("OPTIONS".equalsIgnoreCase(httpRequest.getMethod())) {
                httpResponse.setStatus(HttpServletResponse.SC_OK);
                return;
            }
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 清理资源
    }
    
    /**
     * 检查是否为允许的来源域名
     */
    private boolean isAllowedOrigin(String origin) {
        if (origin == null) {
            return false;
        }
        
        return origin.equals("https://pla.hqlccn.com") ||
               origin.equals("https://mer.hqlccn.com") ||
               origin.equals("https://api1.hqlccn.com") ||
               origin.equals("https://hqlccn.com") ||
               origin.equals("http://hqlccn.com") ||
               origin.equals("http://localhost:9527") ||
               origin.equals("http://localhost:9528") ||
               origin.equals("http://localhost:20008") ||
               origin.equals("http://localhost:3000") ||
               origin.equals("http://localhost:8000");
    }
}









