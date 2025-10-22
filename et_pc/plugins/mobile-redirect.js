/**
 * 移动设备检测和自动跳转插件
 * 当检测到移动设备访问PC端商品详情页时，自动跳转到移动端H5页面
 */

export default ({ app, route, redirect, req }) => {
  // 只在客户端执行
  if (process.client) {
    // 检测是否为移动设备
    const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    
    // 如果是商品详情页且是移动设备访问
    if (isMobile && route.path.includes('/goods_detail/')) {
      // 提取商品ID
      const productId = route.params.id || route.path.split('/').pop();
      
      // 获取当前域名
      const protocol = window.location.protocol;
      const hostname = window.location.hostname;
      const port = window.location.port ? `:${window.location.port}` : '';
      
      // 构造移动端URL（H5页面）
      // 假设移动端H5页面部署在 /h5/ 目录下
      const mobileUrl = `${protocol}//${hostname}${port}/h5/pages/goods_details/index?id=${productId}`;
      
      console.log('检测到移动设备访问商品详情页，准备跳转到移动端:', {
        productId,
        mobileUrl,
        userAgent: navigator.userAgent
      });
      
      // 跳转到移动端H5页面
      window.location.href = mobileUrl;
    }
  }
  
  // 服务端渲染时（SSR）
  if (process.server && req) {
    const userAgent = req.headers['user-agent'] || '';
    const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(userAgent);
    
    if (isMobile && route.path.includes('/goods_detail/')) {
      const productId = route.params.id || route.path.split('/').pop();
      
      // 获取请求的协议和主机
      const protocol = req.headers['x-forwarded-proto'] || 'http';
      const host = req.headers.host;
      
      // 构造移动端URL
      const mobileUrl = `${protocol}://${host}/h5/pages/goods_details/index?id=${productId}`;
      
      console.log('服务端检测到移动设备访问，准备跳转:', {
        productId,
        mobileUrl,
        userAgent
      });
      
      // 服务端重定向
      redirect(301, mobileUrl);
    }
  }
}

