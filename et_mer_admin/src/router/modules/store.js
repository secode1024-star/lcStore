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
  path: '/product',
  component: Layout,
  redirect: '/product/list',
  name: 'Product',
  meta: {
    title: '商品',
    icon: 'clipboard',
  },
  children: [
    {
      path: 'list',
      component: () => import('@/views/store/index'),
      name: 'ProductList',
      meta: { title: '商品列表', icon: '' },
    },
    {
      path: 'classify',
      component: () => import('@/views/store/sort/index'),
      name: 'Classify',
      meta: { title: '商品分类', icon: '' },
    },
    {
      path: 'attr',
      component: () => import('@/views/store/storeAttr/index'),
      name: 'Attr',
      meta: { title: '商品规格', icon: '' },
    },
    {
      path: 'reviews',
      component: () => import('@/views/store/storeComment/index'),
      name: 'Reviews',
      meta: { title: '商品评论', icon: '' },
    },
    {
      path: 'list/creatProduct/:id?/:isDisabled?',
      component: () => import('@/views/store/creatStore/index'),
      name: 'SortCreat',
      meta: { title: '商品添加', noCache: true, activeMenu: `/product/list` },
      hidden: true,
    },
  ],
};

export default storeRouter;
