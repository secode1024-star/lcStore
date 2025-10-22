// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------
import store from "../store";
import i18n from '@/i18n/index.js' // 国际化

// 公共过滤器
export function filterEmpty(val) {
  let _result = '-'
  if (!val) {
    return _result
  }
  _result = val
  return _result
}
/**
 * 商户分类
 */
export function merCategoryFilter(status) {
  if(!status){
    return ''
  }
  let arrayList = store.getters.merchantClassify;
  let array = arrayList.filter(item => status === item.id)
  if(array.length){
    return array[0].name
  }else{
    return ''
  }
}

/**
 * 商铺类型
 */
export function merchantTypeFilter(status) {
  if(!status){
    return ''
  }
  let arrayList = store.getters.merchantType;
  let array = arrayList.filter(item => status === item.id)
  if(array.length){
    return array[0].name
  }else{
    return ''
  }
}

/**
 * 商户创建类型
 */
export function merCreateTypeFilter(status) {
  const statusMap = {
    'admin': '管理员创建',
    'apply': '商户入驻申请'
  }
  return statusMap[status]
}

/**
 * 商户类别
 */
export function selfTypeFilter(status) {
  const statusMap = {
    true: '自营',
    false: '非自营'
  }
  return statusMap[status]
}

/**
 * 日期去掉时间
 */
export function dateFormat(value) {
 if (!value) {
 	return '';
 }
 return value.split(' ')[0];
}

/**
 * 退款状态
 */
export function refundStatusFilter(status) {
  const statusMap = {
    0: i18n.t(`message.tips.stay`),
    1: i18n.t(`message.tips.noadopt`),
	2: i18n.t(`page.users.userReturnList.refunding`),
	3: i18n.t(`page.users.userReturnList.refunded`)
  }
  return statusMap[status]
}

/**
 * 订单状态
 */
export function orderStatusFilter(status) {
  const statusMap = {
    0: i18n.t(`page.user.orderStatus[1].name`),
    1: i18n.t(`page.user.orderStatus[2].name`),
	2: i18n.t(`page.user.orderStatus[6].name`),
	3: i18n.t(`page.user.orderStatus[5].name`)
  }
  return statusMap[status]
}