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

const merchantRouter = {
  path: '/merchant',
  component: Layout,
  redirect: '/merchant',
  name: 'Merchant',
  meta: {
    title: '商户',
    icon: 'clipboard',
  },
  children: [
    {
      path: 'classify',
      name: 'classify',
      component: () => import('@/views/merchant/classify'),
      meta: { title: '商户分类', icon: '' },
    },
    {
      path: 'list',
      name: 'merchantList',
      component: () => import('@/views/merchant/list'),
      meta: { title: '商户列表', icon: '' },
    },
    {
      path: 'system',
      name: 'system',
      component: () => import('@/views/merchant/system'),
      meta: { title: '商户菜单管理', icon: '' },
    },
    {
      path: 'application',
      name: 'application',
      component: () => import('@/views/merchant/application'),
      meta: { title: '商户入驻申请', icon: '' },
    },
    {
      path: 'type',
      name: 'type',
      component: () => import('@/views/merchant/type'),
      meta: {
        title: '店铺类型',
        icon: 'clipboard',
      },
      children: [
        {
          path: 'list',
          component: () => import('@/views/merchant/type/list'),
          name: 'merchantTypeList',
          meta: { title: '店铺类型', icon: '' },
        },
        {
          path: 'accord',
          component: () => import('@/views/merchant/type/accord'),
          name: 'accord',
          meta: { title: '入驻协议', icon: '' },
        },
      ],
    },
  ],
};

export default merchantRouter;
