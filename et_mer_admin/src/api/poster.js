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

/**
 * 创建海报
 * @param data
 */
export function createPosterApi(data) {
  return request({
    url: 'admin/merchant/poster/save',
    method: 'POST',
    data,
  });
}

/**
 * 海报列表
 * @param params
 */
export function posterListApi(params) {
  return request({
    url: 'admin/merchant/poster/list',
    method: 'GET',
    params,
  });
}

/**
 * 海报详情
 * @param id
 */
export function posterDetailApi(id) {
  return request({
    url: `admin/merchant/poster/info/${id}`,
    method: 'GET',
  });
}

/**
 * 更新海报
 * @param data
 */
export function updatePosterApi(data) {
  return request({
    url: 'admin/merchant/poster/update',
    method: 'POST',
    data,
  });
}

/**
 * 删除海报
 * @param id
 */
export function deletePosterApi(id) {
  return request({
    url: `admin/merchant/poster/delete/${id}`,
    method: 'POST',
  });
}

/**
 * 更新海报状态
 * @param id
 * @param status
 */
export function updatePosterStatusApi(id, status) {
  return request({
    url: `admin/merchant/poster/status/${id}`,
    method: 'POST',
    data: { status },
  });
}



