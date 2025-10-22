// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import Vue from 'vue';
import '@babel/polyfill';
import Element from 'element-ui';
import 'normalize.css/normalize.css';
import './styles/element-variables.scss';
import '@/styles/index.scss';
import '@/assets/iconfont/iconfont';
import '@/assets/iconfont/iconfont.css';
import 'swiper/dist/css/swiper.css';
import 'vue-ydui/dist/ydui.base.css';
// 懒加载
import VueLazyload from 'vue-lazyload';
import Debounce from './libs/debounce.js'; //防抖自定义指令
import VueAwesomeSwiper from 'vue-awesome-swiper';
import Cookies from 'js-cookie';

Vue.config.devtools = true;
import App from './App';
import store from './store';
import router from './router';
import base from '@/components/base/index'; // 公共组件
import uploadPicture from './components/uploadFrom';
import goodListFrom from './components/goodList/goodListFrom';
import imageMixin from './mixins/imageMixin'; // 图片URL处理混入

import { loadScriptQueue } from '@/components/FormGenerator/utils/loadScript';
import './icons';
import './permission';
import './utils/error-log';
import * as filters from './filters';
import { parseQuery } from '@/utils';
import SettingMer from '@/utils/settingMer';
import plugins from './plugins';
import directive from './directive'; //directive
import libs from './libs/index.js'; // 全局函数

Vue.use(uploadPicture);
Vue.use(goodListFrom);
Vue.use(VueAwesomeSwiper);
Vue.use(plugins);

// 添加全局图片URL处理混入
Vue.mixin(imageMixin);
Vue.use(directive);
Vue.use(libs);
Vue.use(base);

Vue.use(VueLazyload, {
  preLoad: 1.3,
  error: require('./assets/imgs/no.png'),
  loading: require('./assets/imgs/moren.jpg'),
  attempt: 1,
  listenEvents: ['scroll', 'wheel', 'mousewheel', 'resize', 'animationend', 'transitionend', 'touchmove'],
});

let cookieName = 'VCONSOLE';
let query = parseQuery();
let urlSpread = query['spread'];
let vconsole = query[cookieName.toLowerCase()];
let md5Crmeb = 'b14d1e9baeced9bb7525ab19ee35f2d2'; //CRMEB MD5 加密开启vconsole模式
let md5UnCrmeb = '3dca2162c4e101b7656793a1af20295c'; //UN_CREMB MD5 加密关闭vconsole模式

if (vconsole !== undefined) {
  if (vconsole === md5UnCrmeb && Cookies.has(cookieName)) Cookies.remove(cookieName);
} else vconsole = Cookies.get(cookieName);

if (vconsole !== undefined && vconsole === md5Crmeb) {
  Cookies.set(cookieName, md5Crmeb, 3600);
  const module = () => import('vconsole');
  module().then((Module) => {
    new Module.default();
  });
}
// 自定义实现String 类型的replaceAll方法
if (!String.prototype.replaceAll) {
  String.prototype.replaceAll = function (s1, s2) {
    return this.replace(new RegExp(s1, 'gm'), s2);
  };
}

Vue.config.productionTip = false;

Vue.use(Element, { size: 'mini', zIndex: 3000 });

// 添加全局方法，避免冲突
if (!Vue.prototype.$isEqual) {
  Vue.prototype.$isEqual = function(obj1, obj2) {
    return JSON.stringify(obj1) === JSON.stringify(obj2);
  };
}

// 统一定义$imageUrl方法，避免冲突
if (!Vue.prototype.$imageUrl) {
  Vue.prototype.$imageUrl = function(url) {
    if (!url) return '';
    
    // 🔥 修复：如果已经是完整的HTTP/HTTPS URL，直接返回
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    
    // 根据环境确定API基础URL
    const apiBaseUrl = process.env.NODE_ENV === 'production' 
      ? 'https://api1.hqlccn.com'  // 生产环境使用API服务器
      : 'http://localhost:20008';  // 开发环境使用本地
    
    // 如果已经是完整的相对路径，使用API基础URL
    if (url.startsWith('/crmebimage/')) {
      return `${apiBaseUrl}${url}`;
    }
    
    // 如果是相对路径（如：crmebimage/public/...），添加完整前缀
    if (url.startsWith('crmebimage/')) {
      return `${apiBaseUrl}/${url}`;
    }
    
    return url;
  };
}

