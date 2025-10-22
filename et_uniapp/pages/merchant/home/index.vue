<template>
	<div class="store-home productSort"
		:style="{ 'background-image': `linear-gradient(360deg, rgba(0, 0, 0, 0.5) 0%, rgba(0, 0, 0, 0.9) 100%),url(${merchantInfo.backImage})` }">
		<!-- <tui-skeleton v-if="skeletonShow"></tui-skeleton> -->
		<view class="fixed-top">
			<uniNavBar background-color="transparent" color="#333" :border='false' @clickLeft='returns'
				@clickRight="open">
				<view class="header">
					<view class="input" @click="search()">
						<text class="iconfont icon-sousuo"></text>
						<text class="place">search</text>
					</view>
				</view>
				<view slot="left" class="iconfont icon-dingbufanhui"></view>
				<view slot="right" class="iconfont icon-more"></view>
			</uniNavBar>
		</view>

		<view v-show="navShow && tabActive === 0" class="nav acea-row">
			<view class="nav-cont">
				<view :class="{ active: navActive === 0 }" class="item" @click='set_where(1)'>
					<view class="cont">
						{{ $t(`page.goodsList.default`) }}
					</view>
				</view>
				<view :class="{ active: navActive === 1 }" class="item" @click="set_where(2)">
					<view class="cont">
						{{$t(`page.goodsList.price`)}}
						<image v-if="price==1" src='../../../static/images/up.png'></image>
						<image v-else-if="price==2" src='../../../static/images/down.png'></image>
						<image v-else src='../../../static/images/horn.png'></image>
					</view>
				</view>
				<view :class="{ active: navActive === 2 }" class="item" @click="set_where(3)">
					<view class="cont">
						{{$t(`page.goodsList.sales`)}}
						<image v-if="stock==1" src='../../../static/images/up.png'></image>
						<image v-else-if="stock==2" src='../../../static/images/down.png'></image>
						<image v-else src='../../../static/images/horn.png'></image>
					</view>
				</view>
			</view>
			<view :class="{ active: navActive === 3 }" class="item" @click="navActive = 3;isColumn = !isColumn">
				<view class="cont">
					<text :class="['layout-icon', 'iconfont', isColumn ? 'icon-yangshi1' : 'icon-yangshi2']"></text>
				</view>
			</view>
		</view>

		<scroll-view class="main" scroll-y="true" @scroll="scrollHome">
			<merHome :merchantInfo="merchantInfo" :merid="merid" type="detail"></merHome>
			<view v-show="!navShow && tabActive === 0" class="nav acea-row row-between">
				<view class="nav-cont">
					<view :class="{ active: navActive === 0 }" class="item" @click='set_where(1)'>
						<view class="cont tui-skeleton-rect">
							{{ $t(`page.goodsList.default`) }}
						</view>
					</view>
					<view :class="{ active: navActive === 1 }" class="item" @click="set_where(2)">
						<view class="cont tui-skeleton-rect">
							{{$t(`page.goodsList.price`)}}
							<image v-if="price==1" src='../../../static/images/up.png'></image>
							<image v-else-if="price==2" src='../../../static/images/down.png'></image>
							<image v-else src='../../../static/images/horn.png'></image>
						</view>
					</view>
					<view :class="{ active: navActive === 2 }" class="item" @click="set_where(3)">
						<view class="cont tui-skeleton-rect">
							{{$t(`page.goodsList.sales`)}}
							<image v-if="stock==1" src='../../../static/images/up.png'></image>
							<image v-else-if="stock==2" src='../../../static/images/down.png'></image>
							<image v-else src='../../../static/images/horn.png'></image>
						</view>
					</view>
				</view>
				<view :class="{ active: navActive === 3 }" class="item" @click="navActive = 3;isColumn = !isColumn"
					style="margin-left: 80rpx;">
					<view class="cont tui-skeleton-rect">
						<text :class="['layout-icon', 'iconfont', isColumn ? 'icon-yangshi1' : 'icon-yangshi2']"></text>
					</view>
				</view>
			</view>
			<view class="tab-cont">
				<!-- 商品 -->
				<view v-show="tabActive === 0" class="productList">
					<view v-if="productList.length" id="goods" @touchmove="onTouchmove">
						<view v-if="!isColumn" class='list acea-row row-between-wrapper'
							:class='isColumn==true?"":"on"'>
							<view class='item' :class='isColumn==true?"":"on"' hover-class='none'
								v-for="(item,index) in productList" :key="index" @click="godDetail(item)">
								<view class='pictrue' :class='isColumn==true?"":"on"'>
									<easy-loadimage mode="widthFix" :image-src="item.image"></easy-loadimage>
								</view>
								<view class='text' :class='isColumn==true?"":"on"'>
									<view class='name line3'>{{item.storeName}}</view>
									<!-- <view v-if="!isColumn" class='couponActivity'>$500</view> -->
									<view class='money acea-row row-between-wrapper' :class='isColumn==true?"":"on"'>
										<text class='num'>{{shopPayCurrency}}{{item.price}}</text>
										<view class="sold">{{ (Math.floor(item.sales) + Math.floor(item.ficti)) || 0 }}
											{{$t(`message.tips.sold`)}}</view>
									</view>
								</view>
							</view>
						</view>
						<view v-else class="goods">
							<WaterfallsFlow :shopPayCurrency="shopPayCurrency" :wfList='productList' :type="1"
								:isStore="1" />
						</view>
					</view>
					<view class='loadingicon acea-row row-center-wrapper'>
						<text class='loading iconfont icon-jiazai' :hidden='goodsLoading==false'></text>{{loadTitle}}
					</view>

				</view>
				<!-- 分类 -->
				<view v-show="tabActive === 1">
					<view class="category">
						<view v-for="item in category" :key="item.id" class="section">
							<view class="head" @click="goCategoryGoods(item.id)">
								<view class="title">{{ item.name }}</view>
								<view class="iconfont icon-xuanze"></view>
							</view>
							<view v-if="item.childList" class="body">
								<view v-for="value in item.childList" :key="value.id" class="item"
									@click="goCategoryGoods(value.id)">{{ value.name }}</view>
							</view>
						</view>
					</view>
					<view :hidden="!categoryLoading" class="acea-row row-center-wrapper loadingicon">
						<text class="iconfont icon-jiazai loading"></text>{{loadTitle}}
					</view>
				</view>

				<!-- 优惠券 -->
				<view v-show="tabActive === 2" class="couponBox">
					<view class="acea-row row-around navCoupon">
						<template>
							<view v-for="(item,index) in navList" :key="index"
								:class="['acea-row', 'row-middle', type === item.type ? 'on' : '']">
								<text
									@click="setType(item.type)">{{$t(`page.users.userCoupon.navList[${index}].name`)}}</text>
							</view>
						</template>
					</view>
					<view v-if="couponsList.length" class="coupon coupon-list">
						<view v-for="item in couponsList" :key="item.id" class="item">
							<!-- :class="{gary:item.isUse}" -->
							<view class="money" :class='item.isUse?"moneyGray":"main_bg"'>
								<view class="">
									{{shopPayCurrency}}
									<text class="num">{{ item.money }}</text>
								</view>
								<view class="pic-num" v-if="parseFloat(item.minPrice)>0">
									{{shopPayCurrency}}{{ item.minPrice?Number(item.minPrice):'' }}
									{{$t(`page.users.userCoupon.min`)}}</view>
							</view>
							<view class="right">
								<view class="name">
									<text :class="item.isUse?'gary':'font-color'">{{item.useType===1?$t(`page.users.userCoupon.navList[0].name`):$t(`page.users.userCoupon.navList[1].name`)}}</text>

									{{ item.name }}
								</view>
								<view class="time-wrap" style="justify-content: space-between;">
									<block v-if="item.isFixedTime">
										<view class="time">
											{{ item.useStartTimeStr | dateFormat }}-{{ item.useEndTimeStr | dateFormat }}
										</view>
									</block>
									<block v-else>
										<view>
											{{$t(`page.users.userCoupon.receivedInfo`)+ item.day+ $t(`page.users.userCoupon.receivedInfo1`)}}
										</view>
									</block>
									<block v-if="item.isUse">
										<view class="button bg-color-hui">{{$t(`page.users.userCoupon.received`)}}</view>
									</block>
									<block v-else>
										<view class="button bg-color" @click="receiveCoupon(item)">
											{{$t(`page.users.userCoupon.receive`)}}</view>
									</block>
								</view>
							</view>
						</view>
					</view>
					<view class='loadingicon acea-row row-center-wrapper'>
						<text class='loading iconfont icon-jiazai'
							:hidden='loadingcoupon==false'></text>{{couponsList.length?loadTitle:''}}
					</view>
					<emptyPage v-if="couponsList.length == 0 && !loadingcoupon" title="暂无优惠券~"></emptyPage>
				</view>
			</view>
		</scroll-view>

		<view class="footer">
			<view v-for="(item, index) in tabs" :key="index" :class="{ active: tabActive === index }" class="item"
				@click="onChangeTab(index)">
				<view :class="['iconfont', item.icon]"></view>
				<view>{{ item.name }}</view>
			</view>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</div>
