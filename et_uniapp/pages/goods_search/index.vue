<template>
	<view :data-theme="theme">
		<uniNavBar background-color="#fff" color="#333" :title="$t(`page.goodsSearch.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
			    <view slot="left" class="iconfont icon-dingbufanhui"></view>
			    <view slot="right" class="iconfont icon-more"></view>
		</uniNavBar>
		<view class='searchGood'>
			<view class='search acea-row row-between-wrapper'>
				<view class='input acea-row row-between-wrapper'>
					<text class='iconfont icon-sousuo2'></text>
					<input type='text' :value='searchValue' 
					:focus="focus" :placeholder='$t(`page.goodsSearch.place`)' 
					placeholder-class='placeholder' @input="setValue"></input>
				</view>
				<view class='bnt' @tap='searchBut'>{{$t(`page.goodsSearch.search`)}}</view>
			</view>
			<view class='title'>{{$t(`page.goodsSearch.hotSearch`)}}</view>
			<view class='list acea-row'>
				<block v-for="(item,index) in hotSearchList" :key="index">
					<view class='item' @tap='setHotSearchValue(item.title)'>{{item.title}}</view>
				</block>
			</view>
			<view class='line'></view>
			<goodList :shopPayCurrency="shopPayCurrency" :bastList="bastList" v-if="bastList.length > 0"></goodList>
			<view class='loadingicon acea-row row-center-wrapper' v-if="bastList.length > 0">
				<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{loadTitle}}
			</view>
		</view>
		<view class='noCommodity'>
			<view class='pictrue text-center'  v-if="bastList.length == 0 && isbastList">
				<image src='../../static/images/noSearch.png'></image>
			</view>
			<text class="text-ccc">{{$t(`page.goodsSearch.emptySearch`)}}</text>
			<recommend v-if="bastList.length == 0" :shopPayCurrency="shopPayCurrency"></recommend>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
</template>

<script>
	import {
		getSearchKeyword,
		getProductslist,
		//getProductHot
	} from '@/api/store.js';
	import goodList from '@/components/goodList';
	let app = getApp();
	export default {
		components: {
			goodList
		},
		data() {
			return {
				hostProduct: [],
				searchValue: '',
				focus: true,
				bastList: [],
				hotSearchList: [],
				first: 0,
				limit: 8,
				page: 1,
				loading: false,
				loadend: false,
				loadTitle: this.$t('page.goodsList.more'),
				hotPage:1,
				isScroll:true,
				isbastList: false,
				theme:app.globalData.theme,
				rightDrawer: false,
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		onShow: function() {
			uni.setNavigationBarTitle({
				title: this.$t(`page.goodsSearch.navTitle`)
			})
			this.getRoutineHotSearch();
		},
		onReachBottom: function() {
			if(this.bastList.length>0){
				this.getProductList();
			}
		},
		methods: {
			open(){
				this.rightDrawer = true
			},
			closeDrawer(e) {
				this.rightDrawer = false
				if(!e){
					this.rightDrawer = false
				}
			},
			returns(){
				uni.navigateBack()
			},
			getRoutineHotSearch: function() {
				let that = this;
				getSearchKeyword().then(res => {
					that.$set(that, 'hotSearchList', res.data);
				});
			},
			getProductList: function() {
				let that = this;
				if (that.loadend) return;
				if (that.loading) return;
				that.loading = true;
				that.loadTitle = '';
				getProductslist({
					keyword: that.searchValue,
					page: that.page,
					limit: that.limit
				}).then(res => {
					let list = res.data.list,
						loadend = list.length < that.limit;
					that.bastList = that.$util.SplitArray(list, that.bastList);
					that.$set(that,'bastList',that.bastList);
					that.loading = false;
					that.loadend = loadend;
					that.loadTitle = loadend ? this.$t('page.goodsList.no') : this.$t('page.goodsList.more');
					that.page = that.page + 1;
					that.isbastList = true;
				}).catch(err => {
					that.loading = false,
					that.loadTitle = 'Load More'
				});
			},
			setHotSearchValue: function(event) {
				this.$set(this, 'searchValue', event);
				this.page = 1;
				this.loadend = false;
				this.$set(this, 'bastList', []);
			},
			setValue: function(event) {
				this.$set(this, 'searchValue', event.detail.value);
			},
			searchBut: function() {
				let that = this;
				that.focus = false;
				if (that.searchValue.length > 0) {
					uni.navigateTo({
						url: '/pages/goods_list/index?searchValue=' + that.searchValue
					})
					// that.page = 1;
					// that.loadend = false;
					// that.$set(that, 'bastList', []);
					// uni.showLoading({
					// 	title: this.$t('page.goodsSearch.onSearch')
					// });
					// that.getProductList();
					// uni.hideLoading();
				} else {
					return this.$util.Tips({
						title: this.$t('page.goodsSearch.placeSearch'),
						icon: 'none',
						duration: 1000,
						mask: true,
					});
				}
			}
		}
	}
</script>

<style lang="scss">
	page {
		background-color: #fff !important;
	}

	.searchGood .search {
		padding-left: 20rpx;
		background-color: #fff !important;
	}

	.searchGood .search {
		padding-top: 20rpx;
	}

	.searchGood .search .input {
		width: 580rpx;
		background-color: #f7f7f7;
		border-radius: 33rpx;
		padding: 0 20rpx;
		box-sizing: border-box;
		height: 66rpx;
	}

	.searchGood .search .input input {
		width: 472rpx;
		font-size: 26rpx;
	}

	.searchGood .search .input .placeholder {
		color: #bbb;
	}

	.searchGood .search .input .iconfont {
		color: #000;
		font-size: 35rpx;
	}

	.searchGood .search .bnt {
		width: 148rpx;
		text-align: center;
		height: 66rpx;
		line-height: 66rpx;
		font-size: 30rpx;
		color: #282828;
	}

	.searchGood .title {
		font-size: 28rpx;
		color: #999;
		margin: 50rpx 30rpx 25rpx 30rpx;
	}

	.searchGood .list {
		padding-left: 10rpx;
	}

	.searchGood .list .item {
		font-size: 26rpx;
		color: #454545;
		padding: 0 21rpx;
		height: 60rpx;
		border-radius: 30rpx;
		line-height: 60rpx;
		border: 1rpx solid #aaa;
		margin: 0 0 20rpx 20rpx;
	}

	.searchGood .line {
		border-bottom: 1rpx solid #eee;
		margin: 20rpx 30rpx 0 30rpx;
	}
</style>
