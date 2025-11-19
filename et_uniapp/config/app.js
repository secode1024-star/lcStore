// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------
//移动端商城API,请求域名 格式： https://您的域名
// H5开发环境使用代理路径，其他环境使用服务器API地址
// 判断是否为H5平台且为开发环境
// #ifdef H5
let domain = process.env.NODE_ENV === 'development' ? '' : 'https://api.hqlccn.com'
// #endif
// #ifndef H5
// let domain = 'https://api.hqlccn.com'
// #endif


module.exports = {
	
	HTTP_REQUEST_URL: domain,
	
	HEADER:{
		'content-type': 'application/json'
	},
	HEADERPARAMS:{
		'content-type': 'application/x-www-form-urlencoded'
	},
	// 会话密钥名称 请勿修改此配置
	TOKENNAME: 'Authori-zation',
	// 缓存时间 0 永久
	EXPIRE:0,
	//分页最多显示条数
	LIMIT: 10
};