</template>

<script>
	import {
		getMerCategoryApi,
		getMerDetailApi,
		getMerCollectAddApi,
		getMerCollectCancelApi,
		getMerIndexInfoApi,
		getMerProListApi
	} from '@/api/merchant.js';
	import WaterfallsFlow from '@/components/WaterfallsFlow/WaterfallsFlow.vue'
	import {
		mapGetters
	} from "vuex";
	import {
		getCoupons,
		setCouponReceive
	} from '@/api/api.js';
	import {
		toLogin
	} from '@/libs/login.js';
	import emptyPage from '@/components/emptyPage.vue'
	import Cache from '@/utils/cache';
	import merHome from '@/components/merHome/index.vue'
	import {
		goShopDetail
	} from '@/libs/order.js'
	import {
		chatConfig
	} from '@/utils/consumerType.js'
	let app = getApp();
	export default {
		components: {
			WaterfallsFlow,
			emptyPage,
			merHome
		},
		computed: {
			...mapGetters(["merchantClassify", "merchantType", 'isLogin', 'uid']),
		},
		// 滚动监听
		onPageScroll(e) {
			// 传入scrollTop值并触发所有easy-loadimage组件下的滚动监听事件
			uni.$emit('scroll');
		},
		data() {
			return {
				navList: [{
						type: 1,
						name: '商家券',
						count: 0
					},
					{
						type: 2,
						name: '商品券',
						count: 0
					}
				],
				type: 1,
				mer_banner: '../images/store.png',
				couponsList: [],
				loadTitle: this.$t(`page.goodsList.more`),
				categoryLoading: false,
				category: [],
				// 底部菜单
				tabs: [{
						icon: 'icon-yizhan_o',
						name: this.$t(`page.store.index`),
					},
					{
						icon: 'icon-yingyongAPP_o',
						name: this.$t(`page.store.classify`)
					},
					{
						icon: 'icon-huobiliu_o',
						name: this.$t(`page.store.collar`)
					},
					{
						icon: 'icon-kefu_o',
						name: this.$t(`page.store.call`)
					}
				],
				productList: [],
				scrollTop: 0,
				merchantInfo: {},
				sortPrice: '',
				skeletonShow: true, //骨架屏显示隐藏
				rightDrawer: false,
				navShow: false,
				navActive: 0,
				tabActive: 0, // 底部切换
				isColumn: true, // 商品列表排列方式
				stock: 0,
				merid: 0,
				price: 0,
				where: {
					keyword: '',
					priceOrder: '',
					salesOrder: '',
					page: 1,
					limit: 20,
					cid: 0,
					merId: 0
				},
				loading: false,
				loadend: false,
				goodsLoading: false,
				loadendcoupon: false,
				loadingcoupon: false,
				page: 1,
				limit: 10,
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			}
		},
		watch: {
			tabActive: function(value, old) {
				switch (value) {
					case 0:
						this.getGoods();
						break;
					case 1:
						if (this.service_open) {
							this.get_service_list();
						}
						break;
					case 2:
						this.getCoupon();
						break;
				}
			}

		},
		onLoad(options) {
			this.merid = parseInt(options.id)
		},
		mounted: function() {
			this.$store.dispatch('MerTypeList');
			const query = uni.createSelectorQuery().in(this);
			query.select('#store').boundingClientRect(data => {
				this.storeHeight = data.height;
				this.storeTop = data.top;
			}).exec();
			this.getMerIndexInfo();
			this.getGoods();
			this.getMerCategory();
		},
		methods: {
			// 领取优惠券
			receiveCoupon(item) {
				let that = this;
				if (that.isLogin === false) {
					toLogin();
				} else {
					uni.showLoading({
						title: this.$t(`message.tips.loding`)
					});

					setCouponReceive(item.id).then(res => {
						uni.showToast({
							title: res.message,
							icon: 'none'
						})
						uni.hideLoading();
						item.isUse = !item.isUse
					}).catch(err => {
						uni.showToast({
							title: err,
							icon: 'none'
						})
						uni.hideLoading();
					})
				}
			},
			setType: function(type) {
				if (this.type !== type) {
					this.type = type;
					this.couponsList = [];
					this.page = 1;
					this.loadendcoupon = false;
					this.getCoupon();
				}
			},
			onTouchmove(e) {
				if (this.loadend) return;
				if (this.loading) return;
				if (this.goodsLoading) return;
				const query = uni.createSelectorQuery().in(this);
				query.select('#goods').boundingClientRect(data => {
					if (data.bottom < 1500 && data.top < 0) {
						this.getGoods();
					}
				}).exec();
				// 模拟触底刷新
			},
			getMerIndexInfo() {
				let that = this;
				getMerIndexInfoApi(this.merid).then(res => {
					this.merchantInfo = res.data
					uni.setNavigationBarTitle({
						title: res.data.name
					})
					this.$store.commit('MERCHANTJINFO', res.data);
					this.skeletonShow = false;
				}).catch(err => {
					that.loading = false;
					that.loadTitle = this.$t(`page.goodsList.more`);
					this.skeletonShow = false;
				});
			},
			getMerCategory() {
				getMerCategoryApi(this.merid).then(res => {
					this.category = res.data
				}).catch(err => {
					return this.$util.Tips({
						title: err
					});
				});
			},
			goCategoryGoods(id) {
				uni.navigateTo({
					url: '/pages/goods_list/index?merId=' + this.merid + '&cid=' + id
				})
				// this.onClear();
				// this.where.cid = id;
				// this.getGoods();
				// this.tabActive = 0;
			},
			// 去详情页
			godDetail(item) {
				goShopDetail(item);
			},
			// 获取商铺优惠券
			getCoupon: function() {
				let that = this
				if (that.loadendcoupon) return false;
				if (that.loadingcoupon) return false;
				that.loadingcoupon = true;
				getCoupons({
					page: that.page,
					limit: that.limit,
					useType: this.type,
					merId: this.merid
				}).then(res => {
					let list = res.data.list,
						loadend = list.length < that.limit;
					let couponsList = that.$util.SplitArray(list, that.couponsList);
					that.$set(that, 'couponsList', couponsList);
					that.loadendcoupon = loadend;
					that.loadTitle = loadend ? this.$t('page.goodsList.no') : this.$t('page.goodsList.more');
					that.page = that.page + 1;
					that.loadingcoupon = false;
					that.isShow = true;
				}).catch(err => {
					that.loadingcoupon = false;
					that.loadTitle = this.$t('page.goodsList.more');
				});
			},
			// 选择条件展示商品
			set_where: function(param) {
				this.onClear();
				switch (param) {
					case 1:
						this.price = 0;
						this.stock = 0;
						this.navActive = 0;
						break;
					case 2:
						if (this.price == 0) this.price = 1;
						else if (this.price == 1) this.price = 2;
						else if (this.price == 2) this.price = 1;
						this.stock = 0;
						this.navActive = 1;
						break;
					case 3:
						if (this.stock == 0) this.stock = 1;
						else if (this.stock == 1) this.stock = 2;
						else if (this.stock == 2) this.stock = 1;
						this.price = 0
						this.navActive = 2;
						break;
					case 4:
						this.price = 0;
						this.stock = 0;
						this.navActive = 3;
						break;
				}
				this.getGoods();
			},
			//重置数据
			onClear() {
				this.loading = false;
				this.loadend = false;
				this.where = {
					keyword: '',
					priceOrder: '',
					salesOrder: '',
					page: 1,
					limit: 20,
					cid: 0
				};
			},
			//主页商品列表
			getGoods() {
				let that = this;
				if (that.loadend) return;
				if (that.goodsLoading) return;
				that.goodsLoading = true;
				this.where.merId = this.merid
				if (this.price == 0) this.where.priceOrder = '';
				else if (this.price == 1) this.where.priceOrder = 'asc';
				else if (this.price == 2) this.where.priceOrder = 'desc';
				if (this.stock == 0) this.where.salesOrder = '';
				else if (this.stock == 1) this.where.salesOrder = 'asc';
				else if (this.stock == 2) this.where.salesOrder = 'desc';
				that.loadTitle = '';
				getMerProListApi(that.where).then(res => {
					let list = res.data.list;
					let goodsList = that.$util.SplitArray(list, that.goods);
					let loadend = list.length < that.where.limit;
					that.loadend = loadend;
					that.goodsLoading = false;
					that.loadTitle = loadend ? this.$t('page.goodsList.no') : this.$t('page.goodsList.more');
					that.$set(that, 'productList', goodsList);
					that.$set(that.where, 'page', that.where.page + 1);
				}).catch(err => {
					that.goodsLoading = false;
					uni.showToast({
						title: err,
						icon: 'none'
					})
					setTimeout(function() {
						//uni.navigateBack()
					}, 1000);
				});
			},
			// 商铺底部切换
			onChangeTab: function(param) {
				this.tabActive = param;
				this.onClear()
				if (param === 3) chatConfig('mer');
			},
			stickyChange: function(e) {
				let index = e.index;
				this.lists[index].stickyTop = e.top;
			},
			// 商铺首页滚动 navbar 吸顶
			scrollHome: function(e) {

				uni.$emit('scroll');
				this.navShow = e.detail.scrollTop >= this.storeHeight - 50;
			},
			closeDrawer() {
				this.rightDrawer = false
			},
			open() {
				this.rightDrawer = true
			},
			search() {
				uni.navigateTo({
					url: '/pages/goods_list/index?merId=' + this.merid
				})
			},
			returns() {
				uni.navigateBack()
			},
		},
		onReachBottom() {
			// 模拟触底刷新
			if (this.tabActive == 0) {
				setTimeout(() => {
					this.productList.push(...this.productList);
				}, 500)
			}
		},
		onPullDownRefresh() {
			// 模拟上拉刷新
			setTimeout(() => {
				const newList = this.productList.reverse();
				this.productList = newList;
				uni.stopPullDownRefresh();
			}, 500)
		}
	}
