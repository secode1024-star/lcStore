<template>
	<view :data-theme="theme">
		<tui-skeleton v-if="skeletonShow"></tui-skeleton>
		<view class='productList'>
			<view class="bg_color fixed-top">
				<uniNavBar background-color="transparent" color="#fff" :title="$t(`page.store.street`)"
					:border='false' @clickLeft='goback' @clickRight="open">
					<view slot="right" class="iconfont icon-more"></view>
				</uniNavBar>
			</view>
		</view>
		<view class="mp-bg"></view> 
		<view style="position: relative;" class="mt-30">
			<merchant-list :shopPayCurrency="shopPayCurrency" :merchantList="merchantList" :isStreet="true"></merchant-list>
		</view>
		<view class='loadingicon acea-row row-center-wrapper'>
			<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{loadTitle}}
		</view>
		<view class='no-shop' v-if="!merchantList.length && !loading">
			<view class='pictrue' style="margin: 0 auto;">
				<image src='/static/images/no-shop.png'></image>
				<!-- <text>暂无店铺，快去搜索其他店铺吧</text> -->
			</view>
		</view>
		<view v-if="bottomNavigationIsCustom" class="footerBottom"></view>
		<pageFooter></pageFooter>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>		
</template>
<script>
	import {
		getMerStreetApi
	} from '@/api/merchant.js';
	import merchantList from '@/components/merchantList/index.vue'
	import pageFooter from "@/components/pageFooter/index.vue";
	import {
		mapGetters
	} from "vuex";
	let app = getApp();
	export default {
		data() {
			return {
				rightDrawer: false,
				theme: app.globalData.theme,
				where: {
					page: 1,
					limit: 20,
				},
				merchantList: [],
				skeletonShow: false,
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			}
		},
		components: {
			merchantList,
			pageFooter
		},
		computed: mapGetters(['bottomNavigationIsCustom']),
		onLoad: function(options) {
			uni.setNavigationBarTitle({
				title: this.$t(`page.store.street`)
			})
			this.getMerStreet();
		},
		// 滚动监听
		onPageScroll(e) {
		   // 传入scrollTop值并触发所有easy-loadimage组件下的滚动监听事件
		   uni.$emit('scroll');
		},
		methods:{
			goback() {
				uni.navigateBack()
			},
			open() {
				this.rightDrawer = true
			},
			closeDrawer(e) {
				this.rightDrawer = false
				if (!e) {
					this.rightDrawer = false
				}
			},
			goback() {
				uni.navigateBack()
			},
			getMerStreet: function(isPage) {
				let that = this;
				this.skeletonShow = true
				if (that.loadend) return;
				if (that.loading) return;
				if (isPage === true) that.$set(that, 'merchantList', []);
				that.loading = true;
				that.loadTitle = '';
				getMerStreetApi(that.where).then(res => {
					let list = res.data.list;
					let merchantList = that.$util.SplitArray(list, that.merchantList);
					let loadend = list.length < that.where.limit;
					that.loadend = loadend;
					that.loading = false;
					that.loadTitle = loadend ? this.$t('page.goodsList.no') : this.$t('page.goodsList.more');
					that.$set(that, 'merchantList', merchantList);
					that.$set(that.where, 'page', that.where.page + 1);
					this.skeletonShow = false
				}).catch(err => {
					that.loading = false;
					that.loadTitle = this.$t(`page.goodsList.more`);
				});
			},
		}
	}
</script>

<style scoped lang="scss">
	.bg_color {
		@include main_bg_color(theme);
	}
	.mp-bg {
			position: absolute;
			left: 0;
			top: 88rpx;
			width: 100%;
			height: 140rpx;
			@include index-gradient(theme);
	}
	.productList .search {
		width: 100%;
		height: 86rpx;
		padding-left: 30rpx;
		box-sizing: border-box;
		position: fixed;
		top: 88rpx;
		left: 0;
		z-index: 9;
	}
	
	.productList .search .input {
		width: 630rpx;
		height: 60rpx;
		background-color: #fff;
		border-radius: 50rpx;
		padding: 0 20rpx;
		box-sizing: border-box;
	}
	
	.productList .search .input input {
		width: 528rpx;
		height: 100%;
		font-size: 26rpx;
	}
	
	.productList .search .input .placeholder {
		color: #999;
	}
	
	.productList .search .input .iconfont {
		font-size: 35rpx;
		color: #555;
	}
	
	.productList .search .icon-yangshi1 {
		color: #fff;
		width: 62rpx;
		font-size: 40rpx;
		height: 86rpx;
		line-height: 86rpx;
	}
	
</style>
