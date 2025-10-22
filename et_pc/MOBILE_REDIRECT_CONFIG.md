# 移动端自动跳转配置说明

## 功能说明

当用户使用手机扫描商品海报二维码时，系统会自动检测设备类型，并将用户从PC端商品详情页跳转到适配手机的H5页面。

## 配置步骤

### 1. 确认H5页面部署路径

根据您的实际部署情况，H5页面可能有以下几种部署方式：

#### 方式1：H5与PC在同一域名下（推荐）
```
https://hqlccn.com/h5/#/pages/goods_details/index?id=23
```

#### 方式2：H5独立域名部署
```
https://m.hqlccn.com/pages/goods_details/index?id=23
```

#### 方式3：H5在子目录下
```
https://hqlccn.com/mobile/#/pages/goods_details/index?id=23
```

### 2. 修改跳转URL

打开文件：`et_pc/pages/goods_detail/_id/index.vue`

找到第622行的 `mobileUrl` 变量，根据您的实际情况修改：

```javascript
// 示例1：同域名部署（推荐）
const mobileUrl = `${protocol}//${hostname}${port}/h5/#/pages/goods_details/index?id=${productId}`;

// 示例2：独立域名部署
const mobileUrl = `${protocol}//m.${hostname}${port}/#/pages/goods_details/index?id=${productId}`;

// 示例3：完全自定义
const mobileUrl = `https://m.hqlccn.com/#/pages/goods_details/index?id=${productId}`;
```

### 3. 测试跳转功能

#### 方法1：使用浏览器开发者工具
1. 打开Chrome浏览器
2. 访问商品详情页：`https://hqlccn.com/goods_detail/23`
3. 按F12打开开发者工具
4. 点击设备切换按钮（或按Ctrl+Shift+M）
5. 选择移动设备模拟（如iPhone、Android）
6. 刷新页面，应该会看到跳转提示

#### 方法2：使用真实手机测试
1. 用手机浏览器访问：`https://hqlccn.com/goods_detail/23`
2. 应该会自动跳转到H5页面

#### 方法3：扫描商品海报二维码
1. 在平台管理后台生成商品海报
2. 用手机扫描二维码
3. 应该会跳转到H5页面

### 4. 调整跳转参数

如果需要调整跳转行为，可以修改以下参数：

```javascript
// 跳转延迟时间（毫秒）
setTimeout(() => {
  window.location.href = mobileUrl;
}, 1500);  // 改为 0 可以立即跳转，不显示提示

// 是否显示跳转提示
this.$message({
  message: '检测到移动设备，正在跳转到移动端页面...',
  type: 'info',
  duration: 1500
});
// 注释掉上面的代码可以不显示提示
```

### 5. 禁用自动跳转

如果需要临时禁用自动跳转功能，可以注释掉 `mounted()` 中的调用：

```javascript
mounted() {
  // 注释掉下面这行即可禁用自动跳转
  // this.checkMobileAndRedirect();
  
  if (this.$auth.loggedIn) {
    this.getCartCount();
  }
  // ...
},
```

## 支持的移动设备

系统会检测以下设备类型的User-Agent：
- Android
- iPhone
- iPad
- iPod
- Windows Phone
- BlackBerry
- Opera Mini

## 注意事项

1. **H5页面必须已部署**：确保H5页面已经正确部署并可以访问
2. **商品ID参数**：跳转时会自动传递商品ID参数（`?id=xxx`）
3. **域名配置**：确保跳转的目标域名已配置CORS（如果是跨域）
4. **HTTPS**：建议使用HTTPS协议，避免浏览器安全限制
5. **缓存问题**：修改配置后需要重新编译并清除浏览器缓存

## 常见问题

### Q1: 跳转后H5页面显示404
**A:** 检查H5页面路径是否正确，确认H5项目已正确部署。

### Q2: 跳转后商品ID丢失
**A:** 检查URL参数格式，确保使用 `?id=xxx` 而不是 `#id=xxx`。

### Q3: PC端也触发了跳转
**A:** 检查User-Agent检测逻辑，确保只在移动设备上触发。

### Q4: 跳转太快，看不到提示
**A:** 增加 `setTimeout` 的延迟时间，如改为 `2000`（2秒）。

### Q5: 想要在URL中添加更多参数
**A:** 修改 `mobileUrl` 变量，例如：
```javascript
const mobileUrl = `${protocol}//${hostname}${port}/h5/#/pages/goods_details/index?id=${productId}&from=qrcode&source=poster`;
```

## 配置示例

### 示例1：寰球联采实际配置
```javascript
// et_pc/pages/goods_detail/_id/index.vue (第622行)
const mobileUrl = `${protocol}//${hostname}${port}/h5/#/pages/goods_details/index?id=${productId}`;
```

这个配置假设：
- PC端部署在：`https://hqlccn.com/goods_detail/23`
- H5端部署在：`https://hqlccn.com/h5/#/pages/goods_details/index?id=23`

### 示例2：独立移动端域名
```javascript
// et_pc/pages/goods_detail/_id/index.vue (第622行)
const mobileUrl = `https://m.hqlccn.com/#/pages/goods_details/index?id=${productId}`;
```

这个配置假设：
- PC端部署在：`https://hqlccn.com/goods_detail/23`
- H5端部署在：`https://m.hqlccn.com/#/pages/goods_details/index?id=23`

## 重新编译

修改配置后，需要重新编译PC商城前端：

```bash
cd et_pc
npm run build
```

编译完成后，将 `dist` 目录下的文件部署到服务器。

