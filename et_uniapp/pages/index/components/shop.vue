<template>
	<view class="shopList">
		<view class="shop acea-row">
			<view v-for="(item, index) in shopList" :key="index" :class="{ml10:index===1}" @click="goShop(index)">
				<view class="shop-item">
					<view class="pic tui-skeleton-fillet">
						<easy-loadimage mode="widthFix" :class="{pic2:index===1,pic1:index===0}"
							:image-src="item.pic"></easy-loadimage>
					</view>
				</view>
				<view class="go acea-row row-between-wrapper">
					<text class="name line1">{{item.name}}</text>
					<view class='goTo'>
						<text class='iconfont icon-jiantou'></text>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		props: {
			shopList: {
				type: Array,
				default: () => []
			}
		},
		methods: {
			goShop(i) {
				i === 0 ? uni.switchTab({
					url: '/pages/merchant/street/index',
					fail(err) {
						uni.redirectTo({
							url: '/pages/merchant/street/index'
						})
					}
				}) : uni.navigateTo({
					url: `/pages/promotionList/index?name=${this.shopList[1].name}`
				})
			},
			menusTap(url) {
				uni.navigateTo({
					url
				})
			},
		}
	}
</script>

<style lang="scss" scoped>
	.shopList {
		margin-top: 68rpx;

		.shop {
			padding-left: 30rpx;

			.go {
				width: 340rpx;
				height: 80rpx;
				line-height: 80rpx;
				background-color: #F6F6F6;
				padding: 0 16rpx;
				font-weight: 600;
				color: #333333;
				font-size: 30rpx;

				.name {
					width: 84%;
				}
			}

			.goTo {
				.iconfont {
					font-size: 18rpx;
					color: #666;
				}
			}
		}

		.shop-item {
			.pic {
				width: 340rpx;
				height: 340rpx;

				image,
				uni-image>div,
				uni-image>img {
					width: 100%;
					height: 100%;
				}

				.pic1 {
					border-radius: 16rpx 0px 0px 0px;
					overflow: hidden;
				}

				.pic2 {
					border-radius: 0px 16rpx 0px 0px;
					overflow: hidden;
				}
			}
		}
	}

	.firstNewswiper {
		margin: 0 auto 30rpx auto;
		width: 640rpx;

		swiper,
		.swiper-item {
			width: 640rpx;
			height: 780rpx;
		}

		image {
			width: 640rpx;
			height: 780rpx;
		}
	}
</style>