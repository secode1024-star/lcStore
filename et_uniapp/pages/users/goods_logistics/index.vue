<template>
	<view>
		<uniNavBar background-color="#fff" color="#000" :title="$t(`page.users.logistics.navTitle`)" :border='false'
			@clickLeft='returns' @clickRight="open">
			<view slot="left" class="iconfont icon-dingbufanhui"></view>
			<view slot="right" class="iconfont icon-more"></view>
		</uniNavBar>
		<view class='logistics'>
			<view class='logisticsCon'>
				<view class='company acea-row row-between-wrapper'>
					<view class='picTxt acea-row row-between-wrapper'>
						<view class='iconfont icon-wuliu'></view>
						<view class='text'>
							<view><text class='name line1'>{{$t(`page.users.logistics.expName`)}}：</text> {{orderInfo.expName}}</view>
							<view class='express line1'><text class='name'>{{$t(`page.users.logistics.expNo`)}}：</text> {{orderInfo.expNo}}</view>
						</view>
					</view>
					<view class='copy copy-data' :data-clipboard-text="orderInfo.expNo">{{$t(`page.orderDetails.copy`)}}</view>
				</view>
				<view class='item' v-for="(item,index) in expressList" :key="index">
					<view class='circular' :class='index === 0 ? "on":""'></view>
					<view class='text' :class='index===0 ? "on-font on":""'>
						<view>{{item.AcceptStation}}</view>
						<view class='data' :class='index===0 ? "on-font on":""'>{{item.AcceptTime}}</view>
					</view>
				</view>
			</view>
			<recommend v-if="expressList.length== 0 && isloading" ref="recommendIndex" :shopPayCurrency="shopPayCurrency"></recommend>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
</template>

<script>
	import {
		express
	} from '@/api/order.js';
	import {
		//getProductHot
	} from '@/api/store.js';
	import ClipboardJS from "@/plugin/clipboard/clipboard.js";
	import {
		toLogin
	} from '@/libs/login.js';
	import {
		mapGetters
	} from "vuex";
	let app = getApp();
	export default {
		data() {
			return {
				orderId: '',
				orderInfo: {},
				expressList: [],
				hostProduct: [],
				isloading: false, //接口是否请求完毕
				params: { //精品推荐分页
					page: 1,
					limit: 10,
				},
				rightDrawer: false,
				shopPayCurrency: app.globalData.shopPayCurrency, //币种
			};
		},
		computed: mapGetters(['isLogin']),
		watch: {
			isLogin: {
				handler: function(newV, oldV) {
					if (newV) {
						this.getExpress();
					}
				},
				deep: true
			}
		},
		onLoad: function(options) {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.logistics.navTitle`)
			})
			if (!options.orderId) return this.$util.Tips({
				title: this.$t('message.pay.errorOrder')
			});
			this.orderId = options.orderId;
			if (this.isLogin) {
				this.getExpress();
			} else {
				toLogin();
			}
		},
		onReady: function() {
			// #ifdef H5
			this.$nextTick(function() {
				const clipboard = new ClipboardJS(".copy-data");
				clipboard.on("success", () => {
					this.$util.Tips({
						title: 'copy success'
					});
				});
			});
			// #endif
		},
		methods: {
			copyOrderId: function() {
				uni.setClipboardData({
					data: this.orderInfo.deliveryId
				});
			},
			//物流信息
			getExpress() {
				this.isloading = false;
				express(this.orderId).then(res=>{
					this.$set(this, 'orderInfo', res.data);
					if(res.data.logisticsInfo){
						let express = JSON.parse(res.data.logisticsInfo);
						if(express.length>0)this.$set(this, 'expressList', express.reverse());
					}
					this.isloading = true;
				}).catch(e => {
					this.isloading = false;
				});
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
				uni.navigateBack()
			},
		},
		// 滚动到底部
		onReachBottom() {
			this.$refs.recommendIndex.get_host_product();
		},
	}
</script>

<style scoped lang="scss">
	.logistics .header {
		padding: 23rpx 30rpx;
		background-color: #fff;
		height: 166rpx;
		box-sizing: border-box;
	}

	.logistics .header .pictrue {
		width: 120rpx;
		height: 120rpx;
	}

	.logistics .header .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 6rpx;
	}

	.logistics .header .text {
		width: 540rpx;
		font-size: 28rpx;
		color: #999;
		margin-top: 6rpx;
	}

	.logistics .header .text .name {
		width: 365rpx;
		color: #282828;
	}

	.logistics .header .text .money {
		text-align: right;
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
