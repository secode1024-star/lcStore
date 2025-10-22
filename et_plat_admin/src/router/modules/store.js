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

const storeRouter = {
  path: '/store',
  component: Layout,
  redirect: '/store/list',
  name: 'Store',
  meta: {
    title: '商品',
    icon: 'clipboard',
  },
  children: [
    {
      path: 'list',
      component: () => import('@/views/store/index'),
      name: 'StoreIndex',
      meta: { title: '商品列表', icon: '' },
    },
    {
      path: 'sort',
      component: () => import('@/views/store/sort/index'),
      name: 'Sort',
      meta: { title: '商品分类', icon: '' },
    },
    {
      path: 'comment',
      component: () => import('@/views/store/storeComment/index'),
      name: 'StoreComment',
      meta: { title: '商品评论', icon: '' },
    },
    {
      path: 'brand',
      component: () => import('@/views/store/brand/index'),
      name: 'brand',
      meta: { title: '品牌管理', icon: '' },
    },
    {
      path: 'guarantee',
      component: () => import('@/views/store/guarantee/index'),
      name: 'guarantee',
      meta: { title: '保障服务', icon: '' },
    },
  ],
};

export default storeRouter;
