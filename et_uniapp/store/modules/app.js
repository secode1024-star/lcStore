// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import {getUserInfo} from "../../api/user.js";
import {LOGIN_STATUS,UID,PLATFORM} from '../../config/cache';
import Cache from '../../utils/cache';
import {USER_INFO} from '../../config/cache';
import { getMerTypeListApi, getMerCategoryListApi} from '@/api/merchant.js';
const state = {
	token: Cache.get(LOGIN_STATUS) || '',
	backgroundColor: "#fff",
	userInfo: Cache.get(USER_INFO)?JSON.parse(Cache.get(USER_INFO)):null,
	uid: Cache.get(UID) || null,
	homeActive: false,
	chatUrl: Cache.get('chatUrl') || '',
	systemPlatform: Cache.get(PLATFORM)?Cache.get(PLATFORM):'',
	productType: Cache.get('productType') || '',
	merchantClassify: Cache.get('merchantClassify')?JSON.parse(Cache.get('merchantClassify')) : [] ,  /** 商户分类 **/
	merchantType: Cache.get('merchantType')?JSON.parse(Cache.get('merchantType')) : [], /** 商户类型 **/
	merchantAPPInfo: Cache.get('merchantAPPInfo') ? JSON.parse(Cache.get('merchantAPPInfo')) : {},
	bottomNavigationIsCustom: false, //是否使用自定义导航
	discoverTopic: [],
};
const mutations = {
	LOGIN(state, opt) {
		state.token = opt.token;
		Cache.set(LOGIN_STATUS, opt.token);
	},
	SETUID(state,val){                                                
		state.uid = val;
		Cache.set(UID, val);
	},
	UPDATE_LOGIN(state, token) {
		state.token = token;
	},
	LOGOUT(state) {
		state.token = undefined;
		state.uid = undefined
		Cache.clear(LOGIN_STATUS);
		Cache.clear(UID);
		Cache.clear(USER_INFO);
	},
	BACKGROUND_COLOR(state, color) {
		state.color = color;
		document.body.style.backgroundColor = color;
	},
	UPDATE_USERINFO(state, userInfo) {
		state.userInfo = userInfo;
		Cache.set(USER_INFO, userInfo);
	},
	OPEN_HOME(state) {
		state.homeActive = true;
	},
	CLOSE_HOME(state) {
		state.homeActive = false;
	},
	SET_CHATURL(state, chatUrl){
		state.chatUrl = chatUrl;
	},
	// AuthorizeType(state, authorizeType){
	// 	state.authorizeType = authorizeType;
	// },
	SYSTEM_PLATFORM(state, systemPlatform){
		state.systemPlatform = systemPlatform;
		Cache.set(PLATFORM, systemPlatform);
	},
	//更新useInfo数据
	changInfo(state, payload) {
		state.userInfo[payload.amount1] = payload.amount2;
		Cache.set(USER_INFO, state.userInfo);
	},
	//商品类型，用于区分视频号商品与一般商品
	PRODUCT_TYPE(state, productType) {
		state.productType = productType;
		Cache.set('productType', productType);
	},
	/** 商户全部分类  **/
	SET_MerchantClassify: (state, merchantClassify) => {
	    state.merchantClassify = changeNodes(merchantClassify)
		Cache.set('merchantClassify', JSON.stringify(changeNodes(merchantClassify)));
	},
	 /** 商户全部类型 **/
	SET_MerchantType: (state, merchantType) => {
	    state.merchantType = changeNodes(merchantType)
		Cache.set('merchantType', JSON.stringify(changeNodes(merchantType)));
	},
	 /** 商户信息 **/
	MERCHANTJINFO: (state, merchantJInfo) => {
	    state.merchantAPPInfo = merchantJInfo
		Cache.set('merchantAPPInfo', merchantJInfo);
	},
	/** 是否使用自定义导航 **/
	BottomNavigationIsCustom: (state, bottomNavigationIsCustom) => {
		state.bottomNavigationIsCustom = bottomNavigationIsCustom
	},
	/** 选中的话题列表 **/
	DiscoverTopic: (state, discoverTopic) => {
		state.discoverTopic = discoverTopic
		//Cache.set('merTokenIsExist', merTokenIsExist);
	},
};

/** tree去除 childList=[] 的结构**/
const changeNodes = function(data) {
  if (data.length > 0) {
    for (var i = 0; i < data.length; i++) {
      if (!data[i].childList || data[i].childList.length < 1) {
        data[i].childList = undefined;
      } else {
        changeNodes(data[i].childList);
      }
    }
  }
  return data
};

const actions = {
	USERINFO({state,commit}, force) {
		return new Promise(reslove => {
			getUserInfo().then(res => {
				commit("UPDATE_USERINFO", res.data);
				reslove(res.data);
			});
		}).catch(err => {
			return that.$util.Tips({
				title: err
			});
		});
	},
	MerCategoryList({state,commit}, force) {
		return new Promise(reslove => {
			getMerCategoryListApi().then(res => {
				commit('SET_MerchantClassify', res.data)
				reslove(res.data);
			});
		}).catch(err => {
			return that.$util.Tips({
				title: err
			});
		});
	},
	MerTypeList({state,commit}, force) {
		return new Promise(reslove => {
			getMerTypeListApi().then(res => {
				commit('SET_MerchantType', res.data)
				reslove(res.data);
			});
		}).catch(err => {
			return that.$util.Tips({
				title: err
			});
		});
	}
};

export default {
	state,
	mutations,
	actions,
	changeNodes
};
