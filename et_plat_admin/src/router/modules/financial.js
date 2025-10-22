// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import Layout from '@/layout';

const financialRouter = {
  path: '/financial',
  component: Layout,
  redirect: '/financial',
  name: 'Financial',
  meta: {
    title: '财务',
    icon: 'clipboard',
  },
  children: [
    {
      path: 'capitalFlow',
      component: () => import('@/views/financial/capitalFlow'),
      name: 'capitalFlow',
      meta: { title: '资金流水', icon: '' },
    },
    {
      path: 'transferRecord',
      component: () => import('@/views/financial/transferRecord'),
      name: 'transferRecord',
      meta: { title: '转账记录', icon: '' },
    },
    {
      path: 'statement',
      component: () => import('@/views/financial/statement'),
      name: 'statement',
      meta: { title: '账单管理', icon: '' },
    },
    {
      path: 'setting',
      component: () => import('@/views/financial/setting'),
      name: 'financialSetting',
      meta: { title: '转账设置', icon: '' },
    },
  ],
};

export default financialRouter;
