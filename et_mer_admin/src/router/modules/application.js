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

const applicationRouter = {
  path: '/application',
  component: Layout,
  redirect: '/application/poster',
  name: 'Application',
  meta: {
    title: '应用',
    icon: 'app',
    // 临时移除权限检查，等数据库权限配置完成后再启用
    // perms: ['merchant:poster:page:list'],
  },
  children: [
    {
      path: 'poster',
      name: 'PosterManagement',
      component: () => import('@/views/application/poster/index'),
      meta: {
        title: '海报管理',
        icon: 'poster',
        breadcrumb: true,
        // 临时移除权限检查
        // perms: ['merchant:poster:page:list'],
      },
    },
    {
      path: 'poster/create',
      name: 'CreatePoster',
      component: () => import('@/views/application/poster/create'),
      meta: {
        title: '生成海报',
        icon: 'poster-create',
        breadcrumb: true,
        // 临时移除权限检查
        // perms: ['merchant:poster:save'],
      },
      hidden: true,
    },
    {
      path: 'poster/edit/:id',
      name: 'EditPoster',
      component: () => import('@/views/application/poster/edit'),
      meta: {
        title: '编辑海报',
        icon: 'poster-edit',
        breadcrumb: true,
        // 临时移除权限检查
        // perms: ['merchant:poster:update'],
      },
      hidden: true,
    },
  ],
};

export default applicationRouter;