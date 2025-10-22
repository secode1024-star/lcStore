<template>
	<view class="orderGoods borRadius14">
		<navigator :url="`/pages/merchant/home/index?id=`+ orderInfo.merId" hover-class="none">
			<view class='total'>
				<text class="mr10 iconfont icon-shangjiadingdan"></text>
				<text class="mr10">{{orderInfo.merName}}</text>
				<text class="iconfont icon-gengduo" style="font-size: 20rpx;"></text>
			</view>
		</navigator>
		<view class='goodWrapper pad30'>
			<view class='item acea-row row-between-wrapper' v-for="(item,index) in cartInfo" :key="index"
				@click="jumpCon(item)">
				<view class='pictrue'>
					<easy-loadimage mode="widthFix" :image-src="item.image"></easy-loadimage>
				</view>
				<view class='text'>
					<view class='acea-row row-between-wrapper'>
						<view class='name line1'>{{item.productName ? item.productName : item.storeName}}</view>
						<view class='num'>x {{item.payNum ? item.payNum : item.cartNum}}</view>
					</view>
					<view class='attr line1' v-if="item.sku">{{item.sku}}</view>
					<view class='money'>{{shopPayCurrency}}{{item.vipPrice ? item.vipPrice : item.price}}</view>
					<view class='evaluate' v-if='item.isReply==0 && evaluate==2' @click.stop="evaluateTap(item)">{{$t(`page.users.orderList.evaluation`)}}
					</view>
					<view class='evaluate' v-else-if="item.isReply==1">{{$t(`page.users.orderList.evaluated`)}}</view>
				</view>
			</view>
		</view>
	</view>

</template>

<script>
	let app = getApp();
	export default {
		props: {
			evaluate: {
				type: Number,
				default: 0,
			},
			cartInfo: {
				type: Array,
				default: function() {
					return [];
				}
			},
			orderId: {
				type: String,
				default: '',
			},
			ids: {
				type: Number,
				default: 0,
			},
			jump: {
				type: Boolean,
				default: false,
			},
			orderProNum: {
				type: Number,
				default: function() {
					return 0;
				}
			},
			productType: {
				type: Number,
				default: function() {
					return 0;
				}
			},
			orderInfo: {
				type: Object,
				default: function() {
					return {};
				}
			},
			identity: {
				type: String,
				default: function() {
					return '';
				}
			}
		},
		data() {
			return {
				totalNmu: '',
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		watch: {
			cartInfo: function(nVal, oVal) {
				let num = 0
				nVal.forEach((item, index) => {
					num += item.cartNum
				})
				this.totalNmu = num
			}
		},
		methods: {
			evaluateTap(item) {
				uni.navigateTo({
					url: "/pages/users/goods_comment_con/index?unique=" + item.attrId + "&orderId=" + this.orderId + '&id=' + this.ids
				})
			},
			jumpCon: function(item) {
				if(this.identity){
					uni.navigateTo({
						url: `/pages/users/visitOrder/index?orderNo=${item.merOrderNo}&identity=${this.identity}&visitOrderType=subOrder`
					})
				}else{
					let type = this.productType==0?'normal':'video'
					if (this.jump) {
						uni.navigateTo({
							url: `/pages/goods_details/index?id=${item.productId}&type=${type}`
						})
					}
				}
			}
		}
	}
</script>

<style scoped lang="scss">
	.orderGoods {
		background-color: #fff;
		margin-top: 15rpx;
	}
	.money{
		@include price_color(theme);
	}
	.orderGoods .total {
		width: 100%;
		height: 86rpx;
		padding: 0 24rpx;
		border-bottom: 2rpx solid #f0f0f0;
		font-size: 28rpx;
		color: #333333;
		line-height: 86rpx;
		box-sizing: border-box;
	}

	.pictrue image {
		background: #f4f4f4;
	}
</style>
