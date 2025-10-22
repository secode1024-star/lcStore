<template>
	<view :data-theme="theme">
		<uni-nav-bar background-color="#fff" color="#333" :title="$t(`page.user.applicationRecord`)" :border='false' @clickLeft='returns' @clickRight="open">
			    <view slot="left" class="iconfont icon-dingbufanhui"></view>
			    <view slot="right" class="iconfont icon-more"></view>
		</uni-nav-bar>
	    <uni
		<view class="user_store_attention">
			<view class="item" v-for="(item,index) in storeList" :key="index">
				<view class="store_header" @click="goStore(item.merId)">
					<easy-loadimage mode="widthFix" :image-src="item.merAvatar"></easy-loadimage>
					<!-- <image :src="item.merAvatar" mode=""></image> -->
					<view class="info">
						<view class="line1">
							<text class="name line1">{{item.merName}}</text>
						</view>
						<view class="btn" @click.stop="bindDetele(item.merId, index)">{{$t(`page.store.delFollow`)}}</view>
					</view>
				</view>
			</view>
		</view>
		<view class='noCommodity' v-if="!storeList.length && page > 1">
			<view class='pictrue text-center'>
				<image src='../static/noCollection.png'></image> 
			</view>
			<text class="text-ccc">{{$t(`page.users.userGoodsCollection.empty`)}}</text>
		</view>
		<view class='loadingicon acea-row row-center-wrapper'>
			<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{loadTitle}}
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>	
</template>

<script>
	// +----------------------------------------------------------------------
	// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
	// +----------------------------------------------------------------------
	// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
	// +----------------------------------------------------------------------
	// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
	// +----------------------------------------------------------------------
	// | Author: CRMEB Team <admin@crmeb.com>
	// +----------------------------------------------------------------------
	let app = getApp();
	import { getMerCollectListApi, getMerCollectCancelApi } from '@/api/merchant.js'
	export default{
		data(){
			return {
				storeList:[],
				isScroll:true,
				page:1,
				limit:20,
				theme:app.globalData.theme,
				rightDrawer: false,
				loading: false
			}
		},
		onLoad() {
			uni.setNavigationBarTitle({
				title: this.$t(`page.user.applicationRecord`)
			})
			this.getList()
		},
		onReady(){
		},
		mounted: function() {
		},
		methods:{
			open(){
				this.rightDrawer = true
			},
			closeDrawer(e) {
				this.rightDrawer = false
				if(!e){
					this.rightDrawer = false
				}
			},
			returns: function() {
				uni.navigateBack()
			},
			goStore(id){
				uni.navigateTo({
					url:`/pages/merchant/home/index?id=${id}`
				})				
			},
			getList(){
				if(!this.isScroll) return
				this.loading = true;
				this.loadTitle = "";
				getMerCollectListApi({
					page:this.page,
					limit:this.limit
				}).then(res=>{
					this.isScroll = res.data.list.length>=this.limit
					let loadend = res.data.list.length < this.limit;
					this.storeList = this.storeList.concat(res.data.list)
					this.loadend = loadend;
					this.loadTitle = this.storeList.length===0 ? '' : loadend ? this.$t('page.goodsList.nono') : this.$t('page.goodsList.more');
					this.page+=1
					this.loading = false;
				}).catch(res => {
					this.loading = false;
						return this.$util.Tips({
							title: res
						});
						
					});
			},
			// 删除收藏
			bindDetele(id, index){
				getMerCollectCancelApi(id).then(res=>{
					uni.showToast({
						title:this.$t(`message.login.calSU`),
						icon:'none'
					})
					this.storeList.splice(index,1)
				})
			}
		},
		onReachBottom() {
			this.getList()
		},
		// 滚动监听
		onPageScroll(e) {
			// 传入scrollTop值并触发所有easy-loadimage组件下的滚动监听事件
			uni.$emit('scroll');
		}
	}
</script>

<style lang="scss" scoped>
.user_store_attention{
	padding: 20rpx;
	.item{
		background-color: #ffffff;
		background-size: 100%;
		background-repeat: no-repeat;
		border-radius: 16rpx;
		padding: 0 20rpx;
		margin-bottom: 20rpx;
		// background-image: url('../static/images/attention_bg.png');
		// &.item_purple{
		// 	background-image: url('../static/images/attention_bg_purple.png');
		// }
	}
	.store_header{
		position: relative;
		display: flex;
		padding: 30rpx 10rpx;		
		align-items: center;	
		image,.easy-loadimage,image,uni-image{
			width: 88rpx;
			height: 88rpx;
			border-radius: 50%;
			overflow: hidden;
		}
		.info{
			flex: 1;
			display: flex;
			flex-direction: column;
			justify-content: space-between;
			margin-left: 20rpx;
			position: relative;
			.name{
				width: 410rpx;
				font-weight: bold;
			}
			.des{
				color: #666666;
				font-size: 22rpx;
			}
			.btn{
				display: flex;
				align-items: center;
				justify-content: center;
				position: absolute;
				right: 0;
				top: 50%;
				width:150rpx;
				height:50rpx;
				transform: translateY(-50%);
				border:1px solid #BBBBBB;
				border-radius:25rpx;
				font-size: 26rpx;
			}
		}
	}
	.store_recommend{
		display: flex;
		padding-bottom: 30rpx;
		.list{
			width: 210rpx;
			.picture,/deep/image,/deep/.easy-loadimage,uni-image{
				width: 210rpx;
				height: 210rpx;
				border-radius: 10rpx;
			}
			margin-right: 20rpx;
			&:last-child{
				margin-right: 0;
			}
			.price{
				text-align: center;
				color: var(--view-priceColor);
				font-size: 24rpx;
				margin-top: 10rpx;
				font-weight: bold;
			}
		}
	}
}

</style>
