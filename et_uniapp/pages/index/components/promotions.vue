<template>
	<view class="promotions">
		<view class="promotions-count">
			<view class="wrapper spike-bd tui-skeleton-rect" @click="gopage()">
				<view class='indexTitle acea-row row-between-wrapper'>
					<view class='text'>
						<view class='name line1 tui-skeleton-rect'>{{activityData.name}}</view>
					</view>
					<view class='more tui-skeleton-rect'>
						<text class='iconfont icon-gengduo'></text>
					</view>
				</view>
			</view>
			<view class="promotions_wrapper">
				<view class="promotions">
					<view class="promotions-item tui-skeleton-rect" v-for="(item,index) in activityData.productList"
						:key="index" :class="{item1:index===0,item2:index===1,item3:index===2}" hover-class='none'
						@click="goDetail(item.proId)">
						<block v-if="index === 1">
							<view class="promotionsSave">
								<text>{{item.title}}</text>
							</view>
							<view class="img tui-skeleton-fillet">
								<easy-loadimage mode="widthFix" loading-mode="spin-circle"
									:image-src="item.image"></easy-loadimage>
							</view>
							<view class="line2 title">{{item.storeName}}</view>
							<view class="price">{{shopPayCurrency}}{{item.price}}</view>
						</block>
						<block v-else>
							<view class="promotionsSave">
								<!-- <text>{{item.title}}</text> -->
							</view>
							<view class="acea-row">
								<view class="priceBox">
									<view class="line1 title">{{item.storeName}}</view>
									<view class="price">{{shopPayCurrency}}{{item.price}}</view>
								</view>
								<view class="img">
									<easy-loadimage mode="widthFix" loading-mode="spin-circle"
										:image-src="item.image"></easy-loadimage>
									<!-- <image :src='item.image'></image> -->
								</view>
							</view>
						</block>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	let app = getApp();
	export default {
		props: {
			activityData: {
				type: Object,
				default: () => {}
			}
		},
		data() {
			return {
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			}
		},
		methods: {
			gopage() {
				uni.navigateTo({
					url: `/pages/promotionList/index?id=${this.activityData.id}&type=${this.activityData.type}&name=${this.activityData.name}`
				})
			},
			goDetail(id) {
				uni.navigateTo({
					url: `/pages/goods_details/index?id=${id}`
				})
			},
		}
	}
</script>

<style scoped lang="scss">
	.promotions_wrapper {
		padding: 0 30rpx;
	}

	.promotionsSave {
		font-size: 20rpx;
		// @include price_color(theme);
		height: 0;
		width: 152rpx;
		margin-bottom: 36rpx;
		border-top-left-radius: 10rpx;
		border-right: 18rpx solid transparent;
		position: relative;

		text {
			position: absolute;
			top: -34rpx;
			left: 10rpx;
		}
	}

	.promotions {
		display: grid;

		.item1 {
			margin-bottom: 20rpx;
		}

		.item2 {
			width: 320rpx;
			height: 500rpx;
			background: #FFF4F4;
			border-radius: 10rpx;
			margin-left: 20rpx;
			grid-column: 3/3;
			grid-row: 1/3;

			.img {
				width: 280rpx;
				height: 280rpx;
				margin-left: 20rpx;
				margin-bottom: 25rpx;

				image {
					width: 100%;
					height: 100%;
				}
			}

			.title {
				margin-left: 20rpx;
				width: 278rpx;
				font-size: 28rpx;
				color: #333333;
			}

			.price {
				margin-left: 20rpx;
				font-size: 32rpx;
				font-weight: 900;
				margin-top: 24rpx;
				@include price_color(theme);
			}
		}

		.item1,
		.item3 {
			grid-column: 1/3;

			.title {
				margin-left: 20rpx;
				width: 170rpx;
				font-size: 28rpx;
				color: #333333;
				margin-top: 30rpx;
			}

			.price {
				margin-left: 20rpx;
				font-size: 32rpx;
				font-weight: 900;
				margin-top: 24rpx;
				@include price_color(theme);
			}

			.img {
				width: 160rpx;
				height: 160rpx;

				image {
					width: 100%;
					height: 100%;
				}
			}
		}

	}

	.promotions-item {
		width: 350rpx;
		height: 240rpx;
		background: #FFF4F4;
		border-radius: 10rpx;
	}

	.indexTitle {
		padding-top: 64rpx;
		margin: 0 30rpx;
		margin-bottom: 25rpx;

		.text {
			display: flex;

			.name {
				font-size: 34rpx;
				font-weight: bold;
			}

			.txt-btn {
				display: flex;
				align-items: flex-end;
				margin-bottom: 4rpx;
				margin-left: 12rpx;
				font-size: 24rpx;
				color: #999;
			}
		}

		.more {
			font-size: 28rpx;
			color: #666;
			cursor: pointer;

			.icon-gengduo {
				margin-left: 10rpx;
				font-size: 26rpx;
			}
		}
	}
</style>