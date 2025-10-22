import Layout from '@/layout'

const posterRouter = {
  path: '/poster',
  component: Layout,
  redirect: '/poster/index',
  name: 'Poster',
  alwaysShow: true,
  meta: {
    title: '海报管理',
    icon: 'component',
  },
  children: [
    {
      path: 'index',
      component: () => import('@/views/poster/index'),
      name: 'PosterIndex',
      meta: {
        title: '海报列表',
        breadcrumb: true
      },
    },
    {
      path: 'create',
      component: () => import('@/views/poster/create'),
      name: 'PosterCreate',
      meta: {
        title: '创建海报',
        breadcrumb: true
      },
      hidden: true,
    },
    {
      path: 'edit/:id',
      component: () => import('@/views/poster/edit'),
      name: 'PosterEdit',
      meta: {
        title: '编辑海报',
        breadcrumb: true
      },
      hidden: true,
    },
  ],
};

export default posterRouter;
