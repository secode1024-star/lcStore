<template>
	<view>
		<tui-skeleton v-if="skeletonShow"></tui-skeleton>
		<view class='payment-status tui-skeleton'>
			<view class='status acea-row row-center-wrapper'>
				<text class="iconfont icon-zhifuchenggong success" v-if="order_pay_info.status || redirect_status==='succeeded'"></text>
				<text class="iconfont icon-zhifushibai fail" v-else></text>
				<text class="tui-skeleton-fillet">{{order_pay_info.status || redirect_status ? $t(`page.orderPayStatus.success`):$t(`page.orderPayStatus.fail`)}}</text>
			</view>
			<view v-if="order_pay_info.status" class='wrapper'>
				<view class='item acea-row row-between-wrapper tui-skeleton-fillet'>
					<view>{{$t(`page.orderPayStatus.orderId`)}}</view>
					<view class='itemCom'>{{order_pay_info.orderId}}</view>
				</view>
				<view class='item acea-row row-between-wrapper tui-skeleton-fillet'>
					<view>{{$t(`page.orderPayStatus.payType`)}}</view>
					<view class='itemCom'>Pay Pal</view>
				</view>
				<view class='item acea-row row-between-wrapper tui-skeleton-fillet'>
					<view>{{$t(`page.orderPayStatus.payPrice`)}}</view>
					<view class='itemCom'>{{shopPayCurrency}}{{order_pay_info.payPrice}}</view>
				</view>
			</view>
			<!-- <button class='returnBnt bg_color goOrderDetails tui-skeleton-fillet' v-if="detailShow" @click="goOrderDetails()">{{$t(`page.orderPayStatus.viewOrder`)}}</button> -->
			<button class='returnBnt cart-color tui-skeleton-fillet' @click="goIndex">{{$t(`page.orderPayStatus.backHome`)}}</button>
		</view>
	</view>
</template>

<script>
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import {paypalSuccess,paypalFail} from '@/api/order.js';
	import store from "../../store";
	let app = getApp();
	export default {
		
		data() {
			return {
				skeletonShow: true,
				order_pay_info: {
					status:false,
					orderId:'',
					payPrice:''
				},
				detailShow:true,
				status: null,
				PayerID: '',
				redirect_status: null,
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		computed: mapGetters(['isLogin','userInfo']),
		onLoad: function(options) {
			this.status = options.status ? options.status : null;
			this.redirect_status = options.redirect_status ? options.redirect_status : null;
			this.PayerID = options.PayerID
			if(options.token && options.PayerID){
				let data = {
					"payerID": options.PayerID,
					"token": options.token
				};
				if(options.status){
					this.order_pay_info.status = true;
					paypalSuccess(data).then(res=>{
						this.order_pay_info.orderId = res.data.orderNo;
						this.order_pay_info.payPrice = res.data.payPrice;
						this.skeletonShow = false;
						if(this.userInfo.userType == 'visitor'){
							this.detailShow = false;
							this.$Cache.clear('LOGIN_STATUS_TOKEN');
							this.$store.commit("LOGOUT");
						}
					})
				}else{
					this.order_pay_info.status = false;
					paypalFail(data).then(res=>{
						this.skeletonShow = false;
						
						return this.$util.Tips({
							title: this.$t(`message.pay.orderFail`)
						},{
							tab: 4,
							url: '/pages/index/index'
						})
					})
				}
			}else{
				this.skeletonShow = false;
			}
			
		},
		methods: {
			/**
			 * 去首页关闭当前所有页面
			 */
			goIndex: function(e) {
				uni.navigateTo({
					url: '/pages/index/index'
				})
			},
			/**
			 * 
			 * 去订单详情页面
			 */
			goOrderDetails: function(e) {
				let that = this;
				uni.navigateTo({
					url: '/pages/order_details/index?order_id=' + that.order_pay_info.orderId + '&orderStatus=0' + '&PayerID=' + that.PayerID
				})
			}

		}
	}
</script>

<style lang="scss">
	.bg_color{
		@include main_bg_color(theme);
	}
	.cart_color{
		@include main_color(theme);
		@include coupons_border_color(theme);
	}
	.success{
		color: rgba(66, 202, 77, 1);
		font-size: 40rpx;
		padding-right: 20rpx;
	}
	.fail{
		color: #CCC;
		font-size: 40rpx;
		padding-right: 20rpx;
	}
	.payment-status {
		background-color: #fff;
		margin: 195rpx 30rpx 0 30rpx;
		border-radius: 10rpx;
		padding: 1rpx 0 28rpx 0;
	}

	.payment-status .status {
		font-size: 32rpx;
		font-weight: bold;
		text-align: center;
		margin: 70rpx 0 70rpx 0;
		font-family: PingFangSC-Semibold, PingFang SC;
		color: #333333;
	}
	
	.payment-status .wrapper {
		border: 1rpx solid #eee;
		margin: 0 30rpx 47rpx 30rpx;
		padding: 35rpx 0;
		border-left: 0;
		border-right: 0;
	}

	.payment-status .wrapper .item {
		font-size: 28rpx;
		color: #282828;
	}

	.payment-status .wrapper .item~.item {
		margin-top: 20rpx;
	}

	.payment-status .wrapper .item .itemCom {
		color: #666;
	}

	.payment-status .returnBnt {
		width: 630rpx;
		height: 86rpx;
		border-radius: 50rpx;
		color: #fff;
		font-size: 30rpx;
		text-align: center;
		line-height: 86rpx;
		margin: 0 auto 20rpx auto;
		
	}
	.cart-color {
		@include main_color(theme);
		@include coupons_border_color(theme);
	}
</style>
