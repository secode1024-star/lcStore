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
 * 提现申请 列表
 * @param pram
 */
export function applyListApi(params) {
  return request({
    url: '/admin/finance/apply/list',
    method: 'get',
    params,
  });
}

/**
 * 提现申请 金额
 * @param pram
 */
export function applyBalanceApi(params) {
  return request({
    url: '/admin/finance/apply/balance',
    method: 'post',
    params,
  });
}

/**
 * 提现申请 修改
 * @param pram
 */
export function applyUpdateApi(params) {
  return request({
    url: '/admin/finance/apply/update',
    method: 'post',
    params,
  });
}

/**
 * 提现申请 审核
 * @param pram
 */
export function applyStatusApi(params, data) {
  return request({
    url: '/admin/finance/apply/apply',
    method: 'post',
    params,
    data,
  });
}

/**
 * 充值 列表
 * @param pram
 */
export function topUpLogListApi(params) {
  return request({
    url: '/admin/user/topUpLog/list',
    method: 'get',
    params,
  });
}

/**
 * 充值 金额
 * @param pram
 */
export function balanceApi() {
  return request({
    url: '/admin/user/topUpLog/balance',
    method: 'post',
  });
}

/**
 * 充值 删除
 * @param pram
 */
export function topUpLogDeleteApi(params) {
  return request({
    url: '/admin/user/topUpLog/delete',
    method: 'get',
    params,
  });
}

/**
 * 充值 退款
 * @param pram
 */
export function refundApi(data) {
  return request({
    url: '/admin/user/topUpLog/refund',
    method: 'post',
    data,
  });
}

/**
 * 佣金记录 列表
 * @param pram
 */
export function brokerageListApi(params) {
  return request({
    url: '/admin/finance/founds/monitor/brokerage/record',
    method: 'get',
    params,
  });
}

/**
 * @description 资金流水 -- 列表
 */
export function capitalFlowLstApi(params) {
  return request({
    url: `admin/platform/finance/list`,
    method: 'get',
    params,
  });
}

/**
 * @description 资金流水 -- 详情
 */
export function financeInfoApi(id) {
  return request({
    url: `admin/platform/finance/info/${id}`,
    method: 'get',
  });
}

/**
 * @description 资金流水 -- 导出
 */
export function capitalFlowExportApi(data) {
  return request.get(`financial_record/export`, data);
}

/**
 * @description 转账记录列表
 */
export function transferLstApi(params) {
  return request({
    url: 'admin/platform/finance/transfer/record/list',
    method: 'GET',
    params,
  });
}

/**
 * @description 转账记录详情
 */
export function transferDetailApi(id) {
  return request({
    url: `admin/platform/finance/transfer/record/info/${id}`,
    method: 'GET',
  });
}

/**
 * @description 转账记录 转账凭证
 */
export function transferProofApi(data) {
  return request({
    url: `admin/platform/finance/transfer/proof`,
    method: 'POST',
    data,
  });
}

/**
 * @description 转账记录 转账备注
 */
export function transferRemarkApi(data) {
  return request({
    url: `admin/platform/finance/transfer/remark`,
    method: 'POST',
    data,
  });
}

/**
 * @description 转账记录 转账审核
 */
export function transferAuditApi(data) {
  return request({
    url: `admin/platform/finance/transfer/audit`,
    method: 'POST',
    data,
  });
}

/**
 * @description 转账设置 详情
 */
export function transferConfigApi() {
  return request({
    url: `admin/platform/finance/transfer/config`,
    method: 'get',
  });
}

/**
 * @description 转账设置 提交表单
 */
export function transferEditApi(data) {
  return request({
    url: `admin/platform/finance/transfer/config/edit`,
    method: 'post',
    data,
  });
}

/**
 * @description 账单管理 日帐单管理分页列表
 */
export function dayStatementApi(params) {
  return request({
    url: `admin/platform/finance/daily/statement/list`,
    method: 'get',
    params,
  });
}

/**
 * @description 账单管理 月帐单管理分页列表
 */
export function monthStatementApi(params) {
  return request({
    url: `admin/platform/finance/month/statement/list`,
    method: 'get',
    params,
  });
}
/**
 * @description 转账记录 -- 导出
 */
export function transferRecordsExportApi(data) {
  return request.get(`financial/export`, data);
}
