<template>
	<view class="my-order" :data-theme="theme">
		<view class="bg_color">
			<uniNavBar background-color="#fff" color="#333333" :title="$t(`page.users.replyList.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
				<view slot="left" class="iconfont icon-dingbufanhui"></view>
				<view slot="right" class="iconfont icon-more"></view>
			</uniNavBar>
		</view>
		<view class='list'>
			<view class='item' v-for="(item,index) in replyList" :key="index">
				<view class='title acea-row row-between-wrapper'>
					<navigator :url="`/pages/merchant/home/index?id=${item.merId}`" hover-class="none">
						<view class="acea-row row-middle">
							<text class='iconfont icon-shangjiadingdan mr10'></text>
							<text class="mr10">{{item.merName}}</text>
							<text class='iconfont icon-gengduo'></text>
						</view>
					</navigator>
				</view>
				<view @click='goProDetails(item.productId)' class='item-info acea-row row-between row-top'>
					<view class='pictrue'>
						<image :src='item.image'></image>
					</view>
					<view class='text acea-row row-between'>
						<view class='name line2'>{{item.productName}}</view>
						<view class='money'>
							<view>{{shopPayCurrency}}{{item.price}}</view>
							<view>x{{item.payNum}}</view>
						</view>
						<view class="sku">{{$t(`page.users.goodsCommentList.attribute`)}}：{{ item.sku?item.sku:'无' }}</view>
					</view>
				</view>
				<view class='bottom acea-row row-right row-middle'>
					<view class='bnt bg_color' @click='evaluateTap(item)'>{{$t(`page.users.orderList.evaluation`)}}</view>
				</view>
			</view>
			<view class='loadingicon acea-row row-center-wrapper'>
				<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{replyList.length>0?loadTitle:''}}
			</view>
		    <view class='noCommodity' v-if="replyList.length == 0 && !loading">
		    	<view class='pictrue'>
		    		<image src='@/static/images/noEvaluate.png'></image>
		    	</view>
		    </view>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>	
	</view>	
</template>

<script>
	import {
		orderReplyList
	} from '@/api/order.js';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import emptyPage from '@/components/emptyPage.vue'
	
	const app = getApp();
	export default {
		data() {
			return {
				loading: false, //是否加载中
				loadend: false, //是否加载完毕
				loadTitle: this.$t(`page.goodsList.more`), //提示语
				replyList: [], //订单数组
				page: 1,
				limit: 20,
				isShow: false,
				theme: app.globalData.theme,
				rightDrawer: false,
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		computed: mapGetters(['isLogin']),
		
		onShow() {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.replyList.navTitle`)
			})
			let that = this;
			if (this.isLogin) {
				this.loadend = false;
				this.page = 1;
				this.$set(this, 'replyList', []);
				this.getReplyList();
			} else {
				toLogin();
			}
		},
		methods: {
			returns(){
				uni.navigateBack()
			},
			evaluateTap(item) {
				uni.navigateTo({
					url: "/pages/users/goods_comment_con/index?orderNo=" + item.merOrderNo + "&id=" + item.id
				})
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
			/**
			 * 去商品详情
			 */
			goProDetails: function(id) {
				uni.navigateTo({
					url: `/pages/goods_details/index?id=${id}`
				})
			},
			/**
			 * 获取订单列表
			 */
			getReplyList: function() {
				let that = this;
				if (that.loadend) return;
				if (that.loading) return;
				that.loading = true;
				that.loadTitle = this.$t(`page.goodsList.more`);
				orderReplyList({
					page: that.page,
					limit: that.limit,
				}).then(res => {
					let list = res.data.list || [];
					let loadend = list.length < that.limit;
					that.replyList = that.$util.SplitArray(list, that.replyList);
					that.$set(that, 'replyList', that.replyList);
					that.loadend = loadend;
					that.loading = false;
					that.loadTitle = loadend ? "" : this.$t('page.goodsList.more');
					that.page = that.page + 1;
					that.isShow = true;
				}).catch(err => {
					that.loading = false;
					that.loadTitle = this.$t('page.goodsList.more');
				})
			},
		},
		onReachBottom: function() {
			this.getReplyList();
		}
	}
</script>

<style scoped lang="scss">
	.sku{
		font-size: 24rpx;
		color: #999999;
		margin: 10rpx 0;
	}
	.icon-shangjiadingdan{
		font-size: 28rpx;
	}
	.icon-gengduo{
		font-size: 10rpx;
	}
	.my-order .header {
		height: 250rpx;
		padding: 0 30rpx;
	}
	.my-order .header .picTxt {
		height: 190rpx;
	}

	.my-order .header .picTxt .text {
		color: rgba(255, 255, 255, 0.8);
		font-size: 26rpx;
		font-family: 'Guildford Pro';
	}

	.my-order .header .picTxt .text .name {
		font-size: 34rpx;
		font-weight: bold;
		color: #fff;
		margin-bottom: 20rpx;
	}

	.my-order .header .picTxt .pictrue {
		width: 122rpx;
		height: 109rpx;
	}

	.my-order .header .picTxt .pictrue image {
		width: 100%;
		height: 100%;
	}

	.my-order .nav {
		background-color: #fff;
		border-top: 1px solid #F5F5F5;
		// margin: -60rpx 0 0;
		
	}

	.my-order .nav .item {
		text-align: center;
		font-size: 26rpx;
		color: #282828;
		padding: 26rpx 30rpx;
		display: inline-block;
		background-color: #fff;
	}

	.my-order .nav .item.on {
		/* #ifdef H5 || MP */
		font-weight: bold;
		/* #endif */
		/* #ifdef APP-PLUS */
		color: #000;
		/* #endif */
		position: relative;
	}
	.my-order .nav .item.on ::after{
		content: '';
		width: 78rpx;
		height: 4rpx;
		@include main_bg_color(theme);
		position: absolute;
		bottom: 2rpx;
		left: 30rpx;
	}
	.my-order .nav .item .num {
		margin-top: 18rpx;
	}

	.my-order .list {
		width: 690rpx;
		margin: 14rpx auto 0 auto;
	}

	.my-order .list .item {
		background-color: #fff;
		border-radius: 14rpx;
		margin-bottom: 14rpx;
	}

	.my-order .list .item .title {
		height: 84rpx;
		padding: 0 24rpx;
		border-bottom: 1rpx solid #eee;
		font-size: 28rpx;
		color: #282828;
	}

	.my-order .list .item .title .sign {
		font-size: 24rpx;
		padding: 0 13rpx;
		height: 36rpx;
		margin-right: 15rpx;
		border-radius: 18rpx;
		@include coupons_border_color(theme);
		@include main_color(theme);
	}

	.my-order .list .item .item-info {
		padding: 0 24rpx;
		margin-top: 22rpx;
	}

	.my-order .list .item .item-info .pictrue {
		width: 120rpx;
		height: 120rpx;
	}

	.my-order .list .item .item-info .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 14rpx;
	}

	.my-order .list .item .item-info .text {
		width: 500rpx;
		font-size: 28rpx;
		color: #999;
	}

	.my-order .list .item .item-info .text .name {
		width: 350rpx;
		color: #282828;
	}

	.my-order .list .item .item-info .text .money {
		text-align: right;
	}
	.font_color{
		@include main_color(theme);
	}
	.my-order .list .item .totalPrice {
		font-size: 26rpx;
		color: #282828;
		text-align: right;
		margin: 27rpx 0 0 30rpx;
		padding: 0 30rpx 30rpx 0;
		border-bottom: 1rpx solid #eee;
	}

	.my-order .list .item .totalPrice .money {
		font-size: 28rpx;
		font-weight: bold;
		@include price_color(theme);
	}

	.my-order .list .item .bottom {
		height: 107rpx;
		padding: 0 30rpx;
	}

	.my-order .list .item .bottom .bnt {
		// width: 176rpx;
		height: 60rpx;
		text-align: center;
		line-height: 60rpx;
		@include main_color(theme);
		border-radius: 50rpx;
		font-size: 27rpx;
		padding: 0 30rpx;
		@include coupons_border_color(theme);
	}	

	.my-order .list .item .bottom .bnt.cancelBnt {
		border: 1rpx solid #ddd;
		color: #aaa;
	}

	.my-order .list .item .bottom .bnt~.bnt {
		margin-left: 17rpx;
	}

	.noCart {
		margin-top: 171rpx;
		padding-top: 0.1rpx;
	}

	.noCart .pictrue {
		width: 414rpx;
		height: 336rpx;
		margin: 78rpx auto 56rpx auto;
	}

	.noCart .pictrue image {
		width: 100%;
		height: 100%;
	}
	/deep/.tui-red{
		@include main_bg_color(theme);
	}
	/deep/.tui-red-outline{
		@include main_color(theme);
		@include coupons_border_color(theme);
	}
</style>

