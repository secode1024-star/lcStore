<template>
	<view :data-theme="theme">
		<view :class='isGoodsReturn ? "bg-gray":"bg_color"'>
			<uniNavBar background-color="transparent" color="#fff" :title="$t(`page.orderDetails.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
				<view slot="left" class="iconfont icon-dingbufanhui"></view>
				<view slot="right" class="iconfont icon-more"></view>
			</uniNavBar>
		</view>
		<view class='order-details'>
			<!-- 给header上与data上加on为退款订单-->
			<view class='header bg_color' :class='isGoodsReturn ? "on":""'>
				<view v-if="!PayerID" class='picTxt acea-row row-middle'>
					<view class='pictrue' v-if="isGoodsReturn==false && orderStatus!=0">
						<image :src="statusPic(orderInfo.status)"></image>
					</view>
					<view class='pictrue' v-if="isGoodsReturn==false && orderStatus==0">
						<image src="@/static/images/daifukuan.gif"></image>
					</view>
					<view class='data' :class='isGoodsReturn ? "on":""'>
						<block v-if="isGoodsReturn">
							<view class='state'>{{orderInfo.refundStatus | refundStatusFilter}}</view>
						</block>
						
						<block v-if="!isGoodsReturn">
							<view v-show="orderStatus==0" class='state'>{{$t(`page.user.orderStatus[0].name`)}}</view>
							<view class='state'>{{orderInfo.status | orderStatusFilter}}</view>
						</block>
					</view>
				</view>
			</view>

			<view class="pad30">
				<!-- 退款状态头部信息 "-->
				<view class='nav refund' v-if="isGoodsReturn">
					<view class="title">
						<image src="/static/images/shuoming.png" mode=""></image>
						{{orderInfo.refundStatus==0?$t(`page.users.userReturnList.examine`): orderInfo.refundStatus==1?$t(`page.users.userReturnList.refuse`):orderInfo.refundStatus==2?$t(`page.users.userReturnList.refunding`):$t(`page.users.userReturnList.refunded`)}}
					</view>
					<view class="con pad30">
					    {{orderInfo.refundStatus==0 ? $t(`page.users.userReturnList.examineInfo`): orderInfo.refundStatus==1? $t(`page.users.userReturnList.refuseReason`) + orderInfo.refundReason : $t(`page.users.userReturnList.refuseReason2`)}}
					</view>
				</view>
				<view v-if="!isGoodsReturn" class='nav address'>
					<view class='name'>{{orderInfo.realName}}<text class='phone'>{{orderInfo.userPhone}}</text></view>
					<view>{{orderInfo.userAddress}}</view>
				</view>
				<view v-if="orderStatus==0">
					<block v-for="(item, index) in orderInfo.orderList">
						<orderGoods :evaluate='evaluate' :orderInfo="item" :orderId="order_id" :ids="id" :uniId="uniId" :cartInfo="item.orderInfoList"
							:jump="true"></orderGoods>
					</block>
				</view>
				<view v-else>
					<orderGoods :evaluate='evaluate' :orderInfo="orderInfo" :productType="orderInfo.type" :orderId="order_id" :ids="id" :uniId="uniId" :cartInfo="cartInfo"
						:jump="true"></orderGoods>
				</view>
			</view>
			<view class="pad30">
				<view class='wrapper borRadius14'>
					<view class='item acea-row row-between'>
						<view>{{$t(`page.orderDetails.orderId`)}}：</view>
						<text class="text-overflow">{{isGoodsReturn?orderInfo.merOrderNo:orderInfo.orderNo}}</text>
						<text class='copy copy-data' :data-clipboard-text="isGoodsReturn?orderInfo.merOrderNo:orderInfo.orderNo" >{{$t(`page.orderDetails.copy`)}}</text>
					</view>
					<view v-show="isGoodsReturn" class='item acea-row row-between'>
						<view>{{$t(`page.users.userReturnList.orderId`)}}：</view>
						<text class="text-overflow">{{orderInfo.refundOrderNo}}</text>
						<text class='copy copy-data' :data-clipboard-text="orderInfo.refundOrderNo">{{$t(`page.orderDetails.copy`)}}</text>
					</view>
					<view class='item acea-row row-between'>
						<view>{{$t(`page.orderDetails.orderTime`)}}：</view>
						<view class='conter'>{{orderInfo.createTime}}</view>
					</view>
					<view v-if="orderInfo.refundTime" class='item acea-row row-between'>
						<view>{{$t(`page.orderDetails.refundTime`)}}：</view>
						<view class='conter'>{{orderInfo.refundTime}}</view>
					</view>
					<view v-if="!isGoodsReturn" class='item acea-row row-between'>
						<view>{{$t(`page.orderDetails.payStatus`)}}：</view>
						<view class='conter' v-if="orderInfo.paid">{{$t(`page.orderDetails.payTrue`)}}</view>
						<view class='conter' v-else>{{$t(`page.orderDetails.payFalse`)}}</view>
					</view>
					<view v-if="!isGoodsReturn" class='item acea-row row-between'>
						<view>{{$t(`page.orderDetails.payType`)}}：</view>
						<view class='conter'>{{orderInfo.payType}}</view>
					</view>
					<view class='item flex justify-between' v-if="orderInfo.userRemark">
						<view>{{$t(`page.orderDetails.message`)}}：</view>
						<view class="flex align-center" v-show="isShow" @click="isShow=!isShow">
							<view class='conter' style="width: 480rpx;">{{orderInfo.userRemark}}</view>
							<text class="iconfont icon-xuanze" style="font-size: 12px;"></text>
						</view>
						<view v-show="!isShow" @click="isShow=!isShow">
							<view class='mark_show' >{{orderInfo.userRemark}}</view>
						</view>
					</view>
				</view>
				<!-- 退款原因 "-->
				<view v-if="isGoodsReturn" class='wrapper borRadius14' >
					<view class='item acea-row row-between' v-if="orderInfo.refundReasonWap">
						<view>{{$t(`page.orderDetails.returnReason`)}}：</view>
						<view class='conter'>{{orderInfo.refundReasonWap}}</view>
					</view>
					<view class='item acea-row row-between' v-if="orderInfo.refundReasonWapExplain">
						<view>{{$t(`page.orderDetails.returnMsg`)}}：</view>
						<view class='conter'>{{orderInfo.refundReasonWapExplain}}</view>
					</view>
					<view class='item acea-row row-between' v-if="orderInfo.refundReasonWapImg.length>0">
						<view>{{$t(`page.orderDetails.returnImg`)}}：</view>
						<view class="acea-row refundReasonWapImg">
							<view class="pictrue mr10 mb4" v-for="(itemn, indexn) in refundReasonWapImg" :key="indexn">
								<image :src="itemn" class="image" @click='getpreviewImage(indexn)'></image>
							</view>
						</view>
					</view>
				</view>
				<view class='wrapper borRadius14'>
					<view v-if="!isGoodsReturn" class='item acea-row row-between borders'>
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
					<view v-if="!isGoodsReturn" class='actualPay acea-row row-right'>{{$t(`page.orderDetails.actualPayment`)}}：<text
							class='money'>{{shopPayCurrency}}{{orderInfo.payPrice}}</text></view>
					<view v-else class='actualPay acea-row row-right' style="padding-top: 0;">{{$t(`page.users.userReturnList.total`)}}：<text
							class='money'>{{shopPayCurrency}}{{orderInfo.refundPrice}}</text></view>		
				</view>
				<view style='height:120rpx;'></view>
				<view class='footer acea-row row-right row-middle' v-if="isGoodsReturn==false">
					<view class="qs-btn" v-if="!orderInfo.paid" @click.stop="cancelOrder">{{$t(`page.orderDetails.cancelOrder`)}}</view>
					<view class='bnt bg_color' v-if="!orderInfo.paid" @tap='pay_open(order_id)'>{{$t(`page.orderDetails.nowPay`)}}</view>
					<navigator hover-class="none" :url="'/pages/users/goods_return/index?orderId='+ order_id"
						class='bnt cancel' v-else-if="orderInfo.paid === true && orderInfo.refundStatus === 0">{{$t(`page.orderDetails.refund`)}}
					</navigator>
					<navigator class='bnt cancel' v-if="orderInfo.status >0"
						hover-class='none' :url="'/pages/users/goods_logistics/index?orderId='+ order_id">{{$t(`page.orderDetails.logistics`)}}
					</navigator>
					<view class='bnt bg_color' v-if="orderInfo.status==1" @tap='confirmOrder'>{{$t(`page.orderDetails.confirm`)}}</view>
					<view class='bnt cancel' v-if="orderInfo.status==3" @tap='delOrder'>{{$t(`page.orderDetails.delete`)}}</view>
					<view class='bnt bg_color' v-if="orderInfo.status==3" @tap='goOrderConfirm'>{{$t(`page.orderDetails.again`)}}</view>
				</view>
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
		getOrderDetail,
		orderTake,
		orderDel,
		orderCancel,
		qrcodeApi,
		orderMasterDetail,
		orderReplyDetail
	} from '@/api/order.js';
	import {
		postCartAdd
	} from '@/api/store.js';
	import payment from '@/components/payment';
	import orderGoods from "@/components/orderGoods";
	import tuiModal from "@/components/tui-modal/tui-modal"
	import ClipboardJS from "@/plugin/clipboard/clipboard.js";
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import {Debounce} from '@/utils/validate.js'
	const app = getApp();
	export default {
		components: {
			payment,
			orderGoods,
			tuiModal
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
				system_store: {},
				isGoodsReturn: false, //是否为退款订单
				status: {}, //订单底部按钮状态
				isClose: false,
				payMode: [
					//预留以后多种支付方式
				],
				pay_close: false,
				pay_order_id: '',
				totalPrice: '0',
				id: 0, //订单id
				uniId: '',
				utils: this.$util,
				againStatus:0,
				type: 'normal',
				isShow:true,
				theme:app.globalData.theme,
				rightDrawer: false,
				modelTitle:'',
				modelContent:'',
				modal: false,
				modelType:'',
				orderStatus: null,
				refundReasonWapImg: [],
				PayerID: '',
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		computed: mapGetters(['isLogin', 'chatUrl', 'userInfo']),
		onLoad: function(options) {
			uni.setNavigationBarTitle({
				title: this.$t(`page.orderDetails.navTitle`)
			})
			options.type == undefined || options.type == null ? this.type = 'normal' : this.type = options.type;
			if (!options.order_id) return this.$util.Tips({
				title: '缺少参数'
			}, {
				tab: 3,
				url: 1
			});
			this.order_id = options.order_id;
			this.isReturen = Number(options.isReturen) || 0;
			this.orderStatus = options.orderStatus || 1;
			this.PayerID = options.PayerID || '';
			if (this.isLogin) {
				if(this.isReturen === 1){
					this.isGoodsReturn = true;
					uni.setNavigationBarColor({
					    frontColor: '#fff',
					    backgroundColor: '#666666'
					})
					this.getOrderReplyInfo()
				}else{
					if(this.orderStatus==0){
						this.getOrderMasterInfo();
					}else{
						this.getOrderInfo();
					}
				}
			} else {
				toLogin();
			}
		},
		// 滚动监听
		onPageScroll(e) {
		   // 传入scrollTop值并触发所有easy-loadimage组件下的滚动监听事件
		   uni.$emit('scroll');
		},
		onHide: function() {
			this.isClose = true;
		},
		onReady: function() {
			// #ifdef H5
			this.$nextTick(function() {
				const clipboard = new ClipboardJS(".copy-data");
				clipboard.on("success", () => {
					this.$util.Tips({
						title: '复制成功'
					});
				});
			});
			// #endif
			 
		},
		methods: {
			getpreviewImage: function(indexn) {
				uni.previewImage({
					urls: this.refundReasonWapImg,
					current: indexn
				});
			},
			statusPic(status) {
			  const statusMap = {
			   0: '/static/images/daifahuo.gif',
			   1: '/static/images/daishouhuo.gif',
			   3: '/static/images/yiwancheng.gif'
			  }
			  return statusMap[status]
			},
			open(){
				this.rightDrawer = true
			},
			closeDrawer(e) {
				this.rightDrawer = false
				if(!e){
					this.rightDrawer = false
				}
			},
			returns(){
				uni.navigateTo({
					url:"/pages/users/order_list/index"
				})
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
			 * 拨打电话
			 */
			makePhone: function() {
				uni.makePhoneCall({
					phoneNumber: this.system_store.phone
				})
			},
			/**
			 * 关闭支付组件
			 * 
			 */
			payClose: function() {
				this.pay_close = false;
			},
			/**
			 * 打开支付组件
			 * 
			 */
			pay_open: function() {
				this.modelTitle = this.$t(`message.login.prompt`);
				this.modelContent = this.$t(`message.tips.surePay`);
				this.$set(this,'modelType','awaitPay');
				this.modal = true;
			},
			/**
			 * 支付成功回调
			 * 
			 */
			pay_complete: function() {
				this.pay_close = false;
				this.pay_order_id = '';
				if(this.isReturen === 1){
					this.getOrderReplyInfo()
				}else{
					if(this.isReturen === 1){
						this.getOrderReplyInfo()
					}else{
						if(this.orderStatus==0){
							this.getOrderMasterInfo();
						}else{
							this.getOrderInfo();
						}
					}
				}
			},
			/**
			 * 支付失败回调
			 * 
			 */
			pay_fail: function() {
				this.pay_close = false;
				this.pay_order_id = '';
			},
			/**
			 * 退款订单详情
			 * 
			 */
			getOrderReplyInfo: function() {
				let that = this;
				uni.showLoading({
					title: this.$t(`message.tips.loding`)
				});
				orderReplyDetail(that.order_id).then(res => {
					uni.hideLoading();
					that.$set(that, 'orderInfo', res.data);
					that.$set(that, 'id', res.data.id);
					that.$set(that, 'cartInfo', res.data.orderInfoList);
					that.refundReasonWapImg = res.data.refundReasonWapImg?res.data.refundReasonWapImg.split(','):[]
					that.isGoodsReturn = true;
					uni.setNavigationBarColor({
					    frontColor: '#fff',
					    backgroundColor: '#666666'
					})
				}).catch(err => {
					uni.hideLoading();
					that.$util.Tips({
						title: err
					}, '/pages/users/order_list/index');
				});
			},
			/**
			 * 获取待支付订单详细信息，主订单
			 * 
			 */
			getOrderMasterInfo: function() {
				let that = this;
				uni.showLoading({
					title: this.$t(`message.tips.loding`)
				});
				orderMasterDetail(that.order_id).then(res => {
					uni.hideLoading();
					that.$set(that, 'orderInfo', res.data);
					that.$set(that, 'id', res.data.id);
					that.$set(that, 'cartInfo', res.data.orderList);
				}).catch(err => {
					uni.hideLoading();
					that.$util.Tips({
						title: err
					}, '/pages/users/order_list/index');
				});
			},
			/**
			 * 获取订单详细信息
			 * 
			 */
			getOrderInfo: function() {
				let that = this;
				uni.showLoading({
					title: this.$t(`message.tips.loding`)
				});
				getOrderDetail(that.order_id).then(res => {
					uni.hideLoading();
					that.$set(that, 'orderInfo', res.data);
					that.$set(that, 'evaluate', res.data.status == 2 ? 2 : 0);
					that.$set(that, 'system_store', res.data.systemStore);
					that.$set(that, 'id', res.data.id);
					that.$set(that, 'cartInfo', res.data.orderInfoList);
					if(res.data.combinationId > 0 || res.data.bargainId > 0 ||res.data.seckillId > 0 ){
						this.againStatus = 1;
					}
				}).catch(err => {
					uni.hideLoading();
					that.$util.Tips({
						title: err
					}, '/pages/users/order_list/index');
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
			/**
			 * 设置底部按钮
			 * 
			 */
			getOrderStatus: function() {
				let orderInfo = this.orderInfo || {},
					_status = orderInfo.pstatus || {
						type: 0
					},
					status = {};
				let type = parseInt(_status.type),delivery_type = orderInfo.deliveryType;
				status = {
					type: type == 9 ? -9 : type,
					class_status: 0
				};
				if (type == 2 && delivery_type == 'express') status.class_status = 2; //查看物流
				if (type == 2) status.class_status = 3; //确认收货
				if (type == 4 || type == 0) status.class_status = 4; //删除订单
				if (type == 3 || type == 4) status.class_status = 5; //再次购买
				this.$set(this, 'status', status);
			},
			/**
			 * 再此购买
			 * 
			 */
			goOrderConfirm: Debounce(function() {
				uni.showLoading({
					title: this.$t(`message.tips.loding`)
				});
				let storeCartListRequest = []
				let that = this;
				this.cartInfo.map(item => {
					storeCartListRequest.push({
						productId: parseFloat(item.productId),
						productAttrUnique:item.attrValueId,
						cartNum: parseFloat(item.payNum)
					})
				})
				postCartAdd(storeCartListRequest).then(function(res) {
						uni.navigateTo({
							url: '/pages/order_addcart/order_addcart'
						})
					})
					.catch(res => {
						return this.$util.Tips({
							title: res
						});
					});
			}),
			
			//确认收货
			confirmOrder: Debounce(function() {
				let that = this;
				that.modelTitle = this.$t(`page.orderDetails.confirm`);
				that.modelContent = this.$t(`page.orderDetails.confirmInfo`);
				that.$set(that,'modelType','confirmOrder');
				that.modal = true;
			}),
			//删除订单
			delOrder: Debounce(function() {
				let that = this;
				that.modelTitle = this.$t(`message.login.prompt`);
				that.modelContent = this.$t(`page.orderDetails.confirmDel`);
				that.$set(that,'modelType','delOrder');
				that.modal = true;
			}),
			//取消订单
			cancelOrder:Debounce(function(){
				let that = this;
				that.modelTitle = this.$t(`message.login.prompt`); 
				that.modelContent = this.$t(`page.orderDetails.confirmCancel`);
				that.$set(that,'modelType','cancelOrder');
				that.modal = true;
			}),
			handleClick(e){
				let index = e.index,that = this;
				if(index === 1){
					switch (that.modelType) {
						case 'confirmOrder':
							orderTake(that.order_id).then(res => {
								return that.$util.Tips({
									title: this.$t(`message.login.operationSU`),
									icon: 'success'
								}, function() {
									if(that.isReturen === 1){
										that.getOrderReplyInfo()
									}else{
										if(that.orderStatus==0){
											that.getOrderMasterInfo();
										}else{
											that.getOrderInfo();
										}
									}
								});
							}).catch(err => {
								return that.$util.Tips({
									title: err
								});
							})
							break;
						case 'delOrder':
							orderDel(that.order_id).then(res => {
								return that.$util.Tips({
									title: this.$t(`message.login.delSU`),
									icon: 'success'
								}, {
									tab: 4,
									url: '../users/order_list/index'
								});
							}).catch(err => {
								return that.$util.Tips({
									title: err
								});
							});
							break;
						case 'cancelOrder':
							orderCancel(that.order_id).then((data) => {
								that.$util.Tips({
									title: this.$t(`message.login.calSU`)
								}, {
									tab: 4,
									url: '../users/order_list/index'
								})
							})
							.catch(err => {
								that.$util.Tips({
									title: err.message
								})
							});
							break;
						case 'awaitPay':
							that.$Order.goPay({
								orderNo: that.orderInfo.orderNo,
								payChannel: 'mobile',
								payType: that.orderInfo.payType
							});
							//window.location.href = this.orderInfo.redirect;
							break;
					}
				}
				this.hide();
			},
			hide() {
				this.modal = false;
			},
		}
	}
</script>

<style scoped lang="scss">
	.mb4{
		margin-bottom: 10rpx;
	}
	.refundReasonWapImg{
		justify-content: end;
		width: 71%;
	}
	.userRemark{
		color: #666666;
	}
	.borders{
		border-bottom: 1rpx solid #eee;
		padding-bottom: 30rpx;
	}
	.pictrue {
		width: 80rpx;
		height: 80rpx;
		image {
			width: 100%;
			height: 100%;
		}
	}
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
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
		font-size: 24rpx;
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
	.order-details .header {
		height: 250rpx;
		padding: 0 30rpx;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
	.bg-gray{
		background-color: #666 !important;
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
		color: #666666;
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
	/deep/.tui-red{
		@include main_bg_color(theme);
	}
	/deep/.tui-red-outline{
		@include main_color(theme);
		@include coupons_border_color(theme);
	}
</style>