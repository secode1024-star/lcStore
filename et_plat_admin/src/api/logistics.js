// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import request from '@/utils/request';

// 物流公司列表
export function expressList(params) {
  return request({
    url: '/admin/platform/express/list',
    method: 'get',
    params,
  });
}

// 物流公司修改状态
export function expressUpdateShow(data) {
  return request({
    url: '/admin/platform/express/update/show',
    method: 'post',
    data,
  });
}

// 删除物流公司
export function expressDelete(id) {
  return request({
    url: `/admin/platform/express/delete/${id}`,
    method: 'post',
  });
}
