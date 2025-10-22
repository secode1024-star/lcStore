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

export function systemConfigCheck(pram) {
  const data = {
    name: pram.name,
  };
  return request({
    url: '/admin/system/config/check',
    method: 'GET',
    params: data,
  });
}

export function systemConfigInfo(pram) {
  const data = {
    formId: pram.id,
  };
  return request({
    url: '/admin/system/config/info',
    method: 'GET',
    params: data,
  });
}

export function systemConfigSave(pram) {
  return request({
    url: '/admin/system/config/save/form',
    method: 'POST',
    data: pram,
  });
}

/**
 * 文件上传
 * @param data
 */
export function fileFileApi(data, params) {
  return request({
    url: '/admin/merchant/upload/file',
    method: 'POST',
    params,
    data,
  });
}

/**
 * 图片上传
 * @param data
 */
export function fileImageApi(data, params) {
  return request({
    url: '/admin/merchant/upload/image',
    method: 'POST',
    params,
    data,
  });
}

/**
 * 图片列表
 * @param data
 */
export function fileListApi(params) {
  return request({
    url: '/admin/merchant/attachment/list',
    method: 'get',
    params,
  });
}

/**
 * 图片列表 删除图片
 * @param data
 */
export function fileDeleteApi(data) {
  return request({
    url: `/admin/merchant/attachment/delete`,
    method: 'post',
    data,
  });
}

/**
 * 图片列表 移動分類
 * @param data
 */
export function attachmentMoveApi(data) {
  return request({
    url: `/admin/merchant/attachment/move`,
    method: 'post',
    data,
  });
}

export function configGetUniq(pram) {
  const data = {
    key: pram.key,
  };
  return request({
    url: '/admin/merchant/config/getuniq',
    method: 'GET',
    params: data,
  });
}
