// +---------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +---------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +---------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +---------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +---------------------------------------------------------------------

import Vue from 'vue'
import App from './App'
import store from './store'
import Cache from './utils/cache'
import util from 'utils/util'
import configs from './config/app.js'
import i18n from './i18n/index.js' // 国际化
import * as Order from './libs/order';
import base from '@/components/base/index' // 公共组件
import * as filters from '@/filters'

Vue.prototype.$util = util;
Vue.prototype.$config = configs;
Vue.prototype.$Cache = Cache;
Vue.prototype.$eventHub = new Vue();
Vue.config.productionTip = false
Vue.prototype.$Order = Order;
App.mpType = 'app'
Object.keys(filters).forEach(key => {
  Vue.filter(key, filters[key])
})
Vue.use(base)

const app = new Vue({
	...App,
	i18n,
	store,
	Cache
})
app.$mount();
