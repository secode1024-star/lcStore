<template>
	<view :data-theme="theme">
		<uniNavBar background-color="#fff" color="#333" :title="$t(`page.users.userGoodsCollection.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
			    <view slot="left" class="iconfont icon-dingbufanhui"></view>
			    <view slot="right" class="iconfont icon-more"></view>
		</uniNavBar>
		<view class='collectionGoods' v-if="collectProductList.length">
			<view class='nav acea-row row-between-wrapper'>
				<view><text class='num font_color'>{{ totals }}</text>{{$t(`page.users.userGoodsCollection.item`)}}</view>
				<view class='administrate acea-row row-center-wrapper' @click='manage'>{{ footerswitch ? $t(`page.users.userGoodsCollection.management`) : $t(`page.users.userGoodsCollection.cancel`)}}
				</view>
			</view>
			<view class="list">
				<checkbox-group @change="checkboxChange" class="centent">
					<view v-for="(item,index) in collectProductList" :key="index" class='item acea-row row-middle'>
						<checkbox :value="item.id.toString()" :checked="item.checked" v-if="!footerswitch" style="margin-right: 10rpx;" />
						<navigator :url='"/pages/goods_details/index?id="+item.productId' hover-class='none'
							class="acea-row">
							<view class='pictrue'>
								<image :src="item.image"></image>
							</view>
							<view>
								<view class='name text-overflow-2' :style="{width:(footerswitch ? '464rpx' : '424rpx')}">{{item.storeName}}</view>
								<view class='money'>{{shopPayCurrency}}{{item.price}}</view>
							</view>
						</navigator>
					</view>
				</checkbox-group>
			</view>
			<view class='loadingicon acea-row row-center-wrapper'>
				<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{loadTitle}}
			</view>
			<view v-if="!footerswitch" class='footer acea-row row-between-wrapper'>
				<view>
					<checkbox-group @change="checkboxAllChange">
						<checkbox value="all" :checked="!!isAllSelect" />
						<text class='checkAll'>{{$t(`page.goodsAddcart.selectAll`)}}</text>
					</checkbox-group>
				</view>
				<view class='button acea-row row-middle'>
					<form @submit="delCollectionAll" report-submit='true'>
						<button class='bnt cart-color' formType="submit">{{$t(`page.goodsAddcart.cancel`)}}</button>
					</form>
				</view>
			</view>
		</view>
		<view class='noCommodity' v-else-if="!collectProductList.length && page > 1">
			<view class='pictrue text-center'>
				<image src='../static/noCollection.png'></image> 
			</view>
			<text class="text-ccc">{{$t(`page.users.userGoodsCollection.empty`)}}</text>
			<recommend ref="recommendIndex" :shopPayCurrency="shopPayCurrency"></recommend>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
</template>

