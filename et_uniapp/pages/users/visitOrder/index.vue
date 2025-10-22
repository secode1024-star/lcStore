<template>
	<view :data-theme="theme">
		<view class='order-details'>
			<!-- 给header上与data上加on为退款订单-->
			<view  class='header bg_color'>
				<view v-if="visitOrderType" class='picTxt acea-row row-middle'>
					<view class='pictrue'>
						<image :src="statusPic(orderInfo.status)"></image>
					</view>
					<view class='data'>
						<view class='state'>{{orderInfo.status | orderStatusFilter}}</view>
						<view v-if="orderInfo.refundReasonTime">{{orderInfo.refundReasonTime}}</view>
						<view v-else>{{orderInfo.payTime ? orderInfo.payTime :''}}</view>
					</view>
				</view>
			</view>
			<view class="pad30">
				<view class='nav address'>
					<view class='name'>{{orderInfo.realName}}<text class='phone'>{{orderInfo.userPhone}}</text></view>
					<view>{{orderInfo.userAddress}}</view>
				</view>
				<view v-if="!visitOrderType">
					<block v-for="(item, index) in orderInfo.orderList">
						<orderGoods :evaluate='evaluate' :orderInfo="item" :identity="identity" :orderId="order_id" :ids="id" :uniId="uniId" :cartInfo="item.orderInfoList"
							:jump="true"></orderGoods>
					</block>
				</view>
				<view v-else>
					<orderGoods :evaluate='evaluate' :orderInfo="orderInfo" :productType="orderInfo.type" :orderId="order_id" :ids="id" :uniId="uniId" :cartInfo="cartInfo"
						:jump="true"></orderGoods>
				</view>
				<!-- <orderGoods :evaluate='evaluate' :productType="orderInfo.type" :orderId="order_id" :ids="id" :uniId="uniId" :cartInfo="cartInfo"
					:jump="true"></orderGoods> -->
				<!-- <div class="goodCall borRadius14" @click="kefuClick">
					<span class="iconfont icon-kefu"></span><span>{{$t(`page.orderDetails.Customer`)}}</span>
				</div> -->
			</view>
			<view class="pad30">
				<view class='wrapper borRadius14'>
					<view class='item acea-row row-between'>
						<view>{{$t(`page.orderDetails.orderId`)}}：</view>
						<view class='conter acea-row row-middle row-right'><text class="text-overflow">{{orderInfo.orderId}}</text>
							<text class='copy copy-data' :data-clipboard-text="orderInfo.orderId">{{$t(`page.orderDetails.copy`)}}</text>
						</view>
					</view>
					<view class='item acea-row row-between'>
						<view>{{$t(`page.orderDetails.orderTime`)}}：</view>
						<view class='conter'>{{(orderInfo.createTime || 0)}}</view>
					</view>
					<view class='item acea-row row-between'>
						<view>{{$t(`page.orderDetails.payStatus`)}}：</view>
						<view class='conter' v-if="orderInfo.paid">{{$t(`page.orderDetails.payTrue`)}}</view>
						<view class='conter' v-else>{{$t(`page.orderDetails.payFalse`)}}</view>
					</view>
					<view class='item acea-row row-between'>
						<view>{{$t(`page.orderDetails.payType`)}}：</view>
						<view class='conter'>{{orderInfo.payType}}</view>
					</view>
					<view class='item flex justify-between align-center' v-if="orderInfo.mark && orderInfo.mark.length <= 15">
						<view>{{$t(`page.orderDetails.message`)}}：</view>
						<view class='conter' >{{orderInfo.mark}}</view>
					</view>
					<view class='item flex justify-between' v-if="orderInfo.mark && orderInfo.mark.length > 15">
						<view>{{$t(`page.orderDetails.message`)}}：</view>
						<view class="flex align-center" v-show="isShow" @click="isShow=!isShow">
							<view class='conter' >{{orderInfo.mark}}</view>
							<text class="iconfont icon-xuanze" style="font-size: 12px;"></text>
						</view>
						<view v-show="!isShow" @click="isShow=!isShow">
							<view class='mark_show' >{{orderInfo.mark}}</view>
						</view>
					</view>
				</view>
				<view v-if="orderInfo.status>0">
					<view class='wrapper borRadius14' v-if='orderInfo.deliveryType=="express"'>
						<view class='item acea-row row-between'>
							<view>{{$t(`page.orderDetails.sendMethod`)}}：</view>
							<view class='conter'>{{$t(`page.orderDetails.sendOne`)}}</view>
						</view>
						<view class='item acea-row row-between'>
							<view>{{$t(`page.orderDetails.CourierCompany`)}}：</view>
							<view class='conter'>{{orderInfo.deliveryName || ''}}</view>
						</view>
						<view class='item acea-row row-between'>
							<view>{{$t(`page.orderDetails.CourierNo`)}}：</view>
							<view class='conter'>{{orderInfo.deliveryId || ''}}</view>
						</view>
					</view>
					<view class='wrapper borRadius14' v-else-if='orderInfo.deliveryType=="send"'>
						<view class='item acea-row row-between'>
							<view>{{$t(`page.orderDetails.sendMethod`)}}：</view>
							<view class='conter'>{{$t(`page.orderDetails.sendTwo`)}}</view>
						</view>
						<view class='item acea-row row-between'>
							<view>{{$t(`page.orderDetails.deliveryName`)}}：</view>
							<view class='conter'>{{orderInfo.deliveryName || ''}}</view>
						</view>
						<view class='item acea-row row-between'>
							<view>{{$t(`page.orderDetails.deliveryPhone`)}}：</view>
							<view class='conter acea-row row-middle row-right'>{{orderInfo.deliveryId || ''}}<text
									class='copy' @tap='goTel'>Phone</text></view>
						</view>
					</view>
					<view class='wrapper borRadius14' v-else-if='orderInfo.deliveryType=="fictitious"'>
						<view class='item acea-row row-between'>
							<view>{{$t(`page.orderDetails.Virtual`)}}：</view>
							<view class='conter'>{{$t(`page.orderDetails.deliveryMsg`)}}</view>
						</view>
					</view>
				</view>
				<view class='wrapper borRadius14 logistics' v-if="expressList.length">
					<view class='logisticsCon'>
						<view class='item' v-for="(item,index) in expressList" :key="index">
							<view class='circular' :class='index === 0 ? "on":""'></view>
							<view class='text' :class='index===0 ? "on-font on":""'>
								<view>{{item.AcceptStation}}</view>
								<view class='data' :class='index===0 ? "on-font on":""'>{{item.AcceptTime}}</view>
							</view>
						</view>
					</view>
				</view>
				<view class='wrapper borRadius14'>
					<view class='item acea-row row-between'>
						<view>{{$t(`page.orderDetails.allPrice`)}}：</view>
						<view class='conter'>{{shopPayCurrency}}{{orderInfo.proTotalPrice}}</view>
					</view>
					<view class='item acea-row row-between' v-if="orderInfo.payPostage > 0">
						<view>{{$t(`page.orderDetails.freight`)}}：</view>
						<view class='conter'>{{shopPayCurrency}}{{orderInfo.payPostage}}</view>
					</view>
					<view class='item acea-row row-between' v-if='orderInfo.couponId'>
						<view>{{$t(`page.orderDetails.coupon`)}}：</view>
						<view class='conter'>-{{shopPayCurrency}}{{orderInfo.couponPrice}}</view>
					</view>
					<view class='item acea-row row-between' v-if="orderInfo.useIntegral > 0">
						<view>{{$t(`page.orderDetails.point`)}}：</view>
							<view class='conter'>-{{shopPayCurrency}}{{orderInfo.deductionPrice}}</view>
					</view>
					<view class='actualPay acea-row row-right'>{{$t(`page.orderDetails.actualPayment`)}}：
					<text class='money'>{{shopPayCurrency}}{{orderInfo.payPrice}}</text></view>
				</view>
			</view>
		</view>
	</view>
