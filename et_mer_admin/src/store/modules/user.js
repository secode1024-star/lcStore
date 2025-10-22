// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import { login, logout, getInfo } from '@/api/user';
import { getToken, setToken, removeToken } from '@/utils/auth';
import router, { resetRouter } from '@/router';
import Cookies from 'js-cookie';

const state = {
  token: getToken(),
  name: '',
  avatar: '',
  introduction: '',
  roles: [],
  permissions: [],
  captcha: {
    captchaVerification: '',
    secretKey: '',
    token: '',
  }, //滑块验证token
};

const mutations = {
  SET_TOKEN: (state, token) => {
    state.token = token;
  },
  SET_INTRODUCTION: (state, introduction) => {
    state.introduction = introduction;
  },
  SET_NAME: (state, name) => {
    state.name = name;
  },
  SET_AVATAR: (state, avatar) => {
    state.avatar = avatar;
  },
  SET_ROLES: (state, roles) => {
    state.roles = roles;
  },
  SET_PERMISSIONS: (state, permissions) => {
    state.permissions = permissions;
  },
  SET_CAPTCHA: (state, captcha) => {
    state.captcha = captcha;
  },
};

const actions = {
  // user login
  login({ commit }, userInfo) {
    const { account, pwd, key, code, wxCode } = userInfo;
    return new Promise((resolve, reject) => {
      login(userInfo)
        .then((data) => {
          commit('SET_TOKEN', data.token);
          Cookies.set('JavaMerInfo', JSON.stringify(data));
          setToken(data.token);
          resolve();
        })
        .catch((error) => {
          reject(error);
        });
    });
  },

  // get user info
  getInfo({ commit, state }) {
    return new Promise((resolve, reject) => {
      getInfo(state.token)
        .then((data) => {
          if (!data) {
            reject('Verification failed, please Login again.');
          }
          const { roles, account } = data;
          // roles must be a non-empty array
          if (!roles || roles.length <= 0) {
            reject('getInfo: roles must be a non-null array!');
          }

          commit('SET_ROLES', roles);
          // commit('SET_ROLES', ['admin'])
          commit('SET_NAME', account);
          // commit('SET_AVATAR', avatar)
          commit('SET_AVATAR', 'http://kaifa.crmeb.net/system/images/admin_logo.png');

          commit('SET_INTRODUCTION', 'CRMEB admin');
          commit('SET_PERMISSIONS', data.permissionsList); //权限标识
          resolve(data);
        })
        .catch((error) => {
          reject(error);
        });
    });
  },

  // user logout
  logout({ commit, state, dispatch }) {
    return new Promise((resolve, reject) => {
      logout(state.token)
        .then(() => {
          commit('SET_TOKEN', '');
          commit('SET_ROLES', []);
          commit('SET_PERMISSIONS', []);
          removeToken();
          resetRouter();
          // localStorage.clear();
          Cookies.remove('storeStaffList');
          Cookies.remove('JavaMerInfo');
          sessionStorage.removeItem('token');
          window.localStorage.clear();
          // reset visited views and cached views
          // to fixed https://github.com/PanJiaChen/vue-element-admin/issues/2485
          dispatch('tagsView/delAllViews', null, { root: true });

          resolve();
        })
        .catch((error) => {
          reject(error);
        });
    });
  },

  // remove token
  resetToken({ commit }) {
    return new Promise((resolve) => {
      commit('SET_TOKEN', '');
      commit('SET_ROLES', []);
      removeToken();
      resolve();
    });
  },
  // 设置token
  setToken({ commit }, state) {
    return new Promise((resolve) => {
      commit('SET_TOKEN', state.token);
      Cookies.set('JavaMerInfo', JSON.stringify(state));
      setToken(data.token);
      resolve();
    });
  },

  // dynamically modify permissions
  changeRoles({ commit, dispatch }, role) {
    return new Promise(async (resolve) => {
      const token = role + '-token';

      commit('SET_TOKEN', token);
      setToken(token);

      const { roles } = await dispatch('getInfo');

      resetRouter();

      // generate accessible routes map based on roles
      const accessRoutes = await dispatch('permission/generateRoutes', roles, { root: true });

      // dynamically add accessible routes
      router.addRoutes(accessRoutes);

      // reset visited views and cached views
      dispatch('tagsView/delAllViews', null, { root: true });

      resolve();
    });
  },
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
};