<script>
	import {
		getCollectUserList,
		collectDelete
	} from '@/api/store.js';
	import {mapGetters} from "vuex";
	import {toLogin} from '@/libs/login.js';
	let app = getApp();
	export default {
		data() {
			return {
				footerswitch: true,
				hostProduct: [],
				loadTitle: this.$t(`page.goodsList.more`),
				loading: false,
				loadend: false,
				collectProductList: [],
				limit: 10,
				page: 1,
				isAuto: false, //没有授权的不会自动授权
				isShowAuth: false, //是否隐藏授权
				hotScroll: false,
				isAllSelect: false, //全选
				selectValue: [], //选中的数据
				delBtnWidth: 80, //左滑默认宽度
				totals: 0, //收藏商品总条数
				theme:app.globalData.theme,
				rightDrawer: false,
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		computed: mapGetters(['isLogin']),
		onLoad() {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.userGoodsCollection.navTitle`)
			})
			let that = this;
			if (this.isLogin) {
				this.loadend = false;
				this.page = 1;
				this.collectProductList = [];
				this.get_user_collect_product();
			} else {
				toLogin();
			}
		},
		onShow() {
			this.loadend = false;
			this.page = 1;
			this.collectProductList = [];
			this.get_user_collect_product();
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
			manage: function() {
				this.footerswitch = !this.footerswitch;
			},
			returns: function() {
				uni.navigateBack()
			},
			//选中
			checkboxChange: function(event) {
				var items = this.collectProductList,
					values = event.detail.value;
				for (var i = 0, lenI = items.length; i < lenI; ++i) {
					const item = items[i]
					if (values.includes(item.id.toString())) {
						this.$set(item, 'checked', true)
					} else {
						this.$set(item, 'checked', false)
					}
				}
				this.selectValue = values.toString();
				this.isAllSelect = items.length === values.length;
			},
			//选中全部
			checkboxAllChange: function(event) {
				let value = event.detail.value;
				if (value.length > 0) {
					this.setAllSelectValue(1)
				} else {
					this.setAllSelectValue(0)
				}
			},
			//选中值的方法
			setAllSelectValue: function(status) {
				let selectValue = [];
				if (this.collectProductList.length > 0) {
					this.collectProductList.map(item => {
						if (status) {
							this.$set(item, 'checked', true)
							selectValue.push(item.id);
							this.isAllSelect = true;
						} else {
							this.$set(item, 'checked', false)
							this.isAllSelect = false;
						}
					});
					this.selectValue = selectValue.toString();
				}
			},
			/**
			 * 获取收藏产品
			 */
			get_user_collect_product: function() {
				let that = this;
				if (this.loading) return;
				if (this.loadend) return;
				that.loading = true;
				that.loadTitle = "";
				getCollectUserList({
					page: that.page,
					limit: that.limit
				}).then(res => {
					res.data.list.map(item => {
						that.$set(item, 'right', 0);
					});
					let collectProductList = res.data.list;
					that.page = that.page + 1;
					let loadend = that.page > res.data.pages;
					that.collectProductList = that.$util.SplitArray(collectProductList, that
						.collectProductList);
					that.$set(that, 'collectProductList', that.collectProductList);
					
					that.totals = res.data.total;
					that.loadend = loadend;
					that.loadTitle = loadend ? this.$t('page.goodsList.nono') : this.$t('page.goodsList.more');
					
					that.loading = false;
					
				}).catch(err => {
					that.loading = false;
					that.loadTitle = this.$t('page.goodsList.more');
				});
			},
			/**
			 * 取消收藏
			 */
			delCollection: function(id, index) {
				this.selectValue = id;
				this.del({
					ids: this.selectValue.toString()
				});
			},
			delCollectionAll: function() {
				if (!this.selectValue || this.selectValue.length == 0) return this.$util.Tips({
					title: this.$t(`message.tips.changeGoods`) 
				});
				this.del({
					ids: this.selectValue
				});
			},
			del: function(data) {
				collectDelete(data).then(res => {
					this.$util.Tips({
						title: this.$t(`message.login.calSU`),
						icon: 'success'
					});
					this.selectValue = [];
					this.loadend = false;
					this.page = 1;
					this.collectProductList = [];
					this.get_user_collect_product();
				}).catch(err => {
					return this.$util.Tips({
						title: err
					})
				});
			}
		},
		/**
		 * 页面上拉触底事件的处理函数
		 */
		onReachBottom() {
			this.get_user_collect_product();
			this.$refs.recommendIndex.get_host_product();
		}
	}
</script>

<style scoped lang="scss">
	.money{
		font-size: 36rpx;
		font-family: D-DIN-Bold, D-DIN;
		font-weight: bold;
		@include price_color(theme);
	}
	.order-item {
		width: 100%;
		display: flex;
		position: relative;
		align-items: right;
		flex-direction: row;
	}

	.remove {
		width: 120rpx;
		height: 40rpx;
		@include main_bg_color(theme);
		color: #fff;
		position: absolute;
		bottom: 30rpx;
		right: 60rpx;
		display: flex;
		justify-content: center;
		align-items: center;
		font-size: 24rpx;
	}

	.collectionGoods {
		.nav {
			height: 74rpx;
			background-color: #fff;
			padding: 0 30rpx;
			box-sizing: border-box;
			font-size: 28rpx;
			color: #282828;
			border-bottom: 1px solid #EEEEEE;
		}

		.centent {
			background-color: #fff;
			border-bottom-left-radius: 14rpx;
			border-bottom-right-radius: 14rpx;
		}
	}

	.collectionGoods .item {
		background-color: #fff;
		padding-left: 30rpx;
		height: 248rpx;
		border-bottom: 1px solid #eee;
	}
	.collectionGoods .item .name {
		margin-bottom: 78rpx;
	}
	.collectionGoods .item .pictrue {
		width: 200rpx;
		height: 200rpx;
		margin-right: 24rpx;
	}

	.collectionGoods .item .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 10rpx;
	}

	.collectionGoods .item .text {
		width: 535rpx;
		height: 130rpx;
		font-size: 28rpx;
		color: #282828;
	}

	.collectionGoods .item .text .name {
		width: 100%;
	}

	.collectionGoods .item .text .delete {
		font-size: 26rpx;
		color: #282828;
		width: 144rpx;
		height: 46rpx;
		border: 1px solid #bbb;
		border-radius: 4rpx;
		text-align: center;
		line-height: 46rpx;
	}

	.noCommodity {
		background-color: #fff;
		padding-top: 1rpx;
		border-top: 0;
	}

	.footer {
		z-index: 9;
		width: 100%;
		height: 96rpx;
		background-color: #fff;
		position: fixed;
		padding: 0 30rpx;
		box-sizing: border-box;
		border-top: 1rpx solid #eee;
		border-bottom: 1px solid #EEEEEE;
		/* #ifdef H5 || MP */
		bottom: 0rpx;
		/* #endif */
		/* #ifdef APP-PLUS */
		bottom: 0;

		/* #endif */
		/* #ifndef MP || APP-PLUS */
		// bottom: 98rpx;
		// bottom: calc(98rpx+ constant(safe-area-inset-bottom)); ///兼容 IOS<11.2/
		// bottom: calc(98rpx + env(safe-area-inset-bottom)); ///兼容 IOS>11.2/
		/* #endif */
		.checkAll {
			font-size: 28rpx;
			color: #282828;
			margin-left: 16rpx;
		}

		.button .bnt {
			font-size: 28rpx;
			color: #999;
			border-radius: 30rpx;
			border: 1px solid #999;
			width: 160rpx;
			height: 60rpx;
			text-align: center;
			line-height: 60rpx;
		}
	}
	.font_color{
		@include main_color(theme);
	}
	/deep/ checkbox .uni-checkbox-input.uni-checkbox-input-checked {
		@include main_bg_color(theme);
		@include coupons_border_color(theme);
		color: #fff!important
	}
	
	/deep/ checkbox .wx-checkbox-input.wx-checkbox-input-checked {
		@include main_bg_color(theme);
		@include coupons_border_color(theme);
		color: #fff!important;
		margin-right: 0 !important;
	}
</style>
