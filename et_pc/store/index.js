// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------
import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export const state = () => ({
  login: false,
  locale: "",
  cartNumber: 0,
  locales: ["en", "zh-CN", "es"],
  merchantType: [] /** 商户类型 **/,
  productClassify: [],
  merchantClassify: [] /** 商户分类 **/,
  isShowTourists: false,
  evaluationInfo:
    typeof localstorage !== undefined &&
    JSON.parse(localStorage.getItem("evaluationInfo"))
      ? JSON.parse(localStorage.getItem("evaluationInfo"))
      : {},
  merPcBanner:
    typeof localstorage !== undefined && localStorage.getItem("merPcBanner")
      ? JSON.parse(localStorage.getItem("merPcBanner"))
      : [] /** 商户主页banner轮播图  **/,
});

export const mutations = {
  isLogin(state, data) {
    state.login = data;
  },
  isTourists(state, data) {
    state.isShowTourists = data;
  },
  SET_LANG(state, locale) {
    state.locale = locale;
  },
  cartNum(state, data) {
    state.cartNumber = Number(data);
  },
  /** 店铺全部类型 **/
  SET_MerchantType: (state, merchantType) => {
    state.merchantType = merchantType;
  },
  /** 商品分类 **/
  SET_ProductClassify: (state, productClassify) => {
    state.productClassify = productClassify;
  },
  /** 商户全部分类  **/
  SET_MerchantClassify: (state, merchantClassify) => {
    state.merchantClassify = changeNodes(merchantClassify);
  },
  /** 评价列表中的商品信息  **/
  SET_EvaluationInfo: (state, evaluationInfo) => {
    state.evaluationInfo = evaluationInfo;
    localStorage.setItem("evaluationInfo", JSON.stringify(evaluationInfo));
  },
  /** 商户主页banner轮播图  **/
  SET_MerPcBanner: (state, merPcBanner) => {
    state.merPcBanner = merPcBanner;
    localStorage.setItem("merPcBanner", merPcBanner);
  },
};

/** tree去除 childList=[] 的结构**/
const changeNodes = function (data) {
  if (data.length > 0) {
    for (var i = 0; i < data.length; i++) {
      if (!data[i].childList || data[i].childList.length < 1) {
        data[i].childList = undefined;
      } else {
        changeNodes(data[i].childList);
      }
    }
  }
  return data;
};

export const actions = {
  nuxtServerInit({ commit }, { app }) {
    commit(
      "SET_LANG",
      app.$cookies.get("locale") ? app.$cookies.get("locale") : "en"
    );
  },
  /** 店铺类型 **/
  MerTypeList({ state, commit }) {
    return new Promise((reslove) => {
      this.$axios.get(`/api/front/merchant/all/type/list`).then((res) => {
        commit("SET_MerchantType", res.data);
        reslove(res.data);
      });
    }).catch((err) => {
      reject(error);
    });
  },
  /** 商户分类 **/
  MerCategoryList({ state, commit }) {
    return new Promise((reslove) => {
      this.$axios.get(`/api/front/merchant/all/category/list`).then((res) => {
        commit("SET_MerchantClassify", res.data);
        reslove(res.data);
      });
    }).catch((err) => {
      reject(error);
    });
  },
  /** 商品分类 **/
  getProductClassify({ state, commit }) {
    return new Promise((reslove) => {
      this.$axios.get(`/api/front/product/category`).then((res) => {
        commit("SET_ProductClassify", changeNodes(res.data));
        reslove(res.data);
      });
    }).catch((err) => {
      reject(error);
    });
  },
};

export const getters = {};