</template>
<script>
	import {orderVisitor, masterOrderVisitor} from '@/api/order.js';
	import orderGoods from "@/components/orderGoods";
	import ClipboardJS from "@/plugin/clipboard/clipboard.js";
	const app = getApp();
	export default {
		components: {
			orderGoods,
		},
		data() {
			return {
				order_id: '',
				evaluate: 0,
				cartInfo: [], //购物车产品
				orderInfo: {
					systemStore: {},
					pstatus: {}
				}, //订单详情
				expressList:[],
				system_store: {},
				isGoodsReturn: false, //是否为退款订单
				status: {}, //订单底部按钮状态
				totalPrice: '0',
				id: 0, //订单id
				uniId: '',
				type: 'normal',
				isShow:true,
				theme:app.globalData.theme,
				identity: '',
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		onLoad: function(options) {
			if(options.orderNo && options.identity){
				this.order_id = options.orderNo || 0
				this.identity = options.identity || ''
				this.visitOrderType = options.visitOrderType || ''
				if(options.visitOrderType){
					this.getSubOrderInfo(options.orderNo,options.identity);
				}else{
					this.getOrderInfo(options.orderNo,options.identity);
				}
				
			}
		},
		onReady: function() {
			this.$nextTick(function() {
				const clipboard = new ClipboardJS(".copy-data");
				clipboard.on("success", () => {
					this.$util.Tips({
						title: 'copy success'
					});
				});
			});
		},
		methods: {
			statusPic(status) {
			  const statusMap = {
			   0: '/static/images/daifahuo.gif',
			   1: '/static/images/daishouhuo.gif',
			   3: '/static/images/yiwancheng.gif'
			  }
			  return statusMap[status]
			},
			/**
			 * 分订单详情
			 * 
			 */
			getSubOrderInfo(orderNo,identity){
				let that = this;
				uni.showLoading({
					title: "loading"
				});
				orderVisitor({orderNo,identity}).then(res => {
					uni.hideLoading();
					that.$set(that, 'orderInfo', res.data);
					that.$set(that, 'evaluate', res.data.status == 2 ? 2 : 0);
					that.$set(that, 'system_store', res.data.systemStore);
					that.$set(that, 'id', res.data.id);
					that.$set(that, 'cartInfo', res.data.orderInfoList);
					let express = JSON.parse(res.data.expressInfo.logisticsInfo);
					that.$set(that, 'expressList', express.reverse());
					if (res.data.refundStatus != 0) {
						that.isGoodsReturn = true;
					};
				}).catch(err => {
					uni.hideLoading();
					that.$util.Tips({
						title: err
					});
				});
			},
			/**
			 * 获取订单详细信息
			 * 
			 */
			getOrderInfo: function(orderNo,identity) {
				let that = this;
				uni.showLoading({
					title: "loading"
				});
				masterOrderVisitor({orderNo,identity}).then(res => {
					uni.hideLoading();
					that.$set(that, 'orderInfo', res.data);
					that.$set(that, 'evaluate', res.data.status == 2 ? 2 : 0);
					that.$set(that, 'system_store', res.data.systemStore);
					that.$set(that, 'id', res.data.id);
					that.$set(that, 'cartInfo', res.data.orderInfoList);
					let express = JSON.parse(res.data.expressInfo.logisticsInfo);
					that.$set(that, 'expressList', express.reverse());
					if (res.data.refundStatus != 0) {
						that.isGoodsReturn = true;
					};
				}).catch(err => {
					uni.hideLoading();
					that.$util.Tips({
						title: err
					});
				});
			},
			/**
			 * 
			 * 剪切订单号
			 */
			// #ifndef H5
			copy: function() {
				let that = this;
				uni.setClipboardData({
					data: this.orderInfo.orderId
				});
			},
			// #endif
			/**
			 * 打电话
			 */
			goTel: function() {
				uni.makePhoneCall({
					phoneNumber: this.orderInfo.deliveryId
				})
			},
		}
	}
</script>

<style scoped lang="scss">
	.qs-btn {
		width: auto;
		height: 60rpx;
		text-align: center;
		line-height: 60rpx;
		border-radius: 50rpx;
		color: #fff;
		font-size: 27rpx;
		padding: 0 3%;
		color: #aaa;
		border: 1px solid #ddd;
		margin-right: 20rpx;
	}
	.text-overflow{
		width: 300rpx;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	.shuoming{
		width: 32rpx;
		height: 32rpx;
	}
	.mp-header{
		width: 100%;
		@include main_bg_color(theme);
	}
	.goodCall {
		@include main_color(theme);
		text-align: center;
		width: 100%;
		height: 86rpx;
		padding: 0 30rpx;
		border-bottom: 1rpx solid #eee;
		font-size: 30rpx;
		line-height: 86rpx;
		background: #fff;

		.icon-kefu {
			font-size: 36rpx;
			margin-right: 15rpx;
		}

		/* #ifdef MP */
		button {
			display: flex;
			align-items: center;
			justify-content: center;
			height: 86rpx;
			font-size: 30rpx;
			@include main_color(theme);
		}

		/* #endif */
	}
	.justify-between {
		justify-content: space-between;
	}
	.align-center{
		align-items: center;
	}
	.order-details{
		padding-bottom: 30rpx;
	}
	.order-details .header {
		height: 250rpx;
		padding: 0 30rpx;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
	.order-details .header.on {
		background-color: #666 !important;
	}

	.order-details .header .pictrue {
		width: 110rpx;
		height: 110rpx;
	}

	.order-details .header .pictrue image {
		width: 100%;
		height: 100%;
	}

	.order-details .header .data {
		color: rgba(255, 255, 255, 0.8);
		font-size: 24rpx;
		margin-left: 27rpx;
	}

	.order-details .header .data.on {
		margin-left: 0;
	}

	.order-details .header .data .state {
		font-size: 30rpx;
		font-weight: bold;
		color: #fff;
		margin-bottom: 7rpx;
	}

	.order-details .header .data .time {
		margin-left: 20rpx;
	}

	.picTxt {
		height: 150rpx;
	}

	.order-details .nav {
		width: 100%;
		border-radius: 14rpx;
		margin: -100rpx auto 0 auto;
	}
	.order-details .address {
		font-size: 26rpx;
		color: #868686;
		background-color: #fff;
		padding: 30rpx 24rpx;
	}

	.order-details .address .name {
		font-size: 30rpx;
		color: #282828;
		margin-bottom: 15rpx;
	}

	.order-details .address .name .phone {
		margin-left: 40rpx;
	}

	.order-details .line {
		width: 100%;
		height: 3rpx;
	}

	.order-details .line image {
		width: 100%;
		height: 100%;
		display: block;
	}
	.order-details .wrapper {
		background-color: #fff;
		margin-top: 12rpx;
		padding: 30rpx 24rpx;
	}

	.order-details .wrapper .item {
		font-size: 28rpx;
		color: #282828;
	}

	.order-details .wrapper .item~.item {
		margin-top: 20rpx;
	}

	.order-details .wrapper .item .conter {
		color: #868686;
		width: 470rpx;
		text-align: right;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	.mark_show{
		color: #868686;
		width: 470rpx;
		text-align: right;
	}
	.order-details .wrapper .item .conter .copy {
		font-size: 20rpx;
		color: #333;
		border-radius: 20rpx;
		border: 1rpx solid #666;
		padding: 3rpx 15rpx;
		margin-left: 24rpx;
	}

	.order-details .wrapper .actualPay {
		border-top: 1rpx solid #eee;
		margin-top: 30rpx;
		padding-top: 30rpx;
	}

	.order-details .wrapper .actualPay .money {
		font-weight: bold;
		font-size: 30rpx;
		@include price_color(theme);
	}

	.order-details .footer {
		width: 100%;
		height: 100rpx;
		position: fixed;
		bottom: 0;
		left: 0;
		background-color: #fff;
		padding: 0 30rpx;
		box-sizing: border-box;
	}

	.order-details .footer .bnt {
		width: 158rpx;
		height: 54rpx;
		text-align: center;
		line-height: 54rpx;
		border-radius: 50rpx;
		color: #fff;
		font-size: 27rpx;
	}

	.order-details .footer .bnt.cancel {
		color: #aaa;
		border: 1rpx solid #ddd;
	}

	.order-details .footer .bnt~.bnt {
		margin-left: 18rpx;
	}

	.order-details .writeOff {
		background-color: #fff;
		margin-top: 15rpx;
		padding-bottom: 50rpx;
	}

	.order-details .writeOff .title {
		font-size: 30rpx;
		color: #282828;
		height: 87rpx;
		border-bottom: 1px solid #f0f0f0;
		padding: 0 24rpx;
		line-height: 87rpx;
	}

	.order-details .writeOff .grayBg {
		background-color: #f2f5f7;
		width: 590rpx;
		height: 384rpx;
		border-radius: 20rpx 20rpx 0 0;
		margin: 50rpx auto 0 auto;
		padding-top: 55rpx;
	}

	.order-details .writeOff .grayBg .pictrue {
		width: 290rpx;
		height: 290rpx;
		margin: 0 auto;
	}

	.order-details .writeOff .grayBg .pictrue image {
		width: 100%;
		height: 100%;
		display: block;
	}

	.order-details .writeOff .gear {
		width: 590rpx;
		height: 30rpx;
		margin: 0 auto;
	}

	.order-details .writeOff .gear image {
		width: 100%;
		height: 100%;
		display: block;
	}

	.order-details .writeOff .num {
		background-color: #f0c34c;
		width: 590rpx;
		height: 84rpx;
		color: #282828;
		font-size: 48rpx;
		margin: 0 auto;
		border-radius: 0 0 20rpx 20rpx;
		text-align: center;
		padding-top: 4rpx;
	}

	.order-details .writeOff .rules {
		margin: 46rpx 30rpx 0 30rpx;
		border-top: 1px solid #f0f0f0;
		padding-top: 10rpx;
	}

	.order-details .writeOff .rules .item {
		margin-top: 20rpx;
	}

	.order-details .writeOff .rules .item .rulesTitle {
		font-size: 28rpx;
		color: #282828;
	}

	.order-details .writeOff .rules .item .rulesTitle .iconfont {
		font-size: 30rpx;
		color: #333;
		margin-right: 8rpx;
		margin-top: 5rpx;
	}

	.order-details .writeOff .rules .item .info {
		font-size: 28rpx;
		color: #999;
		margin-top: 7rpx;
	}

	.order-details .writeOff .rules .item .info .time {
		margin-left: 20rpx;
	}

	.order-details .map {
		height: 86rpx;
		font-size: 30rpx;
		color: #282828;
		line-height: 86rpx;
		border-bottom: 1px solid #f0f0f0;
		margin-top: 15rpx;
		background-color: #fff;
		padding: 0 24rpx;
	}

	.order-details .map .place {
		font-size: 26rpx;
		width: 176rpx;
		height: 50rpx;
		border-radius: 25rpx;
		line-height: 50rpx;
		text-align: center;
	}

	.order-details .map .place .iconfont {
		font-size: 27rpx;
		height: 27rpx;
		line-height: 27rpx;
		margin: 2rpx 3rpx 0 0;
	}

	.order-details .address .name .iconfont {
		font-size: 34rpx;
		margin-left: 10rpx;
	}

	.refund {
		padding:  0 !important;
		margin-top: 15rpx;
		background-color: #fff;

		.title {
			display: flex;
			align-items: center;
			font-size: 30rpx;
			color: #333;
			height: 86rpx;
			border-bottom: 1px solid #f5f5f5;
            font-weight: 400;
			padding: 0 24rpx;
			
			image {
				width: 32rpx;
				height: 32rpx;
				margin-right: 10rpx;
			}
		}

		.con {
			font-size: 26rpx;
			color: #666666;
			padding: 30rpx 24rpx;
		}
	}
	
	.logistics .logisticsCon {
		background-color: #fff;
	}
	
	.logistics .logisticsCon .company {
		height: 120rpx;
		margin: 0 0 45rpx 30rpx;
		padding-right: 30rpx;
		border-bottom: 1rpx solid #f5f5f5;
	}
	
	.logistics .logisticsCon .company .picTxt {
		width: 520rpx;
	}
	
	.logistics .logisticsCon .company .picTxt .iconfont {
		width: 50rpx;
		height: 50rpx;
		background-color: #666;
		text-align: center;
		line-height: 50rpx;
		color: #fff;
		font-size: 35rpx;
	}
	
	.logistics .logisticsCon .company .picTxt .text {
		width: 450rpx;
		font-size: 26rpx;
		color: #282828;
	}
	
	.logistics .logisticsCon .company .picTxt .text .name {
		color: #999;
	}
	
	.logistics .logisticsCon .company .picTxt .text .express {
		margin-top: 5rpx;
	}
	
	.logistics .logisticsCon .company .copy {
		font-size: 20rpx;
		width: 106rpx;
		height: 40rpx;
		text-align: center;
		line-height: 40rpx;
		border-radius: 20rpx;
		border: 1rpx solid #999;
	}
	
	.logistics .logisticsCon .item {
		padding: 0 40rpx;
		position: relative;
	}
	
	.logistics .logisticsCon .item .circular {
		width: 20rpx;
		height: 20rpx;
		border-radius: 50%;
		position: absolute;
		top: -1rpx;
		left: 31.5rpx;
		background-color: #ddd;
	}
	
	.logistics .logisticsCon .item .circular.on {
		background-color: $theme-color;
	}
	
	.logistics .logisticsCon .item .text.on-font {
		color: $theme-color;
	}
	
	.logistics .logisticsCon .item .text .data.on-font {
		color: $theme-color;
	}
	
	.logistics .logisticsCon .item .text {
		font-size: 26rpx;
		color: #666;
		width: 615rpx;
		border-left: 1rpx solid #e6e6e6;
		padding: 0 0 60rpx 38rpx;
	}
	
	.logistics .logisticsCon .item .text.on {
		border-left-color: #f8c1bd;
	}
	
	.logistics .logisticsCon .item .text .data {
		font-size: 24rpx;
		color: #999;
		margin-top: 10rpx;
	}
	
	.logistics .logisticsCon .item .text .data .time {
		margin-left: 15rpx;
	}
</style>