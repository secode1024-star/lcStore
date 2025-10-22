<template>
	<view :data-theme="theme" class="merBox">
		<view class='productList'>
			<view class="bg_color fixed-top">
				<uniNavBar background-color="transparent" color="#fff" :title="$t(`page.goodsList.navTitle`)"
					:border='false' @clickLeft='goback' @clickRight="open(1)">
					<view slot="left" class="iconfont icon-dingbufanhui"></view>
					<view slot="right" class="iconfont icon-more"></view>
				</uniNavBar>
			</view>
			<view class='search bg_color acea-row row-between-wrapper'>
				<view class='input acea-row row-between-wrapper'><text class='iconfont icon-sousuo'></text>
					<input :placeholder='$t(`page.goodsList.search`)' placeholder-class='placeholder'
						confirm-type='search' name="search" :value='where.keyword' @confirm="searchSubmit"
						maxlength="20"></input>
				</view>
				<view v-if="tabIndex===1" class='iconfont icon-yangshi1' @click='Changswitch'></view>
				<view v-else class='iconfont icon-shaixuan' @click='open(2)'></view>
			</view>
			<view class="nav-wrapper" v-if="merId===0">
				<view class="tab-bar">
					<view class="tab-item" :class="{on:tabIndex===1}" @click="changetab(1)">商品</view>
					<view class="tab-item" :class="{on:tabIndex===2}" @click="changetab(2)">店铺</view>
				</view>
			</view>
			<!-- <view class='nav acea-row row-center-wrapper' :class="merId > 0 ? 'mer-nav' : ''">
				<view class='item' :class="[nows===1 ? 'font_color':'', tabIndex===1 ? '':'with50']" @click='set_where(1,tabIndex)'>
					{{title ? title:$t(`page.goodsList.default`)}}</view>
				<view v-if="tabIndex===1" class='item' @click='set_where(2,tabIndex)'>
					{{$t(`page.goodsList.price`)}}
					<image v-if="price==1" src='../../static/images/up.png'></image>
					<image v-else-if="price==2" src='../../static/images/down.png'></image>
					<image v-else src='../../static/images/horn.png'></image>
				</view>
				<view class='item' :class="tabIndex===1 ? '': 'with50'" @click='set_where(3,tabIndex)'>
					{{$t(`page.goodsList.sales`)}}
					<image v-if="stock==1" src='../../static/images/up.png'></image>
					<image v-else-if="stock==2" src='../../static/images/down.png'></image>
					<image v-else src='../../static/images/horn.png'></image>
				</view>
				<view v-if="tabIndex===1" class='item' :class='nows===4 ? "font_color":""' @click='set_where(4,tabIndex)'>{{$t(`page.goodsList.new`)}}</view>
			</view> -->
			<view v-if="tabIndex===1" class='nav acea-row row-center-wrapper' :class="merId > 0 ? 'mer-nav' : ''">
				<view class='item' @click='set_where(1,tabIndex)'>
					{{title ? title:$t(`page.goodsList.default`)}}</view>
				<view class='item' @click='set_where(2,tabIndex)'>
					{{$t(`page.goodsList.price`)}}
					<image v-if="price==1" src='../../static/images/up.png'></image>
					<image v-else-if="price==2" src='../../static/images/down.png'></image>
					<image v-else src='../../static/images/horn.png'></image>
				</view>
				<view class='item' @click='set_where(3,tabIndex)'>
					{{$t(`page.goodsList.sales`)}}
					<image v-if="stock==1" src='../../static/images/up.png'></image>
					<image v-else-if="stock==2" src='../../static/images/down.png'></image>
					<image v-else src='../../static/images/horn.png'></image>
				</view>
				<view class='item' :class='nows===4 ? "font_color":""' @click='set_where(4,tabIndex)'>{{$t(`page.goodsList.new`)}}</view>
			</view>
			<block v-if="tabIndex===1">
				<view :class="[is_switch==true?'':'listBox', merId > 0 ? 'mer-listBox' : '']" v-if="productList.length>0">
					<view class='list acea-row row-between-wrapper' :class="[is_switch==true ? '' : 'on', merId > 0 ? 'mer-list' : ''] ">
						<view class='item' :class='is_switch==true?"":"on"' hover-class='none'
							v-for="(item,index) in productList" :key="index" @click="godDetail(item)">
							<view class='pictrue' :class='is_switch==true?"":"on"'>
								<image :src='item.image' :class='is_switch==true?"":"on"'></image>
							</view>
							<view class='text' :class='is_switch==true?"":"on"'>
								<view class='name line1'>{{item.storeName}}</view>
								<view class='x-money' :class='is_switch==true?"":"on"'>￥<text
										class='num'>{{item.price}}</text></view>
								<view class='vip acea-row row-between-wrapper' :class='is_switch==true?"":"on"'>
									<view class='vip-money' v-if="item.vip_price && item.vip_price > 0">${{item.vip_price}}
										<image src='../../static/images/vip.png'></image>
									</view>
									<view>{{Math.floor(item.sales) + Math.floor(item.ficti) || 0}}{{$t(`message.tips.sold`)}}</view>
								</view>
							</view>
						</view>
					</view>
					<view class='loadingicon acea-row row-center-wrapper' v-if='productList.length > 0'>
						<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{loadTitle}}
					</view>
				</view>
			</block>
		    <block v-if="tabIndex == 2">
		    	<merchant-list :shopPayCurrency="shopPayCurrency" :merchantList="merchantList" v-if="merchantList.length"></merchant-list>
		    	<view class='loadingicon acea-row row-center-wrapper' v-if="goodScroll">
		    		<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{loadTitle}}
		    	</view>
		    </block>
		    <view class='noCommodity' :class="tabIndex == 2?'mer-mt194':''" v-if="(productList.length==0 && where.page > 1 && tabIndex===1) || (merchantList.length==0 && where.page > 1 && tabIndex===2)">
		    	<view class='pictrue text-center'>
		    		<image src='../../static/images/noShopper.png'></image>
		    	</view>
				<text class="text-ccc">{{tabIndex===1?$t(`page.goodsList.empty`):'暂无店铺'}}</text>
		    	<recommend></recommend>
		    </view>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<merSeach @close="closeDrawer"  @confirm="confirm" v-if="tabIndex == 2 && drawers===2"></merSeach>
			<user-drawer @close="closeDrawer" v-else></user-drawer>
		</tui-drawer>
	</view>
