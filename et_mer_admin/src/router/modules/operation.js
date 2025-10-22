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

const operationRouter = {
  path: '/operation',
  component: Layout,
  redirect: '/operation/setting',
  name: 'Operation',
  meta: {
    title: '设置',
    icon: 'clipboard',
    roles: ['admin'],
  },
  children: [
    {
      path: 'modifyStoreInfo',
      name: 'modifyStoreInfo',
      component: () => import('@/views/systemSetting/modifyStoreInfo'),
      meta: {
        title: '商户基本设置',
        icon: 'clipboard',
      },
    },
    {
      path: 'roleManager',
      name: 'RoleManager',
      component: () => import('@/views/systemSetting/administratorAuthority'),
      meta: {
        title: '管理权限',
        icon: 'clipboard',
        roles: ['admin'],
      },
      children: [
        {
          path: 'identityManager',
          component: () => import('@/views/systemSetting/administratorAuthority/identityManager'),
          name: 'identityManager',
          meta: { title: '角色管理', icon: '' },
        },
        {
          path: 'adminList',
          component: () => import('@/views/systemSetting/administratorAuthority/adminList'),
          name: 'adminList',
          meta: { title: '管理员列表', icon: '' },
        },
      ],
    },
    {
      path: 'export',
      name: 'systemExport',
      component: () => import('@/views/systemSetting/systemExport'),
      meta: {
        title: '数据导出',
        icon: 'clipboard',
      },
      hidden: false,
    },
    {
      path: 'customerService',
      name: 'CustomerService',
      component: () => import('@/views/systemSetting/customerService/index'),
      redirect: '/operation/customerService/config',
      meta: {
        title: '客服管理',
        icon: 'clipboard',
      },
      children: [
        {
          path: 'config',
          component: () => import('@/views/systemSetting/customerService/config'),
          name: 'CustomerServiceConfig',
          meta: { title: '客服配置', icon: '' },
        },
        {
          path: 'chat',
          component: () => import('@/views/systemSetting/customerService/chat'),
          name: 'CustomerServiceChat',
          meta: { title: '客服会话', icon: '' },
        },
      ],
    },
  ],
};

export default operationRouter; //collate
