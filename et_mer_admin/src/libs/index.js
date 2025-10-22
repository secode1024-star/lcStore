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
import modalAttr from '@/libs/modal-attr'; //商品规格弹窗
import modalParserFrom from '@/libs/modal-parserFrom'; //自定义表单组件弹窗
import modalSure from '@/libs/modal-sure'; //二次确认弹窗
import timeOptions from '@/libs/timeOptions'; //时间转换
import * as constants from '@/utils/constants.js'; //constants.js全局使用
import * as selfUtil from '@/utils/ZBKJIutil.js'; //ZBKJIutil.js全局使用
import schema from 'async-validator';
import { parseTime, resetForm, addDateRange, selectDictLabel, selectDictLabels, handleTree } from '@/utils/parsing';

export default {
  install(Vue) {
    Vue.prototype.$modalSure = modalSure;
    Vue.prototype.$modalAttr = modalAttr;
    Vue.prototype.$modalParserFrom = modalParserFrom;
    Vue.prototype.$timeOptions = timeOptions;
    Vue.prototype.$constants = constants;
    Vue.prototype.$selfUtil = selfUtil;
    Vue.prototype.handleTree = handleTree;
    Vue.prototype.parseTime = parseTime;
    Vue.prototype.resetForm = resetForm;
    Vue.prototype.$validator = function (rule) {
      return new schema(rule);
    };
  },
};

const global = {
  //获取币种配置
  shopPayCurrency: localStorage.getItem('shopPayCurrency') ? localStorage.getItem('shopPayCurrency') : '$',
};
Vue.prototype.GLOBAL = global;
