<template>
	<view v-if="merchantList.length" class="store-wrapper" :class="isStreet?'street-pad20':''">
		<view class="store-item" :class="isStreet?'street-noPad':''" v-for="(item,index) in merchantList" :key="index">
			<view @click="goShop(item.id)" class="head" :class="isStreet?'street-backImage':''"  :style="isStreet ? { 'background-image': item.streetBackImage?`url(${item.streetBackImage})`:`url(${moren})` } : ''">
				<view class="left-wrapper">
					<view class="logo">
						<easy-loadimage mode="widthFix" :image-src="item.avatar"></easy-loadimage>
					</view>
					<view class="con-box">
						<view class="name line1" :class="isStreet?'street-name':''">
							<text v-if="item.isSelf" class="font-bg-red bt-color mr10">{{$t(`page.store.selfSupport`)}}</text>
							<text class="mer_name line1">{{item.name}}</text>
						</view>
						<text class="font-bg-red bt-color mr10">{{item.typeId | merchantTypeFilter}}</text>
						<view class="star-box">
							<view class="star">
								<view class="stars" :class="isStreet?'street-active':'star-active'" :style="'width:'+(item.starLevel/5)*100+'%'"></view>
							</view>
						</view>
					</view>
				</view>
				<view v-if="!isStreet" class="link" @click="goShop(item.id)">进店</view>
			</view>
			<view class="pic-wrapper" :class="isStreet?'street-wrapper':''">
				<view v-for="(goods,index) in item.proList" :key="index" class="proList" @click="godDetail(goods)">
					<view class="pic-item" :class="isStreet?'street-pic':''">
						<easy-loadimage mode="widthFix" :image-src="goods.image"></easy-loadimage>
						<view v-if="!isStreet" class="price">
							<text>{{shopPayCurrency}}</text>{{goods.price}}
						</view>
					</view>
					<view v-if="isStreet" class="street-price">
						{{shopPayCurrency}}{{goods.price}}
					</view>
				</view>
			</view>
		</view>
		<!-- <view class='loadingicon acea-row row-center-wrapper' v-if='loading'>
			<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{loadTitle}}
		</view> -->
		<!-- <view class='no-shop' v-if="!storeList.length && !loading">
			<view class='pictrue' style="margin: 0 auto;">
				<image src='/static/images/no-shop.png'></image>
				<text>暂无店铺，快去搜索其他店铺吧</text>
			</view>
		</view> -->
	</view>
</template>

<script>
	import {goShopDetail} from '@/libs/order.js'
	import {mapGetters} from "vuex";
	export default {
		data() {
			return {
				skeletonShow: true,
				isShow: true,
				moren: require('@/static/images/mermoren.png')
			}
		},
		computed: mapGetters(['uid']),
		props: {
            //币种
            shopPayCurrency: {
                type: String,
                require: '$'
            },
			merchantList:{
				type: Array,
				default: ()=> []
			},
			isStreet:{
				type: Boolean,
				default: ()=> false
			}
		},
		created() {},
		methods: {
			godDetail(item) {
				goShopDetail(item)
			},
			menusTap(url){
				uni.navigateTo({
					url
				})
			},
			goShop(id){
				uni.navigateTo({
					url: `/pages/merchant/home/index?id=${id}`
				})
			},
		}
	};
</script>

<style lang="scss" scoped>
	.store-wrapper{
	//	margin-top: 328rpx;
	}
	.proList{
		padding-left: 22rpx;
	}
	.star-box {
		display: flex;
		align-items: center;
	
		.star {
			position: relative;
			width: 111rpx;
			height: 19rpx;
			background: url(~static/images/star.png);
			background-size: 111rpx 19rpx;
			margin-top: 6rpx;
		}
	
		.stars {
			position: absolute;
			left: 0;
			top: 0;
			width: 111rpx;
			height: 19rpx;
			overflow: hidden;
		}
		.star-active{
			background: url(~static/images/star_active.png);
			background-size: 111rpx 19rpx;
		}
		
		.num {
			color: $theme-color;
			font-size: 24rpx;
			margin-left: 10rpx;
		}
	}
	.street{
		&-name{
			color: #fff !important;
		}
		&-pad20{
		    padding: 0 20rpx;
	    }
		&-backImage{
			padding: 24rpx 0 24rpx 20rpx;
			border-radius: 16rpx 16rpx 0rpx 0rpx;
	    }
		&-noPad{
			padding: 0 !important;
			border-top-left-radius: 16rpx;
			border-top-right-radius: 16rpx;
		}
		&-pic{
			width: 208rpx !important;
			height: 208rpx !important;
			border-radius: 8rpx !important;
			overflow: hidden;
		}
		&-price{
			font-size: 30rpx;
			color: $theme-color;
			text-align: center;
			margin-top: 20rpx;
		}
		&-wrapper{
			//padding: 20rpx 25rpx !important;
		}
		&-active{
		 	background: url(~static/images/star_active_bai.png);
		 	background-size: 111rpx 19rpx;
		}
	}
	.backImage{
		
		padding: 24rpx 0 24rpx 20rpx;
		border-radius: 16px 16px 0px 0px;
	}

	.store-item {
		margin-bottom: 30rpx;
		padding: 24rpx 30rpx 30rpx 30rpx;
		background-color: #fff;
		.head {
			display: flex;
			justify-content: space-between;
	
			.left-wrapper {
				display: flex;
				align-items: center;
	
				.logo {
					width: 120rpx;
					height: 120rpx;
					border-radius: 50%;
					overflow: hidden;
	
					image {
						width: 120rpx;
						height: 120rpx;
						border-radius: 50%;
						overflow: hidden;
					}
				}
	
				.con-box {
					margin-left: 20rpx;
	
					.font-bg-red {
						width: max-content;
						white-space: nowrap;
						font-size: 18rpx;
						padding: 2rpx 10rpx;
						color: #FFFFFF;
						@include main_bg_color(theme);
						border-radius: 13rpx;
						
					}
	
					.name {
						font-size: 30rpx;
						color: #333;
						font-weight: bold;
						margin-bottom: 6rpx;
						.mer_name{
							max-width: 400rpx;
						}
					}
				}
			}
	
			.link {
				width: 114rpx;
				height: 50rpx;
				line-height: 50rpx;
				@include linear-gradient(theme);
				border-radius: 25rpx;
				text-align: center;
				color: #fff;
				font-size: 24rpx;
			}
		}
	
		.pic-wrapper {
			display: flex;
			padding: 20rpx 0rpx 25rpx 0rpx;
	        // justify-content: space-between;
			.pic-item {
				position: relative;
				width: 214rpx;
				height: 214rpx;
	            overflow: hidden;
	            border-radius: 16rpx;
				.easy-loadimage,image,uni-image{
					overflow: hidden;
					border-radius: 16rpx;
				}
	
				.price {
					position: absolute;
					right: 0;
					bottom: 0;
					height: 36rpx;
					padding: 0 10rpx;
					line-height: 36rpx;
					text-align: center;
					background: rgba(0, 0, 0, .5);
					border-radius: 16rpx 2rpx 16rpx 2rpx;
					color: #fff;
					font-size: 24rpx;
	
					text {
						font-size: 18rpx;
					}
				}
	
				&:nth-child(3n) {
					margin-right: 0;
				}
			}
		}
	}
</style>