</script>

<style lang="scss" scoped>
	.font-color {
		@include main_color(theme);
		@include coupons_border_color(theme);
	}
	
	.pic-num {
		color: #fff;
		font-size: 24rpx;
	}

	.main_bg {
		@include main_bg_color(theme);
	}

	.select {
		@include main_color(theme);
		@include coupons_border_color(theme);
	}

	.sold {
		font-size: 26rpx;
		color: #888888;
	}

	.navCoupon {
		width: 100%;
		height: 106rpx;
		color: #999999;
		background-color: #fff;
	}

	.navCoupon .acea-row {
		border-top: 5rpx solid transparent;
		border-bottom: 5rpx solid transparent;
		cursor: pointer;
	}

	.navCoupon .acea-row.on {
		@include tab_border_bottom(theme);
		@include main_color(theme);
	}

	.tab-cont {
		background: #f5f5f5;
		min-height: 500rpx;
	}

	.couponBox {
		/deep/.empty-box {
			padding-top: 200rpx;
			margin-top: 0 !important;
		}
	}

	.main {
		flex: 1;
		min-height: 0rpx;
		height: calc(100vh - var(--window-top)); //calc()是动态计算函数
	}

	.font-bg-red {
		padding: 4rpx;
		@include main_bg_color(theme);
		color: #fff;
		font-size: 18rpx;
		display: inline-block;
		border-radius: 4rpx;
	}

	.goods {
		display: flex;
		flex-wrap: wrap;
		justify-content: space-between;
		padding-top: 20rpx;
		padding-left: 30rpx;
		background-color: #F5F5F5;
		width: 100%;
	}

	.coupon {
		padding: 30rpx;
		background-color: #F5F5F5;

		.item {
			display: flex;
			margin-bottom: 16rpx;

			.left {
				display: flex;
				flex-direction: column;
				justify-content: center;
				align-items: center;
				width: 240rpx;
				font-weight: 500;
				font-size: 24rpx;
				line-height: 1;
				color: #FFFFFF;

				&.gary {
					background-image: url('data:image/png;base64,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');
				}

				.money {
					text {
						margin-left: 10rpx;
						font-size: 60rpx;
					}
				}
			}

			.right {
				flex: 1;
				min-width: 0;
				padding-right: 18rpx;
				padding-left: 27rpx;
				background-color: #FFFFFF;

				.name {
					padding-top: 32rpx;
					padding-bottom: 32rpx;
					border-bottom: 1rpx solid #F0F0F0;
					font-weight: 500;
					font-size: 30;
					line-height: 1;
					color: #282828;

					text {
						display: inline-block;
						height: 28rpx;
						border-radius: 14rpx;
						margin-right: 15rpx;
						background-color: #FFF4F3;
						font-weight: 500;
						font-size: 20rpx;
						line-height: 26rpx;
						text-align: center;
						padding: 0 6rpx;

						.font-color {
							@include main_color(theme);
							@include coupons_border_color(theme);
						}

						&.gary {
							border: 1px solid #BBB;
							color: #bbb;
							background-color: #F5F5F5;
						}
					}
				}

				.time-wrap {
					display: flex;
					align-items: center;
					padding-top: 16rpx;
					padding-bottom: 16rpx;
					font-weight: 500;
					font-size: 20rpx;
					color: #999999;

					.time {
						flex: 1;
						min-width: 0;
					}

					.button {
						width: 136rpx;
						height: 44rpx;
						border-radius: 22rpx;
						font-weight: 500;
						font-size: 22rpx;
						line-height: 44rpx;
						text-align: center;
						color: #FFFFFF;

						&.gary {
							background-color: #999;
						}
					}
				}
			}
		}

		.disabled {
			.left {
				background-image: url(../images/coupon2.png);
			}

			.right {
				.name {
					text {
						border-color: #C1C1C1;
						color: #C1C1C1;
					}
				}

				.time-wrap {
					.button {
						background-color: #CCCCCC;
						color: #FFFFFF;
					}
				}
			}
		}
	}

	.category {
		padding-top: 34rpx;
		padding-right: 20rpx;
		padding-left: 20rpx;

		.section {
			border-radius: 10rpx;
			margin-bottom: 20rpx;
			background-color: #FFFFFF;

			.head {
				position: relative;
				display: flex;
				align-items: center;
				height: 90rpx;
				padding-right: 20rpx;
				padding-left: 36rpx;
				font-weight: bold;
				color: #282828;

				&::before {
					content: " ";
					position: absolute;
					top: 50%;
					left: 20rpx;
					width: 6rpx;
					height: 24rpx;
					@include main_bg_color(theme);
					transform: translateY(-50%);
				}

				.title {
					flex: 1;
					min-width: 0;
					overflow: hidden;
					white-space: nowrap;
					text-overflow: ellipsis;
					font-size: 30rpx;
				}

				.iconfont {
					font-size: 22rpx;
					line-height: 1;
				}
			}

			.body {
				display: flex;
				flex-wrap: wrap;
				justify-content: space-between;
				align-items: center;
				padding: 9rpx 36rpx 14rpx;

				.item {
					width: 314rpx;
					height: 84rpx;
					padding-right: 30rpx;
					padding-left: 30rpx;
					border-radius: 10rpx;
					background-color: #F5F5F5;
					margin-bottom: 10rpx;
					overflow: hidden;
					white-space: nowrap;
					text-overflow: ellipsis;
					font-weight: 500;
					font-size: 26rpx;
					line-height: 84rpx;
					color: #282828;
				}
			}
		}
	}

	.footer {
		position: fixed;
		bottom: 0;
		left: 0;
		z-index: 999;
		display: flex;
		width: 100%;
		height: 100rpx;
		background-color: #FFFFFF;
		opacity: 0.96;

		.item {
			flex: 1;
			display: flex;
			flex-direction: column;
			justify-content: center;
			align-items: center;
			font-weight: 500;
			font-size: 20rpx;
			color: #282828;

			.iconfont {
				font-size: 43rpx;
			}
		}

		.active {
			@include main_color(theme);
		}
	}

	.productList {
		background: #f5f5f5;

		.list {
			padding: 30rpx;
		}
	}

	.productList .list.on {
		border-radius: 14rpx;
		margin-top: 0 !important;
		background-color: #fff;
		padding: 40rpx 0 0 0;

	}

	.productList .list .item {
		width: 335rpx;
		background-color: #fff;
		border-radius: 14rpx;
		margin-bottom: 20rpx;
	}

	.productList .list.item {
		&::before {
			content: " ";
			position: absolute;
			top: 0;
			right: 10px;
			left: 125px;
			border-top: 0.5px solid #f5f5f5;
		}
	}

	.productList .list .item.on {
		width: 100%;
		display: flex;
		padding: 0 24rpx 60rpx 24rpx;
		margin: 0;
		border-radius: 14rpx;
	}

	.productList .list .item .pictrue {
		position: relative;
		width: 100%;
		height: 335rpx;
	}

	.productList .list .item .pictrue.on,
	.easy-loadimage,
	image,
	uni-image {
		width: 260rpx;
		height: 260rpx;
	}

	.productList .list .item .pictrue image.on {
		border-radius: 6rpx;
	}

	.productList .list .item .text.on {
		width: 456rpx;
		padding: 0 0 0 20rpx;
	}

	.productList .list .item .text .name {
		font-size: 28rpx;
		font-weight: bold;
		margin-top: 8rpx;
		color: #333333;
		margin-bottom: 30rpx;
	}

	.productList .list .item .text .money.on {
		margin-top: 50rpx;
	}

	.productList .list .item .text .money .num {
		font-size: 38rpx;
		font-weight: 900;
		@include price_color(theme);
	}

	.productList .list .item .text .y-money {
		font-size: 26rpx;
		color: #888888;
		text-decoration: line-through;
		margin-left: 14rpx;
	}

	.store-home-top {
		width: 100%;
		height: 360rpx;
		//background: linear-gradient(360deg, rgba(0, 0, 0, 0) 0%, #000000 40%, #000000 100%);
		position: relative;
	}

	.store-home {
		position: fixed;
		top: 0;
		right: 0;
		bottom: 0;
		left: 0;
		display: flex;
		flex-direction: column;
		padding-bottom: 100rpx;
		background: left top/750rpx 360rpx no-repeat fixed;
		overflow: hidden;
	}

	.fixed-top {
		// position: fixed;
		top: 0;
		left: 0;
		z-index: 9;
	}

	.nav.fixed {
		position: fixed;
		left: 0;
		width: 100%;

		.nav-cont {
			position: absolute;
			width: 80%;
			justify-content: space-between;
		}
	}

	.nav {
		position: relative;
		padding: 0 30rpx;

		.nav-cont {
			width: 80%;
			display: flex;
			align-items: center;
			justify-content: space-between;
			height: 84rpx;
		}

		.item {
			// flex: 1;
			display: flex;
			justify-content: center;
			align-items: center;
			min-width: 0;

			.cont {
				display: flex;
				justify-content: center;
				align-items: center;
				padding: 0 12rpx;
				height: 44rpx;
				border-radius: 22rpx;
				font-weight: 500;
				font-size: 24rpx;
				color: #FFFFFF;

				.arrow-icon {
					margin-left: 10rpx;
					font-size: 18rpx;
				}

				.layout-icon {
					font-size: 32rpx;
				}

				.icon-pailie {
					font-size: 32rpx;
				}

				image {
					width: 15rpx;
					height: 21rpx;
					margin-left: 7rpx;
				}
			}
		}

		.active {
			.cont {
				background-color: #FFFFFF;
				font-weight: bold;
				@include main_color(theme);
			}
		}

		.select {
			position: absolute;
			top: 100%;
			left: 0;
			z-index: 2;
			width: 100%;
			padding-right: 40rpx;
			padding-bottom: 28rpx;
			padding-left: 74rpx;
			border-bottom-right-radius: 24rpx;
			border-bottom-left-radius: 24rpx;
			background-color: #FFFFFF;

			.item {
				margin-top: 28rpx;
				font-size: 24rpx;
				color: #454545;
			}

			.active {
				//background: url(../../../static/images/active.png) right center/20rpx no-repeat;
				color: #E93323;
			}
		}
	}


	.icon-dingbufanhui,
	.icon-more {
		color: #fff;
	}

	.productSort .header .input {
		width: 558rpx;
		height: 60rpx;
		background-color: #3F4244;
		border-radius: 50rpx;
		box-sizing: border-box;
		padding: 0 30rpx;
		display: flex;
		align-items: center;
	}

	.productSort .header .input .iconfont {
		font-size: 26rpx;
		color: #666;
	}

	.productSort .header .input .place {
		padding-left: 12rpx;
		color: #ccc;
		font-size: 26rpx;
	}
</style>