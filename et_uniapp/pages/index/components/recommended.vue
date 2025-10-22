<template>
	<view class="recommended" v-if="activityData">
		<view class="index-wrapper">
			<view class='wrapper'>
				<view class='title1 acea-row row-between-wrapper tui-skeleton-rect' @click="gopage()">
					<view class='text'>
						<view class='name line1'>{{activityData.name}}</view>
					</view>
					<view class='more'>
						<text class='iconfont icon-gengduo'></text>
					</view>
				</view>
				<view class='newProducts'>
					<scroll-view class="scroll-view_x" scroll-x style="white-space: nowrap; vertical-align: middle;" show-scrollbar="false">
						<block v-for="(item,index) in activityData.productList" :key='index'>
							<view class='item' @click="goDetail(item.proId)">
								<view class='img-box tui-skeleton-rect'>
									<easy-loadimage mode="widthFix" :image-src="item.image"></easy-loadimage>
								</view>
								<view class='line2 pro-info'>{{item.storeName}}</view>
								<view class="acea-row row-bottom">
									<view class='money font-color mr10'>{{shopPayCurrency}}{{item.price}}</view>
									<view class='y_money'>{{shopPayCurrency}}{{item.otPrice}}</view>
								</view>
							</view>
						</block>
					</scroll-view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	let app = getApp()
	export default {
		name: 'promotion',
		props: {
			activityData:{
				type: Object,
				default: ()=> {}
			}
		},
		created() {
		},
		data() {
			return {
				tempArr: [],
				params: {
					page: 1,
					limit: 10,
				},
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

<style lang="scss">
	.wrapper {
		// margin: 30rpx auto 0;
		border-radius: 14rpx;
		background-color: #fff;
	}
    .y_money {
		font-size: 12px;
		color: #999;
		text-decoration: line-through;
	}
	.title1 {
		padding-top: 70rpx;
		margin: 0 30rpx;

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


	.wrapper .newProducts {
		white-space: nowrap;
		padding: 0rpx 30rpx;
		margin: 44rpx 0 0;
	}

	.wrapper .newProducts .item {
		display: inline-block;
		width: 260rpx;
		margin-right: 20rpx;
	}

	.wrapper .newProducts .item:nth-last-child(1) {
		margin-right: 0;
	}

	.wrapper .newProducts .item .img-box {
		width: 260rpx;
		height: 260rpx;
		position: relative;
		border-radius: 16rpx;
		overflow: hidden;
	}

	.wrapper .newProducts .item .img-box image {
		width: 100%;
		height: 100%;
	}

	.wrapper .newProducts .item .pro-info {
		font-size: 28rpx;
		color: #333;
		width: 260rpx;
		padding: 19rpx 10rpx 0 0rpx;
		white-space: normal;
		height: 96rpx;
	}

	.wrapper .newProducts .item .money {
		font-size: 32rpx;
		font-family: D-DIN-Bold, D-DIN;
		font-weight: bold;
		color: #E93323;
	}

	.empty-img {
		width: 640rpx;
		height: 300rpx;
		border-radius: 14rpx;
		margin: 26rpx auto 0 auto;
		background-color: #ccc;
		text-align: center;
		line-height: 300rpx;

		.iconfont {
			font-size: 50rpx;
		}
	}

	.font-color {
		@include price_color(theme);
	}
	
</style>
