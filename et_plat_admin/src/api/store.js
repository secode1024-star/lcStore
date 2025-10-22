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
 * 商品详情
 * @param pram
 */
export function productDetailApi(id) {
  return request({
    url: `/admin/platform/product/info/${id}`,
    method: 'GET',
  });
}

/**
 * 删除商品
 * @param pram
 */
export function productDeleteApi(id, type) {
  return request({
    url: `/admin/store/product/delete/${id}`,
    method: 'get',
    params: { type: type },
  });
}

/**
 * 商品列表 表头数量
 */
export function productHeadersApi() {
  return request({
    url: '/admin/platform/product/tabs/headers',
    method: 'GET',
  });
}

/**
 * 商品列表
 * @param pram
 */
export function productLstApi(params) {
  return request({
    url: '/admin/platform/product/list',
    method: 'GET',
    params,
  });
}

/**
 * 商品审核
 * @param pram
 */
export function productAuditApi(data) {
  return request({
    url: `/admin/platform/product/audit`,
    method: 'post',
    data,
  });
}

/**
 * 修改虚拟销量
 * @param pram
 */
export function onChangeSalesApi(data) {
  return request({
    url: `/admin/platform/product/virtual/sales`,
    method: 'post',
    data,
  });
}

/**
 * 商品分类 分类缓存树
 * @param pram
 */
export function productCategoryApi() {
  return request({
    url: '/admin/platform/product/category/cache/tree',
    method: 'GET',
  });
}
/**
 * 商品分类 列表
 * @param pram
 */
export function productCategoryListApi(params) {
  return request({
    url: '/admin/platform/product/category/list',
    method: 'GET',
    params,
  });
}
/**
 * 商品分类 新增
 * @param pram
 */
export function productCategoryAddApi(data) {
  return request({
    url: '/admin/platform/product/category/add',
    method: 'post',
    data,
  });
}
/**
 * 商品分类 编辑
 * @param pram
 */
export function productCategoryUpdateApi(data) {
  return request({
    url: '/admin/platform/product/category/update',
    method: 'post',
    data,
  });
}
/**
 * 商品分类 删除
 * @param pram
 */
export function productCategoryDeleteApi(id) {
  return request({
    url: `/admin/platform/product/category/delete/${id}`,
    method: 'post',
  });
}
/**
 * 商品分类 修改分类显示状态
 * @param pram
 */
export function productCategoryShowApi(id) {
  return request({
    url: `/admin/platform/product/category/update/show/${id}`,
    method: 'post',
  });
}

/**
 * 商品上架
 * @param pram
 */
export function putOnShellApi(id) {
  return request({
    url: `/admin/store/product/putOnShell/${id}`,
    method: 'GET',
  });
}
/**
 * 商品强制下架
 * @param pram
 */
export function offShellApi(data) {
  return request({
    url: `/admin/platform/product/force/down`,
    method: 'post',
    data,
  });
}

/**
 * 商品评论 列表
 * @param pram
 */
export function replyListApi(params) {
  return request({
    url: '/admin/platform/product/reply/list',
    method: 'GET',
    params,
  });
}
/**
 * 商品评论 新增
 * @param pram
 */
export function replyCreatApi(data) {
  return request({
    url: '/admin/store/product/reply/save',
    method: 'POST',
    data,
  });
}
/**
 * 商品评论 编辑
 * @param pram
 */
export function replyEditApi(data) {
  return request({
    url: '/admin/store/product/reply/update',
    method: 'POST',
    data,
  });
}
/**
 * 商品评论 详情
 * @param pram
 */
export function replyInfoApi(id) {
  return request({
    url: `/admin/store/product/reply/info/${id}`,
    method: 'GET',
  });
}
/**
 * 商品评论 删除
 * @param pram
 */
export function replyDeleteApi(id) {
  return request({
    url: `/admin/platform/product/reply/delete/${id}`,
    method: 'GET',
  });
}

/**
 * 商品评论 回复
 * @param pram
 */
export function replyCommentApi(data) {
  return request({
    url: `/admin/store/product/reply/comment`,
    method: 'post',
    data,
  });
}

