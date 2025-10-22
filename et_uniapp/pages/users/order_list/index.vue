<template>
	<view :data-theme="theme"> 
		<view class="bg_color">
			<uniNavBar background-color="#fff" color="#333333" :title="$t(`page.users.orderList.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
				<view slot="left" class="iconfont icon-dingbufanhui"></view>
				<view slot="right" class="iconfont icon-more"></view>
			</uniNavBar>
		</view>
		<view class='my-order'>
			<scroll-view class="scroll-view_x" scroll-x style="white-space: nowrap; vertical-align: middle;" show-scrollbar="false">
				<view class='nav'>
					<view class='item' :class='orderStatus==0 ? "on": ""' @click="statusClick(0)">
						<text>{{$t(`page.users.orderList.orderStatus[0].name`)}}</text>
						<text class='num'>({{orderData.unPaidCount || 0}})</text>
					</view>
					<text class='item' :class='orderStatus==1 ? "on": ""' @click="statusClick(1)">
						<text>{{$t(`page.users.orderList.orderStatus[1].name`)}}</text>
						<text class='num'>({{orderData.unShippedCount || 0}})</text>
					</text>
					<text class='item' :class='orderStatus==2 ? "on": ""' @click="statusClick(2)">
						<text>{{$t(`page.users.orderList.orderStatus[2].name`)}}</text>
						<text class='num '>({{orderData.receivedCount || 0}})</text>
					</text>
					<!-- <view class='item' :class='orderStatus==3 ? "on": ""' @click="statusClick(3)">
						<view>{{$t(`page.users.orderList.orderStatus[3].name`)}}</view>
					</view> -->
					<text class='item' :class='orderStatus==3 ? "on": ""' @click="statusClick(3)">
						<text>{{$t(`page.users.orderList.complete`)}}</text>
						<text class='num'>({{orderData.completeCount || 0}})</text>
					</text>
				</view>
			</scroll-view>
			
			<view class='list'>
				<view class='item' v-for="(item,index) in orderList" :key="index">
					<block v-if="orderStatus==0">
						<view v-for="(itemn,indexn) in item.orderList" :key="indexn">
							<view class='title acea-row row-between-wrapper'>
								<navigator :url="`/pages/merchant/home/index?id=${itemn.merId}`" hover-class="none">
									<view class="acea-row row-middle">
										<text class='iconfont icon-shangjiadingdan mr10'></text>
										<text class="mr10">{{itemn.merName}}</text>
										<text class='iconfont icon-gengduo'></text>
									</view>
								</navigator>
								<view class='font_color'>{{$t(`page.users.orderList.orderStatus[0].name`)}}</view>
							</view>
							<view @click='goOrderDetails(item.orderNo)' class='item-info acea-row row-between row-top' v-for="(items,indexs) in itemn.orderInfoList" :key="indexs">
								<view class='pictrue'>
									<easy-loadimage mode="widthFix" :image-src="items.image"></easy-loadimage>
								</view>
								<view class='text acea-row row-between'>
									<view class='name line2'>{{items.productName}}</view>
									<view class='money'>
										<view>{{shopPayCurrency}}{{items.price}}</view>
										<view>x{{items.payNum}}</view>
									</view>
								</view>
							</view>
							
						</view>
						<view class='totalPrice'>{{item.totalNum}} {{$t(`page.users.orderList.item`)}}，{{$t(`page.users.orderList.totalPay`)}}
							<text class='money'> {{shopPayCurrency}}{{item.payPrice}}</text>
						</view>
					</block>
					<view v-else>
						<view class='title acea-row row-between-wrapper'>
							<navigator :url="`/pages/merchant/home/index?id=${item.merId}`" hover-class="none">
								<view class="acea-row row-middle">
									<text class='iconfont icon-shangjiadingdan mr10'></text>
									<text class="mr10">{{item.merName}}</text>
									<text class='iconfont icon-gengduo'></text>
								    <!-- <view>{{item.createTime}}</view> -->
								</view>
							</navigator>
							<view class='font_color'>{{item.status | orderStatusFilter}}</view>
						</view>
						<view @click='goOrderDetails(item.orderNo)' class='item-info acea-row row-between row-top' v-for="(items,index) in item.orderInfoList" :key="index">
							<view class='pictrue'>
								<easy-loadimage mode="widthFix" :image-src="items.image"></easy-loadimage>
							</view>
							<view class='text acea-row row-between'>
								<view class='name line2'>{{items.productName}}</view>
								<view class='money'>
									<view>{{shopPayCurrency}}{{items.price}}</view>
									<view>x{{items.payNum}}</view>
								</view>
							</view>
						</view>
						<view class='totalPrice'>{{item.totalNum}} {{$t(`page.users.orderList.item`)}}，{{$t(`page.users.orderList.totalPay`)}}
							<text class='money'> {{shopPayCurrency}}{{item.payPrice}}</text>
						</view>
					</view>
					<view class='bottom acea-row row-right row-middle'>
						<view class='bnt cancelBnt' v-if="!item.paid" @click='cancelOrder(index,item.orderNo)'>{{$t(`page.users.orderList.cancelOrder`)}}</view>
						<view class='bnt bg_color' v-if="!item.paid" @click='goPay(item)'>{{$t(`page.users.orderList.pay`)}}</view>
						<view class='bnt bg_color' v-else-if="item.status== 0 || item.status== 1 || item.status== 3" @click='goOrderDetails(item.orderNo)'>{{$t(`page.users.orderList.viewDetails`)}}</view>
						<view class='bnt cancelBnt' v-if="item.status == 3" @click='delOrder(item.orderNo,index)'>{{$t(`page.users.orderList.delete`)}}</view>
					</view>
				</view>
			</view>
			
			<view class='loadingicon acea-row row-center-wrapper'>
				<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{orderList.length>0?loadTitle:''}}
			</view>
			<view class='noCart' v-if="orderList.length == 0 && isShow && !loading">
				<view class='pictrue text-center'>
					<image src='/static/images/noOrder.png'></image>
				</view>
				<text class="text-ccc">{{$t(`page.users.orderList.empty`)}}</text>
			</view>
		</view>
	
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
		<tui-modal :show="modal" @click="handleClick" @cancel="hide" :title="modelTitle" :content="modelContent"></tui-modal>
	</view>
