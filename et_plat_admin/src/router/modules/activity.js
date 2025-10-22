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

const activityRouter = {
  path: '/activity',
  component: Layout,
  redirect: '/activity/list',
  name: 'Activity',
  meta: {
    title: '活动',
    icon: 'clipboard',
  },
  children: [
    {
      path: 'list',
      component: () => import('@/views/activity/list/index'),
      name: 'activityList',
      meta: { title: '活动列表', icon: '' },
    },
  ],
};

export default activityRouter;
