// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

//会员过滤器

/**
 * 等级
 */
export function levelFilter(status) {
  if (!status) {
    return '';
  }
  let arrayList = JSON.parse(localStorage.getItem('levelKey'));
  let array = arrayList.filter((item) => status === item.id);
  if (array.length) {
    return array[0].name;
  } else {
    return '';
  }
}

/**
 * 标签
 */
export function tagFilter(status) {
  if (!status) {
    return '-';
  }
  let arr = JSON.parse(localStorage.getItem('tagAllList'));
  let obj = {};
  for (let i in arr) {
    obj[arr[i].id] = arr[i];
  }
  let strArr = status.split(',');
  let newArr = [];
  for (let item of strArr) {
    if (obj[item]) {
      newArr.push(obj[item].name);
    }
  }
  return newArr.join(',');
}

/**
 * 用户类型
 */
export function filterIsPromoter(status) {
  const statusMap = {
    true: '推广员',
    false: '普通用户',
  };
  return statusMap[status];
}
