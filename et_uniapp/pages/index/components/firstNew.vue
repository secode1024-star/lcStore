<template>
	<view class="firstNew">
		<view class="wrapper spike-bd" @click="gopage">
			<view class='indexTitle acea-row row-between-wrapper tui-skeleton-rect'>
				<view class='text tui-skeleton-rect'>
					<view class='name line1 tui-skeleton-rect'>{{activityData.name}}</view>
				</view>
				<view class='more tui-skeleton-rect'>
					<text class='iconfont icon-gengduo'></text>
				</view>
			</view>
		</view>
		<view class="firstNewswiper">
			<swiper :indicator-dots="false" :autoplay="false"  circular="true" interval="2500" duration="500" 
			previous-margin="28px" next-margin="29px">
				<block v-for="(item,index) in activityData.productList" :key="index">
					<swiper-item>
						<view @click="goDetail(item.proId)">
							<easy-loadimage mode="widthFix" class="slide-image" :image-src="item.proImage"></easy-loadimage>
							<!-- <image :src="item.proImage" class="slide-image" lazy-load></image> -->
						</view>
					</swiper-item>
				</block>
			</swiper>
		</view>
	    <view class="moreBtn" @click="gopage">{{$t(`page.index.onView`)}}</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				shopList: [
					{
						name: 'SHOP STREET',
						img: 'https://mer1.crmeb.net/uploads/def/20220122/66fa29c8696c45affbc1552accedf8b9.jpg'
					},
					{
						name: 'TOP ONE',
						img: 'https://mer1.crmeb.net/uploads/def/20220122/66fa29c8696c45affbc1552accedf8b9.jpg'
					}
				]
			}
		},
		props: {
			activityData:{
				type: Object,
				default: ()=> {}
			}
		},
		methods:{
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

<style lang="scss" scoped>
	.firstNew{
		.moreBtn{
			width: 640rpx;
			height: 86rpx;
			background: #333333;
			border-radius: 2px;
			color: #FFFFFF;
			font-size: 30rpx;
			text-align: center;
			line-height: 86rpx;
			margin: 68rpx auto 0 auto;
		}
		.shop{
			padding-left: 30rpx;
			.go{
				width: 340rpx;
				height: 80rpx;
				line-height: 80rpx;
				background-color: #F6F6F6;
				padding: 0 16rpx;
				font-weight: 600;
				color: #333333;
				font-size: 30rpx;
			}
			.goTo{
				font-size: 24rpx;
				color: #000000;
			}
		}
		.shop-item{
			.pic{
				width: 340rpx;
				height: 340rpx;
				border-radius: 16rpx 0px 0px 0px;
				image{
					width: 100%;
					height: 100%;
				}
			}
		}
	}
	.firstNewswiper{
		// margin: 0 auto 30rpx auto;
	
		//width: 640rpx;
		swiper,.swiper-item{
			//width: 640rpx;
			height: 780rpx;
		}
		.slide-image {
		    width: 640rpx;
			height: 780rpx;
			img{
				width: 100%;
				height: 100%;
			}
		}
	}
</style>