</template>

<script>
	import {
		getProductslist
	} from '@/api/store.js';
	import {
		getMerSearchApi
	} from '@/api/merchant.js';
	import merSeach from '@/components/merSeach/index.vue'
	import merchantList from '@/components/merchantList/index.vue'
	import { getMerProListApi } from '@/api/merchant.js'
	import {
		mapGetters
	} from "vuex";
	import {
		goShopDetail
	} from '@/libs/order.js'
	let app = getApp();
	export default {
		computed: mapGetters(['uid']),
		components: {
			merchantList,
			merSeach
		},
		data() {
			return {
				drawers: 0,
				tabIndex: 1,
				productList: [],
				is_switch: true,
				where: {
					keyword: '',
					priceOrder: '',
					salesOrder: '',
					news: 0,
					page: 1,
					limit: 20,
					cid: 0,
					merId: null
				},
				price: 0,
				stock: 0,
				nows: 1,
				loadend: false,
				loading: false,
				loadTitle: this.$t(`page.goodsList.more`),
				title: '',
				hostProduct: [],
				hotPage: 1,
				hotLimit: 10,
				hotScroll: false,
				theme: app.globalData.theme,
				rightDrawer: false,
				whereMer: {
					categoryId: '',
					isSelf: '',
					keywords: '',
					page: 1,
					limit: 20,
					typeId: ''
				},
				merchantList:[],
				merId: 0,
				goodScroll: true,
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		onLoad: function(options) {
			this.merId = options.merId ? Number(options.merId) : 0;
			this.$set(this.where, 'cid', options.cid || 0);
			this.title = options.title || '';
			this.$set(this.where, 'keyword', options.searchValue || '');
			if(this.tabIndex===1)this.get_product_list();
		},
		methods: {
			confirm(data) {
				let arr1 = [],arr2 = []
				if (data.typeIdArry.length == 0) {
					this.whereMer.typeId = ''
				} else {
					data.typeIdArry.forEach(item => {
						arr1.push(item.id)
					})
					let a = JSON.stringify(arr1.join(","))
					this.whereMer.typeId = '3,2';
				}
				
				if (data.categoryIdArry.length == 0) {
					this.whereMer.categoryId = ''
				} else {
					data.categoryIdArry.forEach(item => {
						arr2.push(item.id)
					})
					this.whereMer.categoryId = JSON.stringify(arr2.join(","));
				}
				this.loadend = false;
				this.$set(this.whereMer, 'page', 1)
				this.merchantList = [];
				//this.storeScroll = true
				this.rightDrawer = false
				this.getMerStreet();
			},
			changetab(n){
				this.tabIndex = n;
				this.nows = 1;
				this.stock = 0;
			    this.loadend = false;
				if(n === 2) this.getMerStreet(); this.title = ''
			},
			open(n) {
				this.rightDrawer = true;
				this.drawers = n;
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
				that.setWhere();
				if (that.loadend) return;
				if (that.loading) return;
				that.loading = true;
				if (isPage === true) that.$set(that, 'merchantList', []);
				
				that.loadTitle = '';
				getMerSearchApi(that.whereMer).then(res => {
					let list = res.data.list;
					let merchantList = that.$util.SplitArray(list, that.merchantList);
					let loadend = list.length < that.whereMer.limit;
					that.loadend = loadend;
					that.loadTitle = loadend ? this.$t('page.goodsList.no') : this.$t('page.goodsList.more');
					that.$set(that, 'merchantList', merchantList);
					that.$set(that.whereMer, 'page', that.whereMer.page + 1);
					that.loading = false;
				}).catch(err => {
					that.loading = false;
					that.goodScroll = false;
					that.loadTitle = this.$t(`page.goodsList.more`);
				});
			},
			// 去详情页
			godDetail(item) {
				goShopDetail(item);
			},
			Changswitch: function() {
				let that = this;
				that.is_switch = !that.is_switch
			},
			searchSubmit: function(e) {
				let that = this;
				that.$set(that.where, 'keyword', e.detail.value);
				that.loadend = false;
				that.$set(that.where, 'page', 1)
				this.get_product_list(true);
			},
			/**
			 * 获取我的推荐
			 */
			// get_host_product: function() {
			// 	let that = this;
			// 	if (that.hotScroll) return
			// 	getProductHot(
			// 		that.hotPage,
			// 		that.hotLimit,
			// 	).then(res => {
			// 		that.hotPage++
			// 		that.hotScroll = res.data.length < that.hotLimit
			// 		that.hostProduct = that.hostProduct.concat(res.data)
			// 		// that.$set(that, 'hostProduct', res.data)
			// 	});
			// },
			//点击事件处理
			set_where: function(e, n) {
				this.nows = e;
				switch (e) {
					case 1:
						this.price = 0;
						this.stock = 0;
						break;
					case 2:
						if (this.price == 0) this.price = 1;
						else if (this.price == 1) this.price = 2;
					    else if (this.price == 2) this.price = 1;
						this.stock = 0;
						break;
					case 3:
					    if (this.stock == 0) this.stock = 1;
							else if (this.stock == 1) this.stock = 2;
							else if (this.stock == 2) this.stock = 1;
							this.price = 0
						break;
					case 4:
						this.price = 0;
						this.stock = 0;
						break;
				}
				if(n===1){
					this.loadend = false;
					this.$set(this.where, 'page', 1);
					this.get_product_list(true);
				}else{
					this.nows = 1;
				}
				
			},
			//设置where条件
			setWhere: function() {
				if (this.price == 0) this.where.priceOrder = '';
				else if (this.price == 1) this.where.priceOrder = 'asc';
				else if (this.price == 2) this.where.priceOrder = 'desc';
				if (this.stock == 0) this.where.salesOrder = '';
				else if (this.stock == 1) this.where.salesOrder = 'asc';
				else if (this.stock == 2) this.where.salesOrder = 'desc';
				this.where.news = this.nows===4 ? 1 : 0;
			},
			//查找产品
			get_product_list: function(isPage) {
				let that = this;
				that.setWhere();
				if (that.loadend) return;
				if (that.loading) return;
				if (isPage === true) that.$set(that, 'productList', []);
				that.loading = true;
				that.loadTitle = '';
				if(this.merId > 0) that.where.merId = that.merId
				this.merId === 0 ? getProductslist(that.where).then(res => {
					let list = res.data.list;
					let productList = that.$util.SplitArray(list, that.productList);
					let loadend = list.length < that.where.limit;
					that.loadend = loadend;
					that.loading = false;
					that.loadTitle = loadend ? this.$t('page.goodsList.no') : this.$t('page.goodsList.more');
					that.$set(that, 'productList', productList);
					that.$set(that.where, 'page', that.where.page + 1);
				}).catch(err => {
					that.loading = false;
					that.loadTitle = this.$t(`page.goodsList.more`);
				}): getMerProListApi(that.where).then(res => {
					let list = res.data;
					let productList = that.$util.SplitArray(list, that.productList);
					let loadend = list.length < that.where.limit;
					that.loadend = loadend;
					that.loading = false;
					that.loadTitle = loadend ? this.$t('page.goodsList.no') : this.$t('page.goodsList.more');
					that.$set(that, 'productList', productList);
					that.$set(that.where, 'page', that.where.page + 1);
				}).catch(err => {
					that.loading = false;
					that.loadTitle = this.$t(`page.goodsList.more`);
				})
			},
		},
		onReachBottom() {
			if (this.productList.length > 0) {
				this.get_product_list();
			} else {
				//this.get_host_product();
			}
		}
	}
</script>

<style scoped lang="scss">
	.merBox{
		/deep/.tui-drawer-container{
			width: 635rpx;
		}
	}
	
	.mer{
		&-nav{
			top: 88rpx !important;
			border-radius: inherit !important;
		}
		&-list{
			margin-top: 288rpx !important;
		}
		&-listBox{
			margin-top: 248rpx !important;
		}
		&-mt194{
		    margin-top: 194rpx !important;
	    }
	}
	.no-shop {
		margin-top: 6rpx;
		background-color: #fff;
		padding-bottom: calc(100% - 109rpx);
		.pictrue {
			display: flex;
			flex-direction: column;
			align-items: center;
			//color: $uni-nothing-text;
			image {
				width: 414rpx;
				height: 380rpx;
			}
		}
	}
	.loading{
		//top: 360rpx;
	}
	.store-wrapper{
		 margin-top: 270rpx;
		// position: relative;
		// z-index: 99;
		// top: 242rpx;
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
					width: 92rpx;
					height: 92rpx;
	
					image {
						width: 92rpx;
						height: 92rpx;
						border-radius: 6rpx;
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
						margin-bottom: 10rpx;
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
			margin-top: 30rpx;
	
			.pic-item {
				position: relative;
				width: 214rpx;
				height: 214rpx;
				margin-right: 24rpx;
	
				image {
					width: 214rpx;
					height: 214rpx;
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
	.with50{
		width: 50% !important;
	}
	.nav-wrapper {
		z-index: 9;
		position: fixed;
		left: 0;
		top: 170rpx;
		width: 100%;
		@include main_bg_color(theme);

		.tab-bar {
			display: flex;
			align-items: center;
			height: 100rpx;

			.tab-item {
				position: relative;
				flex: 1;
				display: flex;
				justify-content: center;
				align-items: center;
				padding-bottom: 40rpx;
				color: #fff;
				font-size: 28rpx;
				font-weight: bold;

				&::after {
					content: ' ';
					position: absolute;
					left: 50%;
					bottom: 34rpx;
					width: 60rpx;
					height: 3rpx;
					background: transparent;
					transform: translateX(-50%);
				}

				&.on {
					&::after {
						background: #fff;
					}
				}
			}
		}
	}

	.bg_color {
		@include main_bg_color(theme);
	}

	.font_color {
		@include main_color(theme);
	}

	.x-money {
		@include price_color(theme);
	}

	.iconfont {
		//color: #fff;
	}

	.listBox {
		margin-top: 322rpx;
	}

	.fixed-top {
		position: fixed;
		top: 0;
		left: 0;
		z-index: 9;
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

	.productList .search .icon-yangshi1, .icon-shaixuan {
		color: #fff;
		width: 62rpx;
		font-size: 40rpx;
		height: 86rpx;
		line-height: 86rpx;
	}

	.productList .nav {
		height: 86rpx;
		color: #454545;
		position: fixed;
		left: 0;
		width: 100%;
		font-size: 28rpx;
		background-color: #fff;
		margin-top: 86rpx;
		top: 154rpx;
		z-index: 9;
		border-radius: 16px 16px 0px 0px;
	}

	.productList .nav .item {
		width: 25%;
		text-align: center;
	}

	.productList .nav .item.font-color {
		font-weight: bold;
	}

	.productList .nav .item image {
		width: 15rpx;
		height: 19rpx;
		margin-left: 10rpx;
	}

	.productList .list {
		padding: 10rpx 30rpx 0 30rpx;
		margin-top: 356rpx;
	}

	.productList .list.on {
		border-radius: 14rpx;
		margin-top: 0 !important;
		background-color: #fff;
		// padding: 40rpx 0 0 0;
		border-top: 1px solid #f6f6f6;
		// margin: 20rpx 0;
		// background-color: #fff;
	}

	.productList .list .item {
		width: 335rpx;
		background-color: #fff;
		border-radius: 14rpx;
		margin-bottom: 20rpx;
	}

	.productList .list .item.on {
		width: 100%;
		display: flex;
		padding: 0 0rpx 50rpx 0rpx;
		margin: 0;
		border-radius: 14rpx;
	}

	.productList .list .item .pictrue {
		position: relative;
		width: 100%;
		height: 335rpx;
	}

	.productList .list .item .pictrue.on {
		width: 260rpx;
		height: 260rpx;
	}

	.productList .list .item .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 20rpx 20rpx 0 0;
	}

	.productList .list .item .pictrue image.on {
		border-radius: 6rpx;
	}

	.productList .list .item .text {
		padding: 18rpx 20rpx;
		font-size: 30rpx;
		color: #222;
	}

	.productList .list .item .text.on {
		width: 456rpx;
		padding: 0 0 0 20rpx;
	}

	.productList .list .item .text .money {
		font-size: 26rpx;
		font-weight: bold;
		margin-top: 8rpx;
	}

	.productList .list .item .text .money.on {
		margin-top: 50rpx;
	}

	.productList .list .item .text .money .num {
		font-size: 34rpx;
	}

	.productList .list .item .text .vip {
		font-size: 22rpx;
		color: #aaa;
		margin-top: 7rpx;
	}

	.productList .list .item .text .vip.on {
		margin-top: 12rpx;
	}

	.productList .list .item .text .vip .vip-money {
		font-size: 24rpx;
		color: #282828;
		font-weight: bold;
	}

	.productList .list .item .text .vip .vip-money image {
		width: 46rpx;
		height: 21rpx;
		margin-left: 4rpx;
	}

	.noCommodity {
		background-color: #fff;
		padding-bottom: 30rpx;
		margin-top: 250rpx;
	}
</style>
