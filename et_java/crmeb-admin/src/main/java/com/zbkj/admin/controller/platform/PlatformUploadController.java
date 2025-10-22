package com.zbkj.admin.controller.platform;

import com.zbkj.common.response.CommonResult;
import com.zbkj.common.vo.FileResultVo;
import com.zbkj.service.service.SystemRoleService;
import com.zbkj.service.service.UploadService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;
import java.net.URL;
import java.net.URLConnection;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;


/**
 * 上传文件 前端控制器
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
@Slf4j
@RestController
@RequestMapping("api/admin/platform/upload")
@Api(tags = "平台端上传文件")
public class PlatformUploadController {

    @Autowired
    private UploadService uploadService;

    @Autowired
    private SystemRoleService systemRoleService;

    /**
     * 图片上传
     */
    @PreAuthorize("hasAuthority('platform:upload:image')")
    @ApiOperation(value = "图片上传")
    @RequestMapping(value = "/image", method = RequestMethod.POST)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "model", value = "模块 用户user,商品product,微信wechat,news文章"),
            @ApiImplicitParam(name = "pid", value = "分类ID 0编辑器,1商品图片,2拼团图片,3砍价图片,4秒杀图片,5文章图片,6组合数据图,7前台用户,8微信系列 ", allowableValues = "range[0,1,2,3,4,5,6,7,8]")
    })
    public CommonResult<FileResultVo> image(MultipartFile multipart,
                                            @RequestParam(value = "model") String model,
                                            @RequestParam(value = "pid") Integer pid) throws IOException {
        Integer ownerId = systemRoleService.getOwnerByCurrentAdmin();
        return CommonResult.success(uploadService.imageUpload(multipart, model, pid, ownerId));
    }

    /**
     * 文件上传
     */
    @PreAuthorize("hasAuthority('platform:upload:file')")
    @ApiOperation(value = "文件上传")
    @RequestMapping(value = "/file", method = RequestMethod.POST)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "model", value = "模块 用户user,商品product,微信wechat,news文章"),
            @ApiImplicitParam(name = "pid", value = "分类ID 0编辑器,1商品图片,2拼团图片,3砍价图片,4秒杀图片,5文章图片,6组合数据图,7前台用户,8微信系列 ", allowableValues = "range[0,1,2,3,4,5,6,7,8]")
    })
    public CommonResult<FileResultVo> file(MultipartFile multipart,
                                           @RequestParam(value = "model") String model,
                                           @RequestParam(value = "pid") Integer pid) throws IOException {
        Integer ownerId = systemRoleService.getOwnerByCurrentAdmin();
        return CommonResult.success(uploadService.fileUpload(multipart, model, pid, ownerId));
    }

    /**
     * 图片代理 - 解决Canvas跨域问题
     */
    @PreAuthorize("hasAuthority('platform:upload:image')")
    @ApiOperation(value = "图片代理")
    @GetMapping("/proxy-image")
    public ResponseEntity<byte[]> proxyImage(@RequestParam("url") String imageUrl) {
        try {
            log.info("代理图片请求: {}", imageUrl);
            
            // 创建URL连接
            URL url = new URL(imageUrl);
            URLConnection connection = url.openConnection();
            
            // 设置请求头，模拟浏览器
            connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
            connection.setRequestProperty("Accept", "image/webp,image/apng,image/*,*/*;q=0.8");
            connection.setRequestProperty("Accept-Language", "zh-CN,zh;q=0.9,en;q=0.8");
            
            // 设置超时
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(10000);
            
            // 读取图片数据（Java 8兼容）
            try (InputStream inputStream = connection.getInputStream();
                 ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {
                
                byte[] data = new byte[4096];
                int bytesRead;
                while ((bytesRead = inputStream.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, bytesRead);
                }
                buffer.flush();
                byte[] imageBytes = buffer.toByteArray();
                
                // 获取Content-Type
                String contentType = connection.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    contentType = "image/jpeg"; // 默认JPEG
                }
                
                log.info("成功代理图片: {} bytes, Content-Type: {}", imageBytes.length, contentType);
                
                // 设置响应头，允许跨域
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.parseMediaType(contentType));
                headers.set("Access-Control-Allow-Origin", "*");
                headers.set("Access-Control-Allow-Methods", "GET");
                headers.set("Access-Control-Allow-Headers", "*");
                headers.setCacheControl("max-age=3600"); // 缓存1小时
                
                return ResponseEntity.ok()
                        .headers(headers)
                        .body(imageBytes);
            }
            
        } catch (Exception e) {
            log.error("图片代理失败: {}", imageUrl, e);
            
            // 返回默认占位图片或错误信息
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            String errorResponse = "{\"error\": \"图片加载失败\"}";
            return ResponseEntity.badRequest()
                    .headers(headers)
                    .body(errorResponse.getBytes());
        }
    }

}



