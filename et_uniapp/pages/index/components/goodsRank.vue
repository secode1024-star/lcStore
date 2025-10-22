<template>
	<view>
		<view class='hotList' v-if="tempArr.length">
			<view class='title acea-row row-between-wrapper'>
				<view class='text line1'>
					<text class="iconfont icon-jingpintuijian1"></text> 
					<text class='label tui-skeleton-rect'>{{$t(`page.index.titNow`)}}</text>
				</view>
				<view class='more tui-skeleton-rect' hover-class="none" @click="more()">
					<text class="iconfont icon-gengduo"></text>
				</view>
			</view>
			<view class='list'>
				<block>
					<view class="item acea-row row-middle" :class="{'lei' : index < 2}" v-for="(item,index) in tempArr" :key="index" @click="toDetail(item.id)">
						<view class="img_box">
							<image class="pictrue tui-skeleton-fillet" :src="item.image"></image>
						</view>
						<view class="ml_11 right_box flex-1">
							<view class="goods_name text-overflow-2 tui-skeleton-rect">{{item.storeName}}</view>
							<view class='couponActivity'>{{shopPayCurrency}}500</view>
							<view class="price flex justify-between tui-skeleton-rect">
								<view>{{shopPayCurrency}}{{item.price}}
									<text class="sales">{{shopPayCurrency}}{{item.otPrice}}</text>
								</view>
								<view class="cart_icon tui-skeleton-rect">
									<text class="iconfont icon-gouwuche"></text>
								</view>
							</view>
						</view>
					</view>
				</block>
			</view>
		</view>
	</view>
</template>

<script>
	import {mapState} from 'vuex';
	import {getGroomList} from '@/api/store.js';
	let app = getApp();
	export default {
		name: 'goodList',
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
		created() {
			this.productslist();
		},
		methods:{
			// 产品列表
			productslist: function() {
				let that = this;
				this.tempArr = [
					{
						id: 1,
						image: 'https://api.beta.adminwm.java.crmeb.net/crmebimage/public/maintain/2021/12/25/a272fcefed804cf2b1e6785d5662c29ejqjxha0eow.jpg',
					    storeName: '啦啦',
					    price: 122
					},
					{
						id: 1,
						image: 'https://api.beta.adminwm.java.crmeb.net/crmebimage/public/maintain/2021/12/25/a272fcefed804cf2b1e6785d5662c29ejqjxha0eow.jpg',
					    storeName: 'Dawn Ultra Liquid Dish Soap, Origi…',
					    price: 122
					},
					{
						id: 1,
						image: 'https://api.beta.adminwm.java.crmeb.net/crmebimage/public/maintain/2021/12/25/a272fcefed804cf2b1e6785d5662c29ejqjxha0eow.jpg',
					    storeName: 'Dawn Ultra Liquid Dish Soap, Origi…',
					    price: 122
					},
					{
						id: 1,
						image: 'https://api.beta.adminwm.java.crmeb.net/crmebimage/public/maintain/2021/12/25/a272fcefed804cf2b1e6785d5662c29ejqjxha0eow.jpg',
					    storeName: 'Dawn Ultra Liquid Dish Soap, Origi…',
					    price: 122
					},
					{
						id: 1,
						image: 'https://api.beta.adminwm.java.crmeb.net/crmebimage/public/maintain/2021/12/25/a272fcefed804cf2b1e6785d5662c29ejqjxha0eow.jpg',
					    storeName: 'Dawn Ultra Liquid Dish Soap, Origi…',
					    price: 122
					}
				]
							
			},
			toDetail(id){
				uni.navigateTo({
					url:'/pages/goods_details/index?id=' + id
				})
			},
			more(){
				let typeInfo = {
					type:2,
					name:this.$t(`page.index.titNow`)
				}
				uni.navigateTo({
					url:'/pages/promotionList/index?type=' + JSON.stringify(typeInfo)
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.hotList {
		padding-top:30rpx;
		background-color: #fff;
	}

	.hotList .hot-bg {
		width: 100%;
		height: 120rpx;
		box-sizing: border-box;
		font-size: 24rpx;
		color: #282828;
		margin-top: 15rpx;

	}

	.hotList .title {
		padding: 24rpx 20rpx 0 20rpx;
	}

	.hotList .title .text {
		width: 500rpx;
		color: #999999;
		font-size: 12px;
		display: flex;
		align-items: flex-end;
	}
	
	.icon-jingpintuijian1{
		@include main_color(theme);
		font-size: 42rpx;
	}
	.hotList .title .text .label {
		font-size: 36rpx;
		font-weight: bold;
		color: #282828;
		margin-right: 12rpx;
		margin-left:12rpx;
	}

	.hotList .title .more {
		font-size: 28rpx;
		color: #666;
		cursor: pointer;
	}

	.hotList .title .more .iconfont {
		font-size: 25rpx;
		margin-left: 10rpx;
	}

	.hotList .list {
		width: 690rpx;
		border-radius: 20rpx;
		background-color: #fff;
		margin: 42rpx auto 0 auto;
	}
	.hotList .list .item {
		background: #fff;
		margin-top: 26rpx;
	}
	.lei{
		padding-bottom: 26rpx;
		position: relative;
		&::after{
			content: '';
			position: absolute;
			bottom: 0;
			right: 0;
			width: 440rpx;
			height: 2rpx;
			background-color: #eee;
		}
	}
	.img_box{
		width: 260rpx;
		height: 260rpx;
		background: #F3F3F3;
		.pictrue{
			width:100%;
			height:100%;
			border-radius: 16rpx;
		}
	}
	.ml_11{
		margin-left: 22rpx;
	}
	.flex-1{
		flex: 1;
	}
	.right_box{
		height: 260rpx;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
	}
	.goods_name{
		width: 400rpx;
		font-size: 30rpx;
		font-weight: 400;
		color: #333333;
		line-height: 40rpx;
	}
	.price{
		margin-top: 60rpx;
		font-size: 34rpx;
		font-weight: 600;
		@include price_color(theme);
		.sales{
			font-size: 24rpx;
			color: #999999;
			font-weight: 400;
			padding-left: 12rpx;
			text-decoration: line-through;
		}
		.cart_icon{
			width: 48rpx;
			height: 48rpx;
			border-radius: 50%;
			@include main_bg_color(theme);
			display: flex;
			justify-content: center;
			align-items: center;
			.iconfont{
				font-size: 28rpx;
				font-weight: 400;
				color: #fff;
			}
		}
	}
</style>