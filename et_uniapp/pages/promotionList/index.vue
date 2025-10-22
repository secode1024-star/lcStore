<template>
	<div :data-theme="theme" class="quality-recommend">
		<view class="fixed-top bg_color">
			<uniNavBar background-color="transparent" color="#333" :title="typeInfo.name" :border='false' @clickLeft='returns' @clickRight="open">
				    <view slot="left" class="iconfont icon-dingbufanhui"></view>
				    <view slot="right" class="iconfont icon-more"></view>
			</uniNavBar>
		</view>
		<block v-if="Number(typeInfo.type)===3">
			<view v-for="(item,index) in tempArr" :key="index" class="proImg" @click="toDetail(item.proId)">
				<easy-loadimage :image-src="item.proImage"></easy-loadimage>
			</view>
		</block>
		<block v-else>
			<view class="header">
				<view class="ht_title line2">{{typeInfo.name}}</view>
			</view>
			<view class="recommend_list">
				<view class="goods_item flex" v-for="(item,index) in tempArr" :key="index" @click="toDetail(item.proId,item.id)">
                    <easy-loadimage :image-src="item.image"></easy-loadimage>
					<view class="goods_content">
						<view class="store_name line2">{{item.storeName}}</view>
						<view class="acea-row row-between">
							<view class="acea-row row-column">
								<text class="price">{{shopPayCurrency}}{{item.price}}</text>
								<view v-if="!typeInfo.type" class="sold">{{ (Math.floor(item.sales) + Math.floor(item.ficti)) || 0 }} {{$t(`message.tips.sold`)}}</view>
								<text v-else class="ot_price">{{shopPayCurrency}}{{item.otPrice}}</text>
							</view>
							<view class="more_btn">{{$t(`page.index.viewDetails`)}}</view>
						</view>
					</view>
				</view>
				<view class='loadingicon acea-row row-center-wrapper'>
					<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>
				</view>
				
				<view class="text-center pb-20" v-if="!goodScroll">
					<text>{{$t(`page.goodsList.no`)}}</text>
				</view>
			</view>
		</block>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</div>
</template>
<script>
	import emptyPage from '@/components/emptyPage.vue';
	import GoodList from '@/components/goodList/index';
	import { getActivityList, getLeaderboard } from '@/api/store';
	import {goPage} from '@/libs/order.js';
	import {productRank} from '@/api/api.js'
	let app = getApp()
	export default {
		name: 'HotNewGoods',
		components: {
			GoodList,
			emptyPage
		},
		data: function() {
			return {
				rightDrawer: false,
				circular:true,
				typeInfo:{},
				params: { 
					page: 1,
					limit: 10,
					aid: 0
				},
				loading: false,
				goodScroll: true, 
				tempArr:[],
				theme:app.globalData.theme,
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		onLoad: function(e) {
			this.typeInfo = e
			this.typeInfo.type ? this.getGroomList() : this.leaderboard();
		},
		// 滚动监听
		onPageScroll(e) {
		   // 传入scrollTop值并触发所有easy-loadimage组件下的滚动监听事件
		   uni.$emit('scroll');
		},
		methods: {
			returns: function() {
				uni.navigateBack()
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
			getGroomList() {
				this.loading = true
				if (!this.goodScroll) return
				getActivityList(this.typeInfo.id, this.params).then(({data}) => {
					this.goodScroll = data.list.length >= this.params.limit
					
					this.params.page++
					this.tempArr = this.tempArr.concat(data.list)
					this.loading = false
				}).catch(err => {
					that.loading = false;
				})
			},
			leaderboard() {
				this.loading = true
				getLeaderboard().then(({data}) => {
					this.tempArr = data
					this.loading = false
				}).catch(err => {
					that.loading = false;
				})
			},
			toDetail(pid,id){
				if(this.typeInfo.type){
					uni.navigateTo({
						url:'/pages/goods_details/index?id=' + pid
					})
				}else{
					uni.navigateTo({
						url:'/pages/goods_details/index?id=' + id
					})
				}
			}
		},
		onReachBottom() {
			if (this.params.page != 1) {
				this.getGroomList();
			}
		},
	}
</script>
<style lang="scss" scoped>
	.sold{
		font-size: 26rpx;
		color: #888888;
		margin-top: 6rpx;
	}
	.proImg{
		width: 100%;
		height: 914rpx;
		image,/deep/.easy-loadimage > uni-image>div, uni-image>img ,/deep/.easy-loadimage > uni-image{
			width: 100%;
			height: 914rpx;
			overflow: initial !important;
		}
	}
	.quality-recommend {
		background-color: #f5f5f5;
		.header{
			width: 100%;
			height: 282rpx;
			@include main_bg_color(theme);
			background-image: url(../../static/images/list_bgimg.png);
			background-size: cover;
			background-repeat: no-repeat;
			.ht_title{
				font-size: 56rpx;
				font-family: PingFangSC-Semibold, PingFang SC;
				font-weight: 600;
				color: #FFFFFF;
				line-height: 56rpx;
				text-align: center;
				padding-top: 52rpx;
			}
		}
		.recommend_list{
			margin-top: -90rpx;
			padding: 0 30rpx 30rpx;
			.goods_item{
				height: 280rpx;
				background: #FFFFFF;
				border-radius: 16rpx;
				margin-bottom: 20rpx;
				padding: 20rpx;
				image,.easy-loadimage{
					width: 240rpx;
					height: 240rpx;
					border-radius: 16rpx;
					overflow: hidden;
				}
				.goods_content{
					padding-left: 24rpx;
					display: flex;
					flex-direction: column;
					justify-content: space-between;
					.store_name{
						width: 370rpx;
						height: 80rpx;
						font-size: 28rpx;
						font-family: PingFangSC-Medium, PingFang SC;
						font-weight: 500;
						color: #333333;
						line-height: 40rpx;
					}
					.price{
						height: 30rpx;
						font-size: 36rpx;
						font-family: D-DIN-Bold, D-DIN;
						font-weight: bold;
						@include price_color(theme);
						line-height: 30rpx;
					}
					.ot_price{
						font-size: 24rpx;
						font-family: D-DIN, D;
						color: #999999;
						padding-top: 6rpx;
						line-height: 24rpx;
						text-decoration: line-through;
					}
					.more_btn{
						width: 162rpx;
						height: 60rpx;
						text-align: center;
						line-height: 60rpx;
						font-size: 26rpx;
						color: #fff;
						@include linear-gradient(theme);
						border-radius: 32rpx;
					}
				}
			}
			.empty{
				height: 600rpx;
				background: #FFFFFF;
				border-radius: 16rpx;
			}
		}
	}
	.main_bg{
		@include main_bg_color(theme);
	}
</style>