// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------
import * as store from '@/api/store';

const state = {
  adminProductClassify: JSON.parse(localStorage.getItem('adminProductClassify')) || [] /** 平台商品分类 **/,
  productBrand: JSON.parse(localStorage.getItem('productBrand')) || [] /** 商品品牌 **/,
};

const mutations = {
  SET_AdminProductClassify: (state, adminProductClassify) => {
    state.adminProductClassify = adminProductClassify;
    if (!adminProductClassify.length) localStorage.removeItem('adminProductClassify');
  },
  SET_ProductBrand: (state, productBrand) => {
    state.productBrand = productBrand;
    if (!productBrand.length) localStorage.removeItem('productBrand');
  },
};

const actions = {
  /** 平台商品分类 **/
  getAdminProductClassify({ commit, dispatch }) {
    return new Promise((resolve, reject) => {
      store
        .productCategoryApi()
        .then(async (res) => {
          commit('SET_AdminProductClassify', changeNodes(res));
          localStorage.setItem('adminProductClassify', JSON.stringify(changeNodes(res)));
          resolve(res);
        })
        .catch((error) => {
          reject(error);
        });
    });
  },

  /** 商品品牌 **/
  getMerProductBrand({ commit }) {
    return new Promise((resolve, reject) => {
      store
        .brandListAllApi()
        .then(async (res) => {
          commit('SET_ProductBrand', res);
          localStorage.setItem('productBrand', JSON.stringify(res));
          resolve(res);
        })
        .catch((error) => {
          reject(error);
        });
    });
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

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  changeNodes,
};
