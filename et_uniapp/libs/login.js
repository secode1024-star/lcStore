// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import store from "../store";
import Cache from '../utils/cache';
import { Debounce } from '@/utils/validate.js'

import { LOGIN_STATUS, USER_INFO, EXPIRES_TIME, STATE_R_KEY, BACK_URL} from './../config/cache';

function prePage(){
	let pages = getCurrentPages();
	let prePage = pages[pages.length - 1];
	// #ifndef APP-PLUS
	return prePage.route;
	// #endif
}

export const toLogin = Debounce(_toLogin,800)

export function _toLogin(push, pathLogin) {
	store.commit("LOGOUT");
	let path = prePage();
	let login_back_url = Cache.get(BACK_URL);
	// #ifdef H5
	path = location.href;
	path = location.pathname + location.search;
	// #endif
	if(!pathLogin){
		pathLogin = '/page/users/login/index'
	}
	Cache.set(BACK_URL,path);	
	if (['/pages/user/index'].indexOf(login_back_url) == -1) {
		uni.navigateTo({
			url: '/pages/users/login/index'
		})
	}
}


export function checkLogin()
{
	let token = Cache.get(LOGIN_STATUS);
	let expiresTime = Cache.get(EXPIRES_TIME);
	let newTime = Math.round(new Date() / 1000);
	if (expiresTime < newTime || !token){
		Cache.clear(LOGIN_STATUS);
		Cache.clear(EXPIRES_TIME);
		Cache.clear(USER_INFO);
		Cache.clear(STATE_R_KEY);
		return false;
	}else{
		store.commit('UPDATE_LOGIN',token);
		let userInfo = Cache.get(USER_INFO,true);
		if(userInfo){
			store.commit('UPDATE_USERINFO',userInfo);
		}
		return true;
	}

}
