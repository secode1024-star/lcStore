<template>
	<view class='list acea-row row-between-wrapper'>
		<view class='item' hover-class='none' @click="goDetail(item)">
			<view class='pictrue'>
				<easy-loadimage :image-src="item.image"></easy-loadimage>
			</view>
			<view class='texts'>
				<view class='name'>{{item.storeName}}</view>
				<!-- <view class='couponActivity'>$500</view> -->
				<view class='money acea-row row-between-wrapper'>
					<text class='num'>{{shopPayCurrency}}{{item.price}}</text>
					<view class="sold">{{ (Math.floor(item.sales) + Math.floor(item.ficti)) || 0 }}
						{{$t(`message.tips.sold`)}}</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	import {
		mapGetters
	} from "vuex";
	import {
		goShopDetail
	} from '@/libs/order.js'
	export default {
		props: {
			//币种
			shopPayCurrency: {
				type: String,
				require: '$'
			},
			item: {
				type: Object,
				require: true
			},
			type: {
				type: Number,
				default: 0
			},
			isStore: {
				type: [String, Number],
				default: '1'
			},
			isLogin: {
				type: Boolean,
				require: false
			}
		},
		data() {
			return {
			}
		},
		methods: {
			// 去详情页
			goDetail(item) {
				goShopDetail(item);
			},
			goShop(id) {
				this.$emit('goShop', id);
			},
			authOpen() {
				this.$emit('authOpen');
			},
			followToggle(item) {
				this.$emit('followToggle', item);
			}
		}
	}
</script>
<style lang="scss" scoped>
	.sold {
		font-size: 26rpx;
		color: #888888;
	}

	.list .item .pictrue,
	.easy-loadimage,
	image,
	uni-image {
		position: relative;
		width: 100%;
		height: 330rpx;
		border-radius: 16rpx 16rpx 0 0;
		overflow: hidden;

		/deep/image,
		/deep/.easy-loadimage,
		uni-image {
			height: 330rpx;
			border-radius: 16rpx 16rpx 0 0;
		}
	}

	.list {
		.item {
			width: 100%;

			.pictrue image {
				width: 100%;
				height: 100%;
				border-radius: 20rpx 20rpx 0 0;
				overflow: hidden;
			}
		}

		.texts {
			padding: 24rpx 24rpx 28rpx 24rpx;
			font-size: 30rpx;
			color: #222;

			.name {
				font-size: 28rpx;
				font-weight: bold;
				margin-top: 8rpx;
				color: #333333;
				margin-bottom: 30rpx;

			}

			.money {
				.num {
					font-size: 38rpx;
					font-weight: 900;
					@include price_color(theme);
				}

				.y-money {
					font-size: 26rpx;
					color: #888888;
					text-decoration: line-through;
					margin-left: 14rpx;
				}
			}
		}
	}
</style>