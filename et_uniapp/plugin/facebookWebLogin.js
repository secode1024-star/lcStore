/**
 * afu-facebookWebLogin
 * @description afu-facebookWebLogin是一个Facebook网页授权登录JS SDK
 * @tutorial https://ext.dcloud.net.cn/plugin?id=5685
 */

let isFacebookInit = false;

const afuFacebookWebLogin = {};

/* 初始化授权登录环境配置动态加载Facebook官方JavaScript SDK */
afuFacebookWebLogin.asyncLoadJs = function() {
	const me = this;
	// #ifdef H5
	return new Promise((resolve, reject) => {
		let isScript = false;
		document.scripts.forEach(item => {
			if (item['src'] && item['src'] ==
				'https://connect.facebook.net/en_US/sdk.js') {
				isScript = true;
			}
		})
		if (isScript) {
			resolve(true);
		} else {
			let script = document.createElement('script')
			script.type = 'text/javascript';
			script.src = 'https://connect.facebook.net/en_US/sdk.js';
			document.body.appendChild(script);
			script.onload = () => {
				resolve(true);
			}
			script.onerror = () => {
				resolve(false);
			}
		}
	})
	// #endif
}

/* 初始化Facebook授权登录相关配置信息 */
afuFacebookWebLogin.init = async function(appId, complete = () => {}) {
	const me = this;
	// #ifdef H5
	let isAsyncLoadJs = await me.asyncLoadJs();
	if (isAsyncLoadJs) {
		if (window['FB']) {
			window['FB'].init({
				appId: appId,
				cookie: true,
				xfbml: true,
				version: 'v6.0'
			});
			window['FB'].AppEvents.logPageView();
			isFacebookInit = true;
			complete(true);
		}
	} else {
		isFacebookInit = false;
		complete(false);
	}
	// #endif
}

/* 检查用户登录状态 */
afuFacebookWebLogin.getLoginStatus = function(complete = () => {}) {
	const me = this;
	// #ifdef H5
	if (isFacebookInit) {
		window['FB'].getLoginStatus((response) => {
			complete(response)
		});
	}
	// #endif
}

/* 通过 Javascript SDK 登录对话框登录 */
afuFacebookWebLogin.login = function(complete = () => {}, Permissions = {}) {
	const me = this;
	// #ifdef H5
	if (isFacebookInit) {
		window['FB'].login((response) => {
			complete(response)
		}, Permissions);
	}
	// #endif
}

/* 通过 Javascript SDK 退出登录 */
afuFacebookWebLogin.logout = function(complete = () => {}) {
	const me = this;
	// #ifdef H5
	if (isFacebookInit) {
		me.getLoginStatus(response => {
			if (response['status'] == 'connected') {
				window['FB'].logout((res) => {
					complete(res)
				});
			}
		})
	}
	// #endif
}

/* 通过 图谱 API 彻底取消授权应用或撤销登录 */
afuFacebookWebLogin.revocationAuthorization = function(complete = () => {}) {
	const me = this;
	// #ifdef H5
	if (isFacebookInit) {
		me.getLoginStatus(response => {
			if (response['status'] == 'connected') {
				me.api("id", (res) => {
					window['FB'].api(`/${res['id']}/permissions`, 'DELETE', (req) => {
						complete(req)
					});
				})
			}
		})
	}
	// #endif
}

/* 通过 图谱 API 查询用户信息 */
afuFacebookWebLogin.api = function(fields = "id,name", complete = () => {}) {
	const me = this;
	// #ifdef H5
	if (isFacebookInit) {
		me.getLoginStatus(response => {
			if (response['status'] == 'connected') {
				window['FB'].api('/me', 'GET', {
					"fields": fields
				}, (res) => {
					complete(res)
				});
			}
		})
	}
	// #endif
}

export default afuFacebookWebLogin;
