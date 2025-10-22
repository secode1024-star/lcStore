/**
 * 移动端H5配置
 * 用于配置PC端到移动端的跳转规则
 */

export default {
  // H5页面部署路径（根据实际部署情况修改）
  h5BasePath: '/h5',
  
  // 是否启用移动端自动跳转
  enableAutoRedirect: true,
  
  // 跳转延迟时间（毫秒）
  redirectDelay: 1500,
  
  // 是否显示跳转提示
  showRedirectMessage: true,
  
  // 移动设备检测正则表达式
  mobileRegex: /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i,
  
  // 页面映射规则
  pageMapping: {
    // PC端商品详情页 -> H5商品详情页
    goods_detail: {
      pcPath: '/goods_detail/:id',
      h5Path: '/pages/goods_details/index',
      queryParam: 'id'
    }
  },
  
  /**
   * 获取H5页面完整URL
   * @param {string} pageName 页面名称
   * @param {string} productId 商品ID
   * @returns {string} H5页面URL
   */
  getH5Url(pageName, productId) {
    const mapping = this.pageMapping[pageName];
    if (!mapping) {
      console.warn(`未找到页面映射: ${pageName}`);
      return null;
    }
    
    const protocol = window.location.protocol;
    const hostname = window.location.hostname;
    const port = window.location.port ? `:${window.location.port}` : '';
    
    return `${protocol}//${hostname}${port}${this.h5BasePath}${mapping.h5Path}?${mapping.queryParam}=${productId}`;
  },
  
  /**
   * 检测是否为移动设备
   * @returns {boolean} 是否为移动设备
   */
  isMobileDevice() {
    return this.mobileRegex.test(navigator.userAgent);
  }
}

