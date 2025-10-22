// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------

import {
	preOrderApi,
	payPayment
} from '@/api/order.js';
import util from '@/utils/util.js'

/**
 * 去商品详情
 */
export function goShopDetail(item) {
	uni.navigateTo({
		url: `/pages/goods_details/index?id=${item.id}`
	})
}

/**
 * 活动商品、普通商品、购物车、再次购买预下单
 */
export function getPreOrder(preOrderType, orderDetails) {
	return new Promise((resolve, reject) => {
		preOrderApi({
			"preOrderType": preOrderType,
			"orderDetails": orderDetails
		}).then(res => {
			uni.navigateTo({
				url: '/pages/users/order_confirm/index?preOrderNo=' + res.data.preOrderNo
			});
		}).catch(err => {
			return util.Tips({
				title: err
			});
		})
	});
}

/**
 * 待支付订单去付款
 */
export function goPay(item) {
	return new Promise((resolve, reject) => {
		payPayment({
			orderNo: item.orderNo,
			payChannel: item.payChannel,
			payType: item.payType
		}).then(res => {
			if (item.payType === 'paypal') {
				window.location.href = res.data.redirect;
			} else if (item.payType === 'wechat') {
				setTimeout(() => {
					location.href = res.data.redirect;
				}, 2000)
			} else {
				uni.navigateTo({
					url: '/pages/users/stripe_payment/index?clientSecret=' + res.data
						.stripeClientSecret
				})
			}
			uni.hideLoading();
		}).catch(err => {
			uni.hideLoading();
			return util.Tips({
				title: err
			});
		});
	});
}