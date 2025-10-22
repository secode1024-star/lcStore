import Layout from '@/layout'

const customerServiceRouter = {
  path: '/customer-service',
  component: Layout,
  redirect: '/customer-service/index',
  name: 'CustomerService',
  alwaysShow: true,
  meta: {
    title: '客服管理',
    icon: 'el-icon-chat-dot-round'
  },
  children: [
    {
      path: 'index',
      component: () => import('@/views/customerService/index'),
      name: 'CustomerServiceIndex',
      meta: {
        title: '客服工作台',
        icon: 'el-icon-chat-dot-square',
        noCache: true
      }
    },
    {
      path: 'config',
      component: () => import('@/views/customerService/config'),
      name: 'CustomerServiceConfig',
      meta: {
        title: '客服配置',
        icon: 'el-icon-setting'
      }
    }
  ]
}

export default customerServiceRouter





