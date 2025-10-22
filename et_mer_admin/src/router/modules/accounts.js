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
const accountsRouter = {
  path: `/accounts`,
  name: 'accounts',
  meta: {
    icon: '',
    title: '财务',
  },
  alwaysShow: true,
  component: Layout,
  children: [
    {
      path: 'statement',
      name: 'AccountsStatement',
      meta: {
        title: '账单管理',
        noCache: true,
      },
      component: () => import('@/views/accounts/statement/index'),
    },
    {
      path: 'reconciliation/order/:id',
      name: 'ReconciliationOrder',
      component: () => import('@/views/accounts/reconciliation/record'),
      meta: {
        title: '查看订单',
        noCache: true,
        activeMenu: `/accounts/reconciliation`,
      },
      hidden: true,
    },
    {
      path: 'capitalFlow',
      name: 'AccountsCapitalFlow',
      meta: {
        title: '资金流水',
        noCache: true,
      },
      component: () => import('@/views/accounts/capitalFlow/index'),
    },
    {
      path: 'transManagement',
      name: 'AccountsTransManagement',
      meta: {
        title: '转账记录',
        noCache: true,
      },
      component: () => import('@/views/accounts/transManage/index'),
    },
  ],
};
export default accountsRouter;
