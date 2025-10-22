// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2024 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

/** When your routing table is too long, you can split it into small modules **/

import Layout from '@/layout';

const marketingRouter = {
  path: '/marketing',
  component: Layout,
  redirect: '/marketing/PlatformCoupon/list',
  name: 'Marketing',
  meta: {
    title: '营销',
    icon: 'clipboard',
  },
  children: [
    {
      path: 'community',
      name: 'Community',
      meta: {
        title: '种草社区',
        noCache: true,
      },
      component: () => import('@/views/community'),
      children: [
        {
          path: 'classification',
          name: 'communityClassification',
          component: () => import('@/views/community/classification/index'),
          meta: {
            title: '社区分类',
            icon: 'clipboard',
          },
        },
        {
          path: 'topics',
          name: 'communityTopics',
          component: () => import('@/views/community/topics/index'),
          meta: {
            title: '社区话题',
            icon: 'clipboard',
          },
        },
        {
          path: 'content',
          name: 'communityContent',
          component: () => import('@/views/community/content/index'),
          meta: {
            title: '社区内容',
            icon: 'clipboard',
          },
        },
        {
          path: 'comments',
          name: 'communityComments',
          component: () => import('@/views/community/comments/index'),
          meta: {
            title: '社区评论',
            icon: 'clipboard',
          },
        },
        {
          path: 'config',
          name: 'communityConfig',
          component: () => import('@/views/community/config/index'),
          meta: {
            title: '社区配置',
            icon: 'clipboard',
          },
        },
      ],
    },
  ],
};

export default marketingRouter;
