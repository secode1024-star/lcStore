// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

/** When your routing table is too long, you can split it into small modules **/

import Layout from '@/layout';

const maintainRouter = {
  path: '/maintain',
  component: Layout,
  redirect: '/maintain/devconfiguration/configCategory',
  name: 'maintain',
  meta: {
    title: '维护',
    icon: 'clipboard',
  },
  children: [
    {
      path: 'user',
      name: 'user',
      component: () => import('@/views/maintain/user'),
      meta: {
        title: '个人中心',
        icon: 'clipboard',
      },
      hidden: true,
    },
    {
      path: 'picture',
      name: 'picture',
      component: () => import('@/views/maintain/picture'),
      meta: {
        title: '素材管理',
        icon: 'clipboard',
      },
      hidden: false,
    },
    {
      path: 'sensitiveLog',
      name: 'sensitiveLog',
      component: () => import('@/views/maintain/sensitiveList'),
      meta: {
        title: '敏感操作日志',
        icon: 'clipboard',
      },
      hidden: false,
    },
  ],
};

export default maintainRouter;
