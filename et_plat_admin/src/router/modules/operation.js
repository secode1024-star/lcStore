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
      path: 'setting',
      name: 'operationSetting',
      component: () => import('@/views/systemSetting/setting'),
      meta: {
        title: '平台设置',
        icon: 'clipboard',
      },
    },
    {
      path: 'notification',
      name: 'notification',
      component: () => import('@/views/systemSetting/notification'),
      meta: {
        title: '消息通知',
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
        {
          path: 'promiseRules',
          component: () => import('@/views/systemSetting/administratorAuthority/permissionRules'),
          name: 'promiseRules',
          meta: { title: '权限规则', icon: '' },
        },
      ],
    },
    {
      path: 'design',
      name: 'design',
      alwaysShow: true,
      component: () => import('@/views/systemSetting/design'),
      meta: {
        title: '页面管理',
        roles: ['admin'],
      },
      children: [
        {
          path: 'viewDesign',
          component: () => import('@/views/systemSetting/design/viewDesign'),
          name: 'viewDesign',
          meta: { title: '页面设计', noCache: true },
        },
        {
          path: 'theme',
          component: () => import('@/views/systemSetting/design/theme'),
          name: 'theme',
          meta: { title: '一键换色', noCache: true },
        },
      ],
    },
    {
      path: 'messageRecord',
      name: 'messageRecord',
      component: () => import('@/views/systemSetting/messageRecord'),
      meta: {
        title: '短信记录',
        icon: 'clipboard',
      },
      hidden: false,
    },
    {
      path: 'agreement',
      name: 'agreement',
      component: () => import('@/views/systemSetting/agreement'),
      meta: {
        title: '协议设置',
        icon: 'clipboard',
      },
    },
  ],
};

export default operationRouter; //collate
