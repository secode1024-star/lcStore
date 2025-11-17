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
import VueI18n from 'vue-i18n';
import en from '@/locales/en.js'
import zh from '@/locales/zh-CN.js'
import fr from '@/locales/fr.js'
import th from '@/locales/th.js'
import ru from '@/locales/ru.js'
import ja from '@/locales/ja.js'
import ko from '@/locales/ko.js'
import ar from '@/locales/ar.js'
Vue.use(VueI18n);
export default ({ app, store }) => {
  // Set i18n instance on app
  // This way we can use it in middleware and pages asyncData/fetch

  app.i18n = new VueI18n({
    locale: app.$cookies.get('locale') ? app.$cookies.get('locale') : 'zh-CN',
    fallbackLocale: 'en',
    messages: {
      'en': en,
      'zh-CN': zh,
      'fr': fr,
      'th': th,
      'ru': ru,
      'ja': ja,
      'ko': ko,
      'ar': ar
    }
  });
  app.i18n.path = (link) => {
    if (app.i18n.locale === app.i18n.fallbackLocale) {
      return `/${link}`;
    }
    return `/${app.i18n.locale}/${link}`;
  }
}