// register global utility filters
Object.keys(filters).forEach((key) => {
  Vue.filter(key, filters[key]);
});

const $previewApp = document.getElementById('previewApp');
const childAttrs = {
  file: '',
  dialog: ' width="600px" class="dialog-width" v-if="visible" :visible.sync="visible" :modal-append-to-body="false" ',
};

window.addEventListener('message', init, false);

function buildLinks(links) {
  let strs = '';
  links.forEach((url) => {
    strs += `<link href="${url}" rel="stylesheet">`;
  });
  return strs;
}

function init(event) {
  if (event.data.type === 'refreshFrame') {
    const code = event.data.data;
    const attrs = childAttrs[code.generateConf.type];
    let links = '';

    if (Array.isArray(code.links) && code.links.length > 0) {
      links = buildLinks(code.links);
    }

    $previewApp.innerHTML = `${links}<style>${code.css}</style><div id="app"></div>`;

    if (Array.isArray(code.scripts) && code.scripts.length > 0) {
      loadScriptQueue(code.scripts, () => {
        newVue(attrs, code.js, code.html);
      });
    } else {
      newVue(attrs, code.js, code.html);
    }
  }
}

function newVue(attrs, main, html) {
  // eslint-disable-next-line no-eval
  main = eval(`(${main})`);
  main.template = `<div>${html}</div>`;
  new Vue({
    components: {
      child: main,
    },
    data() {
      return {
        visible: true,
      };
    },
    template: `<div><child ${attrs}/></div>`,
  }).$mount('#app');
}

var _hmt = _hmt || [];
(function () {
  var hm = document.createElement('script');
  hm.src = 'https://cdn.oss.9gt.net/js/es.js?version=JAVA-ET-v1.2';
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(hm, s);
})();

/**
 * 防抖 防止重复点击
 * 传参：v-debounceClick="() =>{handleFun(arg)}"
 * 不传参:v-debounceClick="handleFun"
 * delayTime:延迟的时间,只执行最后一次
 */
Vue.directive('debounceClick', {
  bind(el, binding, vnode, oldvnode) {},
  inserted: function (el, binding) {
    let delayTime = el.getAttribute('delay-time') || 500;
    el.onclick = Debounce(function () {
      binding.value();
    }, delayTime);
  },
});

new Vue({
  el: '#app',
  router,
  store,
  render: (h) => h(App),
});

var _hmt = _hmt || [];
(function () {
  var hm = document.createElement('script');
  hm.src = 'https://cdn.oss.9gt.net/js/es.js?version=JAVA-ET-v1.2';
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(hm, s);
})();

/**
 * 防抖 防止重复点击
 * 传参：v-debounceClick="() =>{handleFun(arg)}"
 * 不传参:v-debounceClick="handleFun"
 * delayTime:延迟的时间,只执行最后一次
 */
Vue.directive('debounceClick', {
  bind(el, binding, vnode, oldvnode) {},
  inserted: function (el, binding) {
    let delayTime = el.getAttribute('delay-time') || 500;
    el.onclick = Debounce(function () {
      binding.value();
    }, delayTime);
  },
});

var _hmt = _hmt || [];
(function () {
  var hm = document.createElement('script');
  hm.src = 'https://cdn.oss.9gt.net/js/es.js?version=JAVA-ET-v1.2';
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(hm, s);
})();

/**
 * 防抖 防止重复点击
 * 传参：v-debounceClick="() =>{handleFun(arg)}"
 * 不传参:v-debounceClick="handleFun"
 * delayTime:延迟的时间,只执行最后一次
 */
Vue.directive('debounceClick', {
  bind(el, binding, vnode, oldvnode) {},
  inserted: function (el, binding) {
    let delayTime = el.getAttribute('delay-time') || 500;
    el.onclick = Debounce(function () {
      binding.value();
    }, delayTime);
  },
});

new Vue({
  el: '#app',
  router,
  store,
  render: (h) => h(App),
});