/**
 * 商品评论 导出
 * @param pram
 */
export function productExportApi(params) {
  return request({
    url: `/admin/export/excel/product`,
    method: 'get',
    params,
  });
}

/**
 * 商品复制 99Api
 * @param pram
 */
export function importProductApi(params) {
  return request({
    url: `/admin/store/product/importProduct`,
    method: 'post',
    params,
  });
}

/**
 * 商品复制 一号通
 * @param pram
 */
export function copyProductApi(data) {
  return request({
    url: `/admin/store/product/copy/product`,
    method: 'post',
    data,
  });
}

/**
 * 恢复
 * @param pram
 */
export function restoreApi(id) {
  return request({
    url: `/admin/store/product/restore/${id}`,
    method: 'get',
  });
}

/**
 * 商品列表 导出
 * @param pram
 */
export function productExcelApi(params) {
  return request({
    url: `/admin/export/excel/product`,
    method: 'get',
    params,
  });
}

/**
 * 商品列表 获取复制商品配置
 * @param pram
 */
export function copyConfigApi() {
  return request({
    url: `/admin/store/product/copy/config`,
    method: 'post',
  });
}

/**
 * 订单数据 导出
 * @param pram
 */
export function orderExcelApi(params) {
  return request({
    url: `/admin/export/excel/order`,
    method: 'get',
    params,
  });
}

/**
 * 品牌 列表
 * @param pram
 */
export function brandListApi(params) {
  return request({
    url: `/admin/platform/product/brand/list`,
    method: 'get',
    params,
  });
}

/**
 * 品牌缓存列表(全部)
 * @param pram
 */
export function brandListAllApi() {
  return request({
    url: `/admin/platform/product/brand/cache/list`,
    method: 'get',
  });
}

/**
 * 品牌 新增
 * @param pram
 */
export function brandAddApi(data) {
  return request({
    url: `/admin/platform/product/brand/add`,
    method: 'post',
    data,
  });
}

/**
 * 品牌 编辑
 * @param pram
 */
export function brandUpdateApi(data) {
  return request({
    url: `/admin/platform/product/brand/update`,
    method: 'post',
    data,
  });
}

/**
 * 品牌 删除
 * @param pram
 */
export function brandDeleteApi(id) {
  return request({
    url: `/admin/platform/product/brand/delete/${id}`,
    method: 'post',
  });
}

/**
 * 品牌 修改品牌显示状态
 * @param pram
 */
export function brandShowApi(id) {
  return request({
    url: `/admin/platform/product/brand/update/show/${id}`,
    method: 'post',
  });
}

/**
 * 保障服务 列表
 * @param pram
 */
export function guaranteeListApi(params) {
  return request({
    url: `/admin/platform/product/guarantee/list`,
    method: 'get',
    params,
  });
}

/**
 * 保障服务 新增
 * @param pram
 */
export function guaranteeAddApi(data) {
  return request({
    url: `/admin/platform/product/guarantee/add`,
    method: 'post',
    data,
  });
}

/**
 * 保障服务 编辑
 * @param pram
 */
export function guaranteeUpdateApi(data) {
  return request({
    url: `/admin/platform/product/guarantee/update`,
    method: 'post',
    data,
  });
}

/**
 * 保障服务 删除
 * @param pram
 */
export function guaranteeDeleteApi(id) {
  return request({
    url: `/admin/platform/product/guarantee/delete/${id}`,
    method: 'post',
  });
}

/**
 * 保障服务 修改品牌显示状态
 * @param pram
 */
export function guaranteeShowApi(id) {
  return request({
    url: `/admin/platform/product/guarantee/update/show/${id}`,
    method: 'post',
  });
}

/**
 * 修改商品后台排序
 * @param pram
 */
export function updateRankApi(data) {
  return request({
    url: `/admin/platform/product/update/rank`,
    method: 'post',
    data,
  });
}

/**
 * 商品可用优惠券列表
 * @param pram
 */
export function productCouponListApi() {
  return request({
    url: '/admin/platform/coupon/product/usable/list',
    method: 'get',
  });
}
