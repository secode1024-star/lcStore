// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

// 请求接口地址 - 商户管理后台
const VUE_APP_API_URL = "https://api1.hqlccn.com"; // 商户管理域名，通过Nginx反向代理到20008端口
const VUE_APP_WS_URL = "wss://api1.hqlccn.com";
const SettingMer = {
  // 服务器地址
  httpUrl: VUE_APP_API_URL,
  // 接口请求地址
  apiBaseURL: VUE_APP_API_URL + '/api/',
  // socket连接
  wsSocketUrl: VUE_APP_WS_URL,
};

export default SettingMer;
