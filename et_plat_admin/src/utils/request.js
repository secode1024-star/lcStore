// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import axios from 'axios';
import { MessageBox, Message } from 'element-ui';
import store from '@/store';
import { getToken } from '@/utils/auth';
import SettingMer from '@/utils/settingMer';
const service = axios.create({
  baseURL: SettingMer.apiBaseURL,
  timeout: 60000, // 过期时间
});

// request interceptor
service.interceptors.request.use(
  (config) => {
    // 发送请求之前做的
    const token = !store.getters.token ? sessionStorage.getItem('token') : store.getters.token;
    if (token) {
      config.headers['Authori-zation'] = token;
    }
    if (/get/i.test(config.method)) {
      config.params = config.params || {};
      config.params.temp = Date.parse(new Date()) / 1000;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  },
);

// response interceptor
service.interceptors.response.use(
  (response) => {
    const res = response.data;
    
    // 调试验证码API响应
    if (response.config.url && response.config.url.includes('/validate/code/get')) {
      console.log('🔥 验证码API原始响应:', {
        status: response.status,
        url: response.config.url,
        fullResponse: res,
        data: res.data
      });
    }
    
    // if the custom code is not 20000, it is judged as an error.
    if (res.code === 401) {
      // to re-login
      Message.error('无效的会话，或者登录已过期，请重新登录。');
      window.localStorage.clear();
      location.href = '/login';
    } else if (res.code === 403) {
      Message.error('没有权限访问。');
    }
    if (res.code !== 200 && res.code !== 401) {
      Message({
        message: res.message || 'Error',
        type: 'error',
        duration: 5 * 1000,
      });
      return Promise.reject(new Error(res.message || 'Error'));
    } else {
      // 成功响应处理
      // 对于客服配置API或data为null的情况，返回完整响应对象
      if (response.config.url && response.config.url.includes('/customer-service/') || res.data === null) {
        return res;
      }
      // 其他API保持原有逻辑
      return res.data !== undefined ? res.data : res;
    }
  },
  (error) => {
    Message({
      message: error.message,
      type: 'error',
      duration: 5 * 1000,
    });
    return Promise.reject(error);
  },
);

export default service;