</template>

<script>
	import {
		getOrderList,
		orderData,
		orderCancel,
		orderDel,
		orderAwaitPay,
		payPayment
	} from '@/api/order.js';
	import payment from '@/components/payment'; 
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import emptyPage from '@/components/emptyPage.vue'
	import tuiModal from "@/components/tui-modal/tui-modal"
	import {Debounce} from '@/utils/validate.js'
	
	const app = getApp();
	export default {
		components: {
			payment,
			emptyPage,
			tuiModal
		},
		data() {
			return {
				loading: false, //是否加载中
				loadend: false, //是否加载完毕
				loadTitle: this.$t(`page.goodsList.more`), //提示语
				orderList: [], //订单数组
				orderData: {}, //订单详细统计
				orderStatus: 0, //订单状态
				page: 1,
				limit: 20,
				payMode: [
					//预留以后多种方式支付
				],
				pay_close: false,
				pay_order_id: '',
				totalPrice: '0',
				isShow: false,
				theme:app.globalData.theme,
				rightDrawer: false,
				modelTitle:'',
				modelContent:'',
				modal: false,
				modelType:'',
				setting:{id:'',index:0},
				redirect: '',
				payItem: {},
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		computed: mapGetters(['isLogin', 'userInfo']),
		// 滚动监听
		onPageScroll(e) {
		   // 传入scrollTop值并触发所有easy-loadimage组件下的滚动监听事件
		   uni.$emit('scroll');
		},
		onLoad: function(options) {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.orderList.navTitle`)
			})
		},
		onShow() {
			let that = this;
			if (this.isLogin) {
				this.loadend = false;
				this.page = 1;
				this.$set(this, 'orderList', []);
				this.getOrderData();
				if(this.orderStatus === 0){
					this.getOrderAwaitPay();
				}else{
					this.getOrderList();
				}
			} else {
				toLogin();
			}
		},
		methods: {
			open(){
				this.rightDrawer = true
			},
			closeDrawer(e) {
				this.rightDrawer = false
				if(!e){
					this.rightDrawer = false
				}
			},
			/**
			 * 事件回调
			 * 
			 */
			onChangeFun: function(e) {
				let opt = e;
				let action = opt.action || null;
				let value = opt.value != undefined ? opt.value : null;
				(action && this[action]) && this[action](value);
			},
			/**
			 * 关闭支付组件
			 * 
			 */
			payClose: function() {
				this.pay_close = false;
			},
			/**
			 * 生命周期函数--监听页面加载
			 */
			onLoad: function(options) {
				if (options.status) this.orderStatus = Number(options.status);
			},
			/**
			 * 获取订单统计数据
			 * 
			 */
			getOrderData: function() {
				let that = this;
				orderData().then(res => {
					that.$set(that, 'orderData', res.data);
				})
			},
			/**
			 * 取消订单
			 * 
			 */
			cancelOrder: Debounce(function(index, order_id) {
				let that = this;
				that.modelTitle = this.$t(`message.login.prompt`);
				that.modelContent = this.$t(`page.orderDetails.confirmCancel`);;
				that.$set(that,'modelType','cancelOrder');
				that.setting.id = order_id;
				that.setting.index = index;
				that.modal = true;
				if (!order_id) return that.$util.Tips({
					title: this.$t('message.pay.errorOrder')
				});
			}),
			/**
			 * 打开支付组件
			 * 
			 */
			goPay:Debounce(function(item) {
				this.modelTitle = this.$t(`message.login.prompt`);
				this.modelContent = this.$t(`message.tips.surePay`);
				this.$set(this,'modelType','awaitPay');
				this.modal = true;
				this.payItem = item;
				this.redirect = item.redirect;
			}),
			/**
			 * 支付成功回调
			 * 
			 */
			pay_complete: function() {
				this.loadend = false;
				this.page = 1;
				this.$set(this, 'orderList', []);
				this.$set(this, 'pay_close', false);
				this.getOrderData();
				if(this.orderStatus === 0){
					this.getOrderAwaitPay();
				}else{
					this.getOrderList();
				}
			},
			/**
			 * 支付失败回调
			 * 
			 */
			pay_fail: function() {
				this.pay_close = false;
			},
			/**
			 * 去订单详情
			 */
			goOrderDetails: function(order_id) {
				if (!order_id) return this.$util.Tips({
					title: this.$t('message.pay.errorOrder')
				});
				uni.navigateTo({
					url: '/pages/order_details/index?order_id=' + order_id + '&orderStatus=' + this.orderStatus
				})
			},
			/**
			 * 切换类型
			 */
			statusClick: function(status) {
				if (status == this.orderStatus) return;
				this.orderStatus = status;
				this.loadend = false;
				this.page = 1;
				this.$set(this, 'orderList', []);
				if(this.orderStatus === 0){
					this.getOrderAwaitPay();
				}else{
					this.getOrderList();
				}
			},
			/**
			 * 待支付列表
			 */
			getOrderAwaitPay: function() {
				let that = this;
				if (that.loadend) return;
				if (that.loading) return;
				that.loading = true;
				that.loadTitle = this.$t(`page.goodsList.more`);
				orderAwaitPay({
					page: that.page,
					limit: that.limit,
				}).then(res => {
					let list = res.data.list || [];
					let loadend = list.length < that.limit;
					that.orderList = that.$util.SplitArray(list, that.orderList);
					that.$set(that, 'orderList', that.orderList);
					that.loadend = loadend;
					that.loading = false;
					that.loadTitle = loadend ? "" : this.$t('page.goodsList.more');
					that.page = that.page + 1;
					that.isShow = true;
				}).catch(err => {
					that.loading = false;
					that.loadTitle = this.$t('page.goodsList.more');
				})
			},
			/**
			 * 获取订单列表
			 */
			getOrderList: function() {
				let that = this;
				if (that.loadend) return;
				if (that.loading) return;
				that.loading = true;
				that.loadTitle = this.$t(`page.goodsList.more`);
				getOrderList({
					type: that.orderStatus,
					page: that.page,
					limit: that.limit,
				}).then(res => {
					let list = res.data.list || [];
					let loadend = list.length < that.limit;
					that.orderList = that.$util.SplitArray(list, that.orderList);
					that.$set(that, 'orderList', that.orderList);
					that.loadend = loadend;
					that.loading = false;
					that.loadTitle = loadend ? "" : this.$t('page.goodsList.more');
					that.page = that.page + 1;
					that.isShow = true;
				}).catch(err => {
					that.loading = false;
					that.loadTitle = this.$t('page.goodsList.more');
				})
			},

			/**
			 * 删除订单
			 */
			delOrder: Debounce(function(order_id, index) {
				let that = this;
				that.modelTitle = this.$t(`message.login.prompt`);
				that.modelContent = this.$t(`message.tips.sureDel`);
				that.$set(that,'modelType','delOrder');
				that.setting.id = order_id;
				that.setting.index = index;
				that.modal = true;
			}),
			returns(){
				uni.navigateBack()
			},
			hide() {
				this.modal = false;
			},
			handleClick(e){
				let index = e.index,that = this;
				if(index === 1 && that.modelType == 'cancelOrder'){
					uni.showLoading({
						title: this.$t(`message.tips.loding`)
					});
					orderCancel(that.setting.id).then(res => {
						uni.hideLoading();
						return that.$util.Tips({
							title: that.$t(`message.login.calSU`),
							icon: 'success'
						}, function() {
							that.orderList.splice(that.setting.index, 1);
							that.$set(that, 'orderList', that.orderList);
							that.$set(that.orderData, 'unPaidCount', that.orderData.unPaidCount - 1);
							that.getOrderData();
						});
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					});
					this.modal = false;
				}else if(index === 1 && that.modelType == 'delOrder'){
					orderDel(that.setting.id).then(res => {
						that.orderList.splice(that.setting.index, 1);
						that.$set(that, 'orderList', that.orderList);
						that.$set(that.orderData, 'completeCount', that.orderData.completeCount - 1);
						that.getOrderData();
						return that.$util.Tips({
							title: that.$t(`message.login.delSU`),
							icon: 'success'
						});
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					})
					this.modal = false;
				}else if(index === 1 && that.modelType == 'awaitPay'){
					that.$Order.goPay({
						orderNo: that.payItem.orderNo,
						payChannel: 'mobile',
						payType: that.payItem.payType
					});
					// if(that.payItem.payType === 'stripe'){
						
					// }else{
					// 	window.location.href = this.redirect;
					// }
				}else if(index === 0){
					that.modal = false;
				}
			},
		},
		onReachBottom: function() {
			if(this.orderStatus === 0){
				this.getOrderAwaitPay();
			}else{
				this.getOrderList();
			}
		}
	}
</script>

<style scoped lang="scss">
	.icon-shangjiadingdan{
		font-size: 28rpx;
	}
	.icon-gengduo{
		font-size: 10rpx;
	}
	.my-order .header {
		height: 250rpx;
		padding: 0 30rpx;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
	.my-order .header .picTxt {
		height: 190rpx;
	}

	.my-order .header .picTxt .text {
		color: rgba(255, 255, 255, 0.8);
		font-size: 26rpx;
		font-family: 'Guildford Pro';
	}

	.my-order .header .picTxt .text .name {
		font-size: 34rpx;
		font-weight: bold;
		color: #fff;
		margin-bottom: 20rpx;
	}

	.my-order .header .picTxt .pictrue {
		width: 122rpx;
		height: 109rpx;
	}

	.my-order .header .picTxt .pictrue image {
		width: 100%;
		height: 100%;
	}

	.my-order .nav {
		background-color: #fff;
		border-top: 1px solid #F5F5F5;
		// margin: -60rpx 0 0;
		
	}

	.my-order .nav .item {
		text-align: center;
		font-size: 26rpx;
		color: #282828;
		padding: 26rpx 30rpx;
		display: inline-block;
		background-color: #fff;
	}

	.my-order .nav .item.on {
		/* #ifdef H5 || MP */
		font-weight: bold;
		/* #endif */
		/* #ifdef APP-PLUS */
		color: #000;
		/* #endif */
		position: relative;
	}
	.my-order .nav .item.on ::after{
		content: '';
		width: 78rpx;
		height: 4rpx;
		@include main_bg_color(theme);
		position: absolute;
		bottom: 2rpx;
		left: 30rpx;
	}
	.my-order .nav .item .num {
		margin-top: 18rpx;
	}

	.my-order .list {
		width: 690rpx;
		margin: 14rpx auto 0 auto;
	}

	.my-order .list .item {
		background-color: #fff;
		border-radius: 14rpx;
		margin-bottom: 14rpx;
	}

	.my-order .list .item .title {
		height: 84rpx;
		padding: 0 24rpx;
		border-bottom: 1rpx solid #eee;
		font-size: 28rpx;
		color: #282828;
	}

	.my-order .list .item .title .sign {
		font-size: 24rpx;
		padding: 0 13rpx;
		height: 36rpx;
		margin-right: 15rpx;
		border-radius: 18rpx;
		@include coupons_border_color(theme);
		@include main_color(theme);
	}

	.my-order .list .item .item-info {
		padding: 0 24rpx;
		margin-top: 22rpx;
	}

	.my-order .list .item .item-info .pictrue {
		width: 120rpx;
		height: 120rpx;
	}

	.my-order .list .item .item-info .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 14rpx;
	}

	.my-order .list .item .item-info .text {
		width: 500rpx;
		font-size: 28rpx;
		color: #999;
	}

	.my-order .list .item .item-info .text .name {
		width: 350rpx;
		color: #282828;
	}

	.my-order .list .item .item-info .text .money {
		text-align: right;
	}
	.font_color{
		@include main_color(theme);
	}
	.my-order .list .item .totalPrice {
		font-size: 26rpx;
		color: #282828;
		text-align: right;
		margin: 27rpx 0 0 30rpx;
		padding: 0 30rpx 30rpx 0;
		border-bottom: 1rpx solid #eee;
	}

	.my-order .list .item .totalPrice .money {
		font-size: 28rpx;
		font-weight: bold;
		@include price_color(theme);
	}

	.my-order .list .item .bottom {
		height: 107rpx;
		padding: 0 30rpx;
	}

	.my-order .list .item .bottom .bnt {
		// width: 176rpx;
		height: 60rpx;
		text-align: center;
		line-height: 60rpx;
		color: #fff;
		border-radius: 50rpx;
		font-size: 27rpx;
		padding: 0 30rpx;
	}	

	.my-order .list .item .bottom .bnt.cancelBnt {
		border: 1rpx solid #ddd;
		color: #aaa;
	}

	.my-order .list .item .bottom .bnt~.bnt {
		margin-left: 17rpx;
	}

	.noCart {
		margin-top: 171rpx;
		padding-top: 0.1rpx;
	}

	.noCart .pictrue {
		width: 414rpx;
		height: 336rpx;
		margin: 78rpx auto 56rpx auto;
	}

	.noCart .pictrue image {
		width: 100%;
		height: 100%;
	}
	/deep/.tui-red{
		@include main_bg_color(theme);
	}
	/deep/.tui-red-outline{
		@include main_color(theme);
		@include coupons_border_color(theme);
	}
</style>
