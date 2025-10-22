<template>
	<view>
		<uniNavBar background-color="#fff" color="#333" :title="$t(`page.users.userReturnList.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
			<view slot="left" class="iconfont icon-dingbufanhui"></view>
			<view slot="right" class="iconfont icon-more"></view>
		</uniNavBar>
		<view class='return-list pad30' v-if="orderList.length">
			<view class='goodWrapper borRadius14' v-for="(item,index) in orderList" :key="index" @click='goOrderDetails(item.refundOrderNo)'>
			   <view class='orderNum'>
					<view class="tit">{{$t(`page.users.userReturnList.orderId`)}}:</view>
					<view class="no">{{item.refundOrderNo}}</view>
				</view>
				<view class='item acea-row row-between-wrapper' v-for="(items,index) in item.orderInfoList" :key="index">
					<view class='pictrue'>
						<image :src='items.image'></image>
					</view>
					<view class='text'>
						<view class='acea-row row-between-wrapper'>
							<view class='name line1'>{{items.productName}}</view>
							<view class='money'>{{shopPayCurrency}}{{items.price}}</view>
						</view>
						<view class='acea-row row-between-wrapper'>
							<view class='attr line1' v-if="items.sku">{{items.sku}}</view>
							<view class='num'>x {{items.payNum}}</view>
						</view>
						<view class="acea-row align-center">
							<block v-if="item.refundStatus==0 || item.refundStatus==2">
								<view class='iconfont icon-tuikuanzhong powder mr8' ></view>
								<view class="powder">{{$t(`page.users.userReturnList.refunding`)}}</view>
							</block>
							<block v-if="item.refundStatus==3">
								<view class='iconfont icon-yituikuan hui mr8'></view>
								<view class="hui">{{$t(`page.users.userReturnList.refunded`)}}</view>
							</block>
							<block v-if="item.refundStatus==1">
								<view class='iconfont icon-yituikuan hui mr8'></view>
								<view class="hui">{{$t(`message.tips.noadopt`)}}</view>
							</block>
						</view>
					</view>
				</view>
				<view class='totalSum'>
					<text>{{item.totalNum || 0}} {{$t(`page.users.userReturnList.item`)}}</text>
					<text>{{$t(`page.users.userReturnList.total`)}} <text class=' price'>{{shopPayCurrency}} {{item.refundPrice}}</text></text>
				</view>
			</view>
		</view>
		<view class='loadingicon acea-row row-center-wrapper'>
			<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{orderList.length>0?loadTitle:''}}
		</view>
		<view class='noCart' v-if="orderList.length == 0 && !loading">
			<view class='pictrue text-center'>
				<image src='/static/images/noOrder.png'></image>
			</view>
			<text class="text-ccc">{{$t(`page.users.orderList.empty`)}}</text>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
</template>

<script>
	import emptyPage from '@/components/emptyPage.vue'
	import {orderRefundList} from '@/api/order.js';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	let app = getApp();
	export default {
		components: {
			emptyPage
		},
		data() {
			return {
				loading: false,
				loadend: false,
				loadTitle: this.$t('page.goodsList.more'), //提示语
				orderList: [], //订单数组
				orderStatus: -3, //订单状态
				page: 1,
				limit: 20,
				isAuto: false, //没有授权的不会自动授权
				isShowAuth: false, //是否隐藏授权
				rightDrawer: false,
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		computed: mapGetters(['isLogin']),
		watch:{
			isLogin:{
				handler:function(newV,oldV){
					if(newV){
						this.getOrderList();
					}
				},
				deep:true
			}
		},
		onLoad() {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.userReturnList.navTitle`)
			})
			if (this.isLogin) {
				this.getOrderList();
			} else {
				toLogin();
			}
		},
		/**
		 * 页面上拉触底事件的处理函数
		 */
		onReachBottom: function() {
			this.getOrderList();
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
			returns(){
				uni.navigateBack()
			},
			/**
			 * 去订单详情
			 */
			goOrderDetails: function(order_id) {
				if (!order_id) return this.$util.Tips({
					title: this.$t('message.pay.errorOrder')
				});
				uni.navigateTo({
					url: '/pages/order_details/index?order_id=' + order_id + '&isReturen=1'
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
				that.loadTitle = "";
				orderRefundList({
					page: that.page,
					limit: that.limit,
				}).then(res => {
					let list = res.data.list || [];
					let loadend = list.length < that.limit;
					that.orderList = that.$util.SplitArray(list, that.orderList);
					that.$set(that,'orderList',that.orderList);
					that.loadend = loadend;
					that.loading = false;
					that.loadTitle = loadend ? this.$t('page.goodsList.nono') : this.$t('page.goodsList.more');
					that.page = that.page + 1;
				}).catch(err => {
					that.loading = false;
					that.loadTitle = this.$t(`page.goodsList.more`);
				});
			}
		}
	}
</script>

<style lang="scss" scoped>
	.mr8{
		margin-right: 8rpx;
	}
	.return-list .goodWrapper {
		background-color: #fff;
		margin-top: 20rpx;
		position: relative;
		padding: 0rpx 24rpx;
	}

	.return-list .goodWrapper .orderNum {
		border-bottom: 1px solid #eee;
		height: 120rpx;
		padding-top: 24rpx;
		.tit{
			font-size: 22rpx;
			color: #999999;
		}
		.no{
			font-size: 30rpx;
			color: #333333;
		}
	}

	.return-list .goodWrapper .item {
		border-bottom: 0;
		.name{
			width: 340rpx !important;
		}
		.money{
			color: #999999;
			font-weight: 26rpx;
			margin-top: 0;
		}
		.attr{
			font-size: 24rpx;
			color: #999999;
			margin-top: 0;
		}
	}

	.return-list .goodWrapper .totalSum {
		padding: 0 0 32rpx 0;
		// text-align: right;
		font-size: 26rpx;
		color: #282828;
		display: flex;
		justify-content: space-between;
	}

	.return-list .goodWrapper .totalSum .price {
		font-size: 28rpx;
		font-weight: bold;
		@include price_color(theme);
	}
    .hui{
		color: #CCCCCC;
		font-size: 24rpx;
	}
	.return-list .goodWrapper .powder {
		@include price_color(theme);
		//font-size: 24rpx;
	}
	.align-center{
		margin-top: 32rpx;
	}
</style>
