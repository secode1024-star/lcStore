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
 * 活动 列表
 * @param prams
 */
export function activityListApi(params) {
  return request({
    url: '/admin/platform/activity/list',
    method: 'get',
    params,
  });
}

/**
 * 活动 添加
 * @param prams
 */
export function activityAddApi(data) {
  return request({
    url: '/admin/platform/activity/add',
    method: 'post',
    data,
  });
}

/**
 * 活动 编辑
 * @param prams
 */
export function activityUpdateApi(data) {
  return request({
    url: '/admin/platform/activity/update',
    method: 'post',
    data,
  });
}

/**
 * 活动 删除
 * @param prams
 */
export function activityDeleteApi(id) {
  return request({
    url: `admin/platform/activity/delete/${id}`,
    method: 'post',
  });
}

/**
 * 活动 详情
 * @param prams
 */
export function activityInfoApi(id) {
  return request({
    url: `admin/platform/activity/info/${id}`,
    method: 'GET',
  });
}

/**
 * 活动 开关
 * @param prams
 */
export function activitySwitchApi(id) {
  return request({
    url: `admin/platform/activity/switch/${id}`,
    method: 'post',
  });
}
