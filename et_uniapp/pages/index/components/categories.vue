<template>
	<view class="categories">
		<view class="categories1" v-if="isShow">
			<view class='pad30 acea-row row-between-wrapper tui-skeleton-rect' @click="menusTap('/pages/goods_cate/index')">
				<view class="categories1_title tui-skeleton-fillet">{{$t(`page.index.titCate`)}}</view>
				<view class='more tui-skeleton-rect'>
					<text class='iconfont icon-gengduo'></text>
				</view>
			</view>
			<view class="acea-row">
				<view class="grid_item flex flex-column align-center " v-for="(item,index) in categoryList" :key="index"
				@click="menusTap('/pages/goods_cate/index?index=' +index)">
					<image :src="item.icon" class="tui-skeleton-circular"></image>
					<text class="grid_item_name">{{item.name}}</text>											
				</view>
			</view>					 
		</view>
		<view class='categories2' v-if="!isShow">
			<scroll-view class="scroll-view_x" scroll-x style="white-space: nowrap; vertical-align: middle;" show-scrollbar="false">
				<block v-for="(item,index) in categoryList" :key='index'>
					<view class='item'  @click="menusTap('/pages/goods_cate/index?index=' +index)">
						<view class='img-box tui-skeleton-fillet'>
							<image :src='item.icon'></image>
						</view>
						<view class='pro-info text-overflow-2'>{{item.name}}</view>
					</view>
				</block>
			</scroll-view>
		</view>
		<!-- <view class="all_btn tui-skeleton-fillet" @click="menusTap('/pages/goods_cate/index')">{{$t(`page.index.titBtn`)}}</view> -->
	</view>
	
</template>

<script>
	export default {
		data() {
			return {
				skeletonShow: true,
				isShow: true
			}
		},
		props: {
			categoryList:{
				type: Array,
				default: ()=> []
			}
		},
		created() {},
		methods: {
			menusTap(url){
				uni.navigateTo({
					url
				})
			}
		}
	};
</script>

<style scoped lang="scss">
	.pad30{
		padding: 60rpx 30rpx 0;
	}
	.categories1{
		//padding: 60rpx 30rpx 0;
		&_title{
			font-size: 36rpx;
			font-weight: bold;
			color: #282828;
			margin-bottom: 16rpx;
		}
		.grid_item{
			margin: 44rpx 30rpx 0 30rpx;
			width: 190rpx;
			image{
				width: 190rpx;
				height: 190rpx;
				border-radius: 50%;
				margin-bottom: 20rpx;
			}
			&_name{
				font-size: 24rpx;
				color: #333333;
				text-align: center;
			}
		}
	}
    .categories2{
		margin-top: 70rpx;
		padding: 0 30rpx;
		.item{
			display: inline-block;
			margin-right: 60rpx;
		}
		.img-box{
			width: 128rpx;
			height: 128rpx;
			image{
				width: 100%;
				height: 100%;
			}
		}
		.pro-info{
			color: #333333;
			font-size: 20rpx;
			margin-top: 16rpx;
			text-align: center;
		}
	}
	.all_btn{
				margin: 44rpx auto 0;
				width: 168rpx;
				height: 52rpx;
				border-radius: 26rpx;
				border: 2rpx solid #CCCCCC;
				text-align: center;
				line-height: 52rpx;
				font-size: 28rpx;
				color: #333333;
			}
</style>
