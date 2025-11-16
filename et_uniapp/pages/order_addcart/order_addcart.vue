<template>
	<view :data-theme="theme">
		<view class="main_bg">
			<uniNavBar background-color="transparent" color="#fff" :title="$t(`page.goodsAddcart.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
				    <view slot="right" class="iconfont icon-more"></view>
			</uniNavBar>
		</view>
		<view class='shoppingCart copy-data' @touchstart="touchStart">
			<view class='labelNav'>
				<view
					v-if="(cartList.valid.length === 0 && cartList.invalid.length === 0) || (cartList.valid.length > 0)"
					class='acea-row row-between-wrapper'>
					<view>{{$t(`page.goodsAddcart.buyNum`)}} <text class='num'>{{cartCount}}</text></view>
					<view v-if="cartList.valid.length > 0 || cartList.invalid.length > 0"
						class='administrate acea-row row-center-wrapper' @click='manage'>{{ footerswitch ? $t(`page.goodsAddcart.management`) : $t(`page.goodsAddcart.cancel`)}}
					</view>
				</view>
			</view>
			<view class="borRadius14 cartBox">
				<view v-if="cartList.valid.length > 0 || cartList.invalid.length > 0" class="pad30">
					<view class='list'>
						<view v-for="(itemn,index) in cartList.valid" :key="index" class="mb30">
							<view class="store-title nav">
								<view class="checkbox" @click="storeAllCheck(itemn,index)">
									<text v-if="!itemn.allCheck" class="iconfont icon-weixuan"></text>
									<text v-else class="iconfont icon-xuanzhong11"></text>
								</view>
								<navigator :url="'/pages/merchant/home/index?id='+itemn.merId " class="info acea-row">
									<text class="iconfont icon-shangjiadingdan"></text>
									<view class="name">{{itemn.merName}}</view>
									<text class="iconfont icon-gengduo"></text>
								</navigator>
							</view>
							<block v-for="(item,indexn) in itemn.cartInfoList" >
								<view class='item acea-row row-between-wrapper'>
									<view class="checkbox" @click.stop="goodsCheck(item,indexn)">
										<text v-if="!item.check" class="iconfont icon-weixuan"></text>
										<text v-else class="iconfont icon-xuanzhong11"></text>
									</view>
									<navigator :url='"/pages/goods_details/index?id="+item.productId' hover-class='none'
										class='picTxt acea-row row-between-wrapper'> 
									    <view class='pictrue'>
											<easy-loadimage mode="widthFix" :image-src="item.image" ></easy-loadimage>
										</view>
										<view class='text'>
											<view class='line1' :class="item.attrStatus?'':'reColor'">{{item.storeName}}
											</view>
											<view class='infor line1' v-if="item.suk">{{$t(`page.goodsAddcart.attribute`)}}：{{item.suk}}</view>
											<view class='money mt-28' v-if="item.attrStatus">{{shopPayCurrency}}{{item.vipPrice ? item.vipPrice :item.price}}</view>
											<view class="reElection acea-row row-between-wrapper" v-else>
												<view class="title">{{$t(`page.goodsAddcart.again`)}}</view>
												<view class="reBnt cart-color acea-row row-center-wrapper"
													@click.stop="reElection(item)">{{$t(`page.goodsAddcart.reselect`)}}</view>
											</view>
										</view>
										<view class='carnum acea-row row-center-wrapper' v-if="item.attrStatus">
											<view class="reduce" :class="item.numSub ? 'on' : ''"
												@click.stop='subCart(item)'>-</view>
											<view class='num'>{{item.cartNum}}</view>
											<view class="plus" :class="item.numAdd ? 'on' : ''"
												@click.stop='addCart(item)'>+</view>
										</view>
									</navigator>
								</view>
							</block>
						</view>
					</view>
					<view v-if="cartList.invalid.length > 0" class='invalidGoods borRadius14'
						:style="cartList.valid.length===0 && cartList.invalid.length > 0 ? 'position: relative;z-index: 111;top: 0rpx;':'position: static;'">
						<view class='goodsNav acea-row row-between-wrapper'>
							<view v-if="cartList.invalid.length > 1 || cartList.valid.length > 0" @click='goodsOpen'>
								<text class='iconfont'
									:class='goodsHidden==true?"icon-xiangxia":"icon-xiangshang"'></text>{{$t(`page.goodsAddcart.failureGoods`)}}
							</view>
							<view v-else>
								{{$t(`page.goodsAddcart.failureGoods`)}}
							</view>
							<view class='del' @click='unsetCart'><text class='iconfont icon-shanchu1'></text>{{$t(`page.goodsAddcart.empty`)}}</view>
						</view>
						<view class='goodsList' :hidden='goodsHidden'>
							<block v-for="(itemn,indexn) in cartList.invalid" :key='indexn'>
								<view v-for="(item,index) in itemn.cartInfoList" :key='index'>
									<view class='item acea-row row-between-wrapper'>
										<view class='invalid'>{{$t(`page.goodsAddcart.failure`)}}</view>
										<view class='picTxt acea-row row-between-wrapper'>
											<view class='pictrue'>
												<easy-loadimage mode="widthFix" :image-src="item.image" ></easy-loadimage>
											</view>
											<view class='text acea-row row-column-between'>
												<view class='line1 name'>{{item.storeName}}</view>
												<view class='infor line1' v-if="item.suk">{{$t(`page.goodsAddcart.attribute`)}}：{{item.suk}}</view>
												<view class='acea-row row-between-wrapper'>
													<view class='end'>{{$t(`page.goodsAddcart.fallDesc`)}}</view>
												</view>
											</view>
										</view>
									</view>
								</view>
							</block>
						</view>
					</view>
				</view>
				<view class='loadingicon acea-row row-center-wrapper'>
					<text class='loading iconfont icon-jiazai'
						:hidden='loading==false'></text>
				</view>
				<view class='noCart' v-if="(cartList.valid.length == 0 && cartList.invalid.length == 0 && canShow && !loading) || !isLogin">
					<view class='pictrue text-center'>
						<image src='../../static/images/noCart.png'></image>
					</view>
					<text class="text-ccc">{{$t(`page.goodsAddcart.emptyCart`)}}</text>
					<recommend :shopPayCurrency="shopPayCurrency" ref="recommendIndex"></recommend>
				</view>
			</view>
		</view>
		<view v-if="cartList.valid.length > 0" :class="bottomNavigationIsCustom?'footerTop':''" class='footer acea-row row-between-wrapper'>
			<view>
				<view class="allcheckbox" @click.stop="checkboxAllChange">
					<text v-if="!isAllSelect" class="iconfont icon-weixuan"></text>
					<text v-else class="iconfont icon-xuanzhong11"></text>
					{{$t(`page.goodsAddcart.selectAll`)}} ({{cartCount}})
				</view>
			</view>
			<view class='money acea-row row-middle' v-if="footerswitch==true">
				<text class='price-color'>{{shopPayCurrency}}{{selectCountPrice}}</text>
				<form @submit="subOrder" report-submit='true'>
					<button class='placeOrder bg_color' formType="submit">{{$t(`page.goodsAddcart.buyNow`)}}</button>
				</form>
			</view>
			<view class='button acea-row row-middle' v-else>
				<form @submit="subCollect" report-submit='true'>
					<button class='btn_cart_color' formType="submit">{{$t(`page.goodsAddcart.like`)}}</button>
				</form>
				<form @submit="subDel" report-submit='true'>
					<button class='bnt' formType="submit">{{$t(`page.goodsAddcart.delete`)}}</button>
				</form>
			</view>
		</view>
		 <!-- 底部导航距离，做兼容处理的-->
		<view v-if="bottomNavigationIsCustom" class="footerBottom"></view>
		<!-- 底部导航 -->
		<pageFooter></pageFooter>
		<productWindow :attr="attr" :isShow='1' :iSplus='1' :iScart='1' @myevent="onMyEvent" @ChangeAttr="ChangeAttr"
			@ChangeCartNum="ChangeCartNum" @attrVal="attrVal" @iptCartNum="iptCartNum" @goCat="reGoCat"
			id='product-window'></productWindow>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
</template>

<script>
	import {
		getCartList,
		getCartCounts,
		changeCartNum,
		cartDel,
		getResetCart
	} from '@/api/order.js';
	import {
		getProductHot,
		collectAll,
		getProductDetail
	} from '@/api/store.js';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import productWindow from '@/components/productWindow';
	import recommend from '@/components/base/recommend.vue';
	import pageFooter from "@/components/pageFooter/index.vue";
	import {Debounce} from '@/utils/validate.js'
	let app = getApp();
	export default {
		components: {
			productWindow,
			recommend,
			pageFooter
		},
		data() {
			return {
				cartCount: 0,
				goodsHidden: false,
				footerswitch: true,
				hostProduct: [],
				cartList: {
					valid: [],
					invalid: []
				},
				isAllSelect: false, //全选
				selectValue: [], //选中的数据
				selectCountPrice: 0.00,
				isAuto: false, //没有授权的不会自动授权
				isShowAuth: false, //是否隐藏授权
				hotScroll: false,
				hotPage: 1,
				hotLimit: 10,
				loading: false,
				loadend: false,
				loadTitle: this.$t(`page.goodsList.more`), //提示语
				page: 1,
				limit: 20,
				loadingInvalid: false,
				loadendInvalid: false,
				loadTitleInvalid: this.$t(`page.goodsList.more`), //提示语
				pageInvalid: 1,
				limitInvalid: 20,
				attr: {
					cartAttr: false,
					productAttr: [],
					productSelect: {}
				},
				productValue: [], //系统属性
				productInfo: {},
				attrValue: '', //已选属性
				attrTxt: this.$t(`page.goodsDetail.choose1`), //属性页面提示
				cartId: 0,
				product_id: 0,
				canShow: false,
				configApi: {}, //分享类容配置
				theme:app.globalData.theme,
				navH:"",
				homeTop: 20,
				currentPage:false,
				rightDrawer: false,
				// 购物车总数
				cartTotalCount:0,
				newVal: {},
				goods: {},
				currSku: '',
				shopPayCurrency: app.globalData.shopPayCurrency //货币符号
			};
		},
		
		computed: mapGetters(['isLogin','bottomNavigationIsCustom']),
		// 滚动监听
		onPageScroll(e) {
		   // 传入scrollTop值并触发所有easy-loadimage组件下的滚动监听事件
		   uni.$emit('scroll');
		},
		onLoad: function(options) {
			uni.setNavigationBarTitle({
				title: this.$t(`page.goodsAddcart.navTitle`)
			})
			let that = this;
			// if (that.isLogin == false) {
			// 	toLogin();
			// }
			// #ifdef MP
			that.navH = app.globalData.navHeight;
			// #endif
			// #ifndef MP
			that.navH = 96;
			// #endif
		},
		onReady() {
			this.$nextTick(function() {
				// #ifdef MP
				const menuButton = uni.getMenuButtonBoundingClientRect();
				const query = uni.createSelectorQuery().in(this);
				query
					.select('#home')
					.boundingClientRect(data => {
						this.homeTop = menuButton.top * 2 + menuButton.height - data.height;
					})
					.exec();
				// #endif
			});
		},
		onShow: function() {
			this.canShow = false
			if (this.isLogin == true) {
				this.hotPage = 1;
				this.hostProduct = [],
				this.hotScroll = false,
				this.loadend = false;
				this.loading= false;
				this.page = 1;
				this.cartList.valid = [];
				this.getCartList();
				this.loadendInvalid = false;
				this.pageInvalid = 1;
				this.cartList.invalid = [];
				this.getInvalidList();
				//this.getCartNum();
				this.footerswitch = true;
				this.hotScroll = false;
				this.hotPage = 1;
				this.hotLimit = 10;
				this.cartList = {
						valid: [],
						invalid: []
					},
					this.isAllSelect = false; //全选
				this.selectValue = []; //选中的数据
				this.selectCountPrice = 0.00;
				this.cartCount = 0;
				this.isShowAuth = false;
			};
		},
		methods: {
			// 授权关闭
			authColse: function(e) {
				this.isShowAuth = e;
			},
			// 修改购物车
			reGoCat: function() {
				let that = this,
					productSelect = that.productValue[this.attrValue];
				//如果有属性,没有选择,提示用户选择
				if (
					that.attr.productAttr.length &&
					productSelect === undefined
				)
					return that.$util.Tips({
						title: "产品库存不足，请选择其它"
					});

				let q = {
					id: that.cartId,
					productId: that.product_id,
					num: that.attr.productSelect.cart_num,
					unique: that.attr.productSelect !== undefined ?
						that.attr.productSelect.unique : that.productInfo.id
				};
				getResetCart(q)
					.then(function(res) {
						that.attr.cartAttr = false;
						that.$util.Tips({
							title: this.$t(`message.tips.shoppingSU`),
							success: () => {
								that.loadend = false;
								that.page = 1;
								that.cartList.valid = [];
								that.getCartList();
								that.getCartNum();
							}
						});
					})
					.catch(res => {
						return that.$util.Tips({
							title: res
						});
					});
			},
			onMyEvent: function() {
				this.$set(this.attr, 'cartAttr', false);
			},
			reElection: function(item) {
				this.getGoodsDetails(item)
			},
			/**
			 * 获取产品详情
			 * 
			 */
			getGoodsDetails: function(item) {
				uni.showLoading({
					title: this.$t(`message.tips.loding`),
					mask: true
				});
				let that = this;
				that.cartId = item.id;
				that.product_id = item.productId;
				getProductDetail(item.productId).then(res => {
					uni.hideLoading();
					that.attr.cartAttr = true;
					let productInfo = res.data.productInfo;
					that.$set(that, 'productInfo', productInfo);
					// that.$set(that.attr, 'productAttr', res.data.productAttr);
					that.$set(that, 'productValue', res.data.productValue);
					let productAttr = res.data.productAttr.map(item => {
					return {
						attrName : item.attrName,
						attrValues: item.attrValues.split(','),
						id:item.id,
						isDel:item.isDel,
						productId:item.productId,
						type:item.type
					 }
					});
					this.$set(that.attr,'productAttr',productAttr);
					that.DefaultSelect();
				}).catch(err => {
					uni.hideLoading();
				})
			},
			/**
			 * 属性变动赋值
			 * 
			 */
			ChangeAttr: function(res) {
				let productSelect = this.productValue[res];
				if (productSelect && productSelect.stock > 0) {
					this.$set(this.attr.productSelect, "image", productSelect.image);
					this.$set(this.attr.productSelect, "price", productSelect.price);
					this.$set(this.attr.productSelect, "stock", productSelect.stock);
					this.$set(this.attr.productSelect, "unique", productSelect.id);
					this.$set(this.attr.productSelect, "cart_num", 1);
					this.$set(this, "attrValue", res);
					this.$set(this, "attrTxt", this.$t(`page.goodsDetail.choose`));
				} else {
					this.$set(this.attr.productSelect, "image", this.productInfo.image);
					this.$set(this.attr.productSelect, "price", this.productInfo.price);
					this.$set(this.attr.productSelect, "stock", 0);
					this.$set(this.attr.productSelect, "unique", this.productInfo.id);
					this.$set(this.attr.productSelect, "cart_num", 0);
					this.$set(this, "attrValue", "");
					this.$set(this, "attrTxt", this.$t(`page.goodsDetail.choose1`));
				}
			},
			/**
			 * 默认选中属性
			 * 
			 */
			DefaultSelect: function() {
				let productAttr = this.attr.productAttr;
				let value = [];
				for (let key in this.productValue) {
					if (this.productValue[key].stock > 0) {
						value = this.attr.productAttr.length ? key.split(",") : [];
						break;
					}
				}
				for (let i = 0; i < productAttr.length; i++) {
					this.$set(productAttr[i], "index", value[i]);
				}
				//sort();排序函数:数字-英文-汉字；
				let productSelect = this.productValue[value.sort().join(",")];
				if (productSelect && productAttr.length) {
					this.$set(
						this.attr.productSelect,
						"storeName",
						this.productInfo.storeName
					);
					this.$set(this.attr.productSelect, "image", productSelect.image);
					this.$set(this.attr.productSelect, "price", productSelect.price);
					this.$set(this.attr.productSelect, "stock", productSelect.stock);
					this.$set(this.attr.productSelect, "unique", productSelect.id);
					this.$set(this.attr.productSelect, "cart_num", 1);
					this.$set(this, "attrValue", value.sort().join(","));
					this.$set(this, "attrTxt", this.$t(`page.goodsDetail.choose`));
				} else if (!productSelect && productAttr.length) {
					this.$set(
						this.attr.productSelect,
						"storeName",
						this.productInfo.storeName
					);
					this.$set(this.attr.productSelect, "image", this.productInfo.image);
					this.$set(this.attr.productSelect, "price", this.productInfo.price);
					this.$set(this.attr.productSelect, "stock", 0);
					this.$set(this.attr.productSelect, "unique", this.productInfo.id);
					this.$set(this.attr.productSelect, "cart_num", 0);
					this.$set(this, "attrValue", "");
					this.$set(this, "attrTxt", this.$t(`page.goodsDetail.choose1`));
				} else if (!productSelect && !productAttr.length) {
					this.$set(
						this.attr.productSelect,
						"storeName",
						this.productInfo.storeName
					);
					this.$set(this.attr.productSelect, "image", this.productInfo.image);
					this.$set(this.attr.productSelect, "price", this.productInfo.price);
					this.$set(this.attr.productSelect, "stock", this.productInfo.stock);
					this.$set(
						this.attr.productSelect,
						"unique",
						this.productInfo.id || ""
					);
					this.$set(this.attr.productSelect, "cart_num", 1);
					this.$set(this, "attrValue", "");
					this.$set(this, "attrTxt", this.$t(`page.goodsDetail.choose1`));
				}
			},
			attrVal(val) {
				this.$set(this.attr.productAttr[val.indexw], 'index', this.attr.productAttr[val.indexw].attrValues[val
					.indexn]);
			},
			/**
			 * 购物车数量加和数量减
			 * 
			 */
			ChangeCartNum: function(changeValue) {
				//changeValue:是否 加|减
				//获取当前变动属性
				let productSelect = this.productValue[this.attrValue];
				//如果没有属性,赋值给商品默认库存
				if (productSelect === undefined && !this.attr.productAttr.length)
					productSelect = this.attr.productSelect;
				//无属性值即库存为0；不存在加减；
				if (productSelect === undefined) return;
				let stock = productSelect.stock || 0;
				let num = this.attr.productSelect;
				if (changeValue) {
					num.cart_num++;
					if (num.cart_num > stock) {
						this.$set(this.attr.productSelect, "cart_num", stock ? stock : 1);
						this.$set(this, "cart_num", stock ? stock : 1);
					}
				} else {
					num.cart_num--;
					if (num.cart_num < 1) {
						this.$set(this.attr.productSelect, "cart_num", 1);
						this.$set(this, "cart_num", 1);
					}
				}
			},
			/**
			 * 购物车手动填写
			 * 
			 */
			iptCartNum: function(e) {
				this.$set(this.attr.productSelect, 'cart_num', e);
			},
			subDel: function(event) {
				let selectValue = []
				this.cartList.valid.forEach(el=>{
					el.cartInfoList.forEach(goods=>{
						if(goods.check){
							selectValue.push(goods.id)
						}
					})
				})
				if (selectValue.length > 0)
					cartDel(selectValue).then(res => {
						this.loadend = false;
						this.page = 1;
						this.cartList.valid = [];
						this.getCartList();
						this.getCartNum();
					});
				else
					return this.$util.Tips({
						title: this.$t(`message.tips.changeGoods`)
					});
			},
			getSelectValueProductId: function() {
				let that = this;
				let validList = that.cartList.valid;
				let selectValue = that.selectValue;
				let productId = [];
				if (selectValue.length > 0) {
					for (let index in validList) {
						if (that.inArray(validList[index].id, selectValue)) {
							productId.push(validList[index].productId);
						}
					}
				};
				return productId;
			},
			subCollect: function(event) {
				let that = this
				let type_id = []
				this.cartList.valid.forEach(el=>{
					el.cartInfoList.forEach(goods=>{
						if(goods.check){
							type_id.push(goods.productId)
						}
					})
				})
				if (type_id.length > 0) {
					let selectValueProductId = that.getSelectValueProductId();
					collectAll(type_id).then(res => {
						return that.$util.Tips({
							title: '收藏成功',
							icon: 'success'
						});
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					});
				} else {
					return that.$util.Tips({
						title: this.$t(`message.tips.changeGoods`)
					});
				}
			},
			// 立即下单
			subOrder: Debounce(function(event) {
				uni.showLoading({
					title: this.$t(`message.tips.loding`)
				});

				this.cartList.valid.forEach(el=>{
					el.cartInfoList.forEach(goods=>{
						if(goods.check){
							this.selectValue.push(goods.id)
						}
					})
				})
				if (this.selectValue.length > 0) {
					this.getPreOrder();
				} else {
					return this.$util.Tips({
						title: this.$t(`message.tips.changeGoods`)
					});
				}
			}),
			/**
			 * 预下单
			 */
			getPreOrder: function() {
				let shoppingCartId = this.selectValue.map(item => {
					return {
						"shoppingCartId": Number(item)
					}
				})
				this.$Order.getPreOrder("shoppingCart", shoppingCartId);
			},
			inArray: function(search, array) {
				for (let i in array) {
					if (array[i] == search) {
						return true;
					}
				}
				return false;
			},
			switchSelect: function() {
				let that = this;
				let validList = that.cartList.valid;
				let selectValue = that.selectValue;
				let selectCountPrice = 0.00;
				if (selectValue.length < 1) {
					that.selectCountPrice = selectCountPrice;
				} else {
					for (let index in validList) {
						if (that.inArray(validList[index].id, selectValue)) {
							selectCountPrice = that.$util.$h.Add(selectCountPrice, that.$util.$h.Mul(validList[index]
								.cartNum, validList[index].vipPrice ? validList[index].vipPrice : validList[index].price))
						}
					}
					that.selectCountPrice = selectCountPrice;
				}
			},
			/**
			 * 购物车手动填写
			 * 
			 */
			iptCartNum: function(index) {
				let item = this.cartList.valid[index];
				if (item.cartNum) {
					this.setCartNum(item.id, item.cartNum);
				}
				this.switchSelect();
			},
			blurInput: function(index) {
				let item = this.cartList.valid[index];
				if (!item.cartNum) {
					item.cartNum = 1;
					this.$set(this.cartList, 'valid', this.cartList.valid)
				}
			},
			subCart: function(goods) {
				let that = this;
				let status = false;
				if (goods.cartNum < 1) status = true;
				if (goods.cartNum <= 1) {
					goods.cartNum = 1;
					goods.numSub = true;
					status = true;
				} else {
					if (false == status) {
						changeCartNum(goods.id, Number(goods.cartNum) - 1).then(res => {
							goods.numSub = false;
							goods.numAdd = false;
							if(goods.cartNum <= 1){
								goods.numSub = true;
							}
							goods.cartNum = Number(goods.cartNum) - 1
							this.cartTotalCount = Number(this.cartTotalCount) - 1;
							this.cartAllCheck('goodsCheck')
						}).catch(error => {
							this.$util.Tips({
								title: error
							});
						})
					}
				}
			},
			addCart: function(goods) {
				let that = this;
				
				changeCartNum(goods.id, goods.cartNum + 1).then(res => {
					goods.cartNum = Number(goods.cartNum) + 1
					that.cartTotalCount = Number(that.cartTotalCount) + 1;
					if (goods.hasOwnProperty('productAttr') && goods.cartNum > goods.stock) {
						goods.cartNum = goods.stock;
						goods.numAdd = true;
						goods.numSub = false;
						return
					} else {
						goods.numAdd = false;
						goods.numSub = false;
					}
					this.cartAllCheck('goodsCheck')
				}).catch(error => {
					that.$util.Tips({
						title: error
					});
					
				})
			},
			setCartNum(cartId, cartNum, successCallback) {
				let that = this;
				changeCartNum(cartId, cartNum).then(res => {
					successCallback && successCallback(res.data);
				});
			},
			getCartNum: function() {
				let that = this;
				getCartCounts(true, 'sum').then(res => {
					that.cartCount = res.data.count;
				});
			},
			// 商铺全选
			storeAllCheck(item, index) {
				// 店铺取消
				if (item.allCheck) {
					item.allCheck = false
					item.cartInfoList.forEach((el, index) => {
						el.check = false
					})
				} else {
					item.allCheck = true
					item.cartInfoList.forEach((el, index) => {
						el.check = true
					})
				}
				this.cartAllCheck('goodsCheck')
			},
			// 商品选中
			goodsCheck(goods) {
				goods.check = !goods.check
				this.cartAllCheck('goodsCheck')
			},
			// 全选判断
			cartAllCheck(type) {
				let allArr = [];
				let totalMoney = 0
				let totalNum = 0
				this.cartList.valid.forEach((el, index) => {
					if (type == 'goodsCheck') {
						let tempArr = el.cartInfoList.filter(goods => {
							return goods.check == true
						})
						if (el.cartInfoList.length == tempArr.length) {
							el.allCheck = true
							allArr.push(el)
						} else {
							el.allCheck = false
						}
					} else {
						el.cartInfoList.forEach((goods) => {
							goods.check = this.isAllSelect
						})
						el.allCheck = this.isAllSelect
						if (el.allCheck) allArr.push(el)
					}
					// 总金额 //总数
					el.cartInfoList.forEach(e => {
						if (e.check) {
							totalMoney = this.$util.$h.Add(totalMoney, this.$util.$h.Mul(e.price, e.cartNum))
							totalNum += e.cartNum
						}
					})
				})
				this.cartCount = totalNum
				this.selectCountPrice = totalMoney
				// 全选
				this.isAllSelect = allArr.length == this.cartList.valid.length ? true : false
			},
			// 购物车全选
			checkboxAllChange() {
				this.isAllSelect = !this.isAllSelect
				this.cartAllCheck('cartCheck')
			},
			getCartList() {
				if (this.loading) return false;
				let data = {
					page: this.page,
					limit: this.limit,
					isValid: true
				}
				this.loading = true;
				getCartList(data).then(res => {
					let valid = res.data;
					valid.forEach((item, index) => {
						item.allCheck = true
						item.cartInfoList.forEach((goods, j) => {
							goods.check = true
							if (goods.cartNum == 1) {
								goods.numSub = true;
							} else {
								goods.numSub = false;
							}
							if (goods.cartNum == goods.stock) {
								goods.numAdd = true;
							} else {
								goods.numAdd = false;
							}
						})
					})
					this.$set(this.cartList, 'valid', valid);
					this.checkboxAllChange()
					this.loading = false;
					if(this.cartList.valid)this.canShow = true;
					uni.hideLoading();
				});
			},
			getInvalidList: function() {
				if (this.loadingInvalid) return false;
				let data = {
					page: this.pageInvalid,
					limit: this.limitInvalid,
					isValid: false
				}
				//this.canShow = false
				getCartList(data).then(res => {
					let invalid = res.data;
					this.$set(this.cartList, 'invalid', invalid);
					this.loadingInvalid = false;
				}).catch(res => {
					this.loadingInvalid = false;
				})

			},
			goodsOpen: function() {
				let that = this;
				that.goodsHidden = !that.goodsHidden;
			},
			manage: function() {
				let that = this;
				that.footerswitch = !that.footerswitch;
			},
			unsetCart: function() {
				let that = this,
					ids = [];
					this.cartList.invalid.forEach((el, index) => {
						el.cartInfoList.forEach(e => {
							ids.push(e.id);
						})
					})
				cartDel(ids).then(res => {
					that.$util.Tips({
						title: this.$t(`message.login.delSU`)
					});
					that.$set(that.cartList, 'invalid', []);
				}).catch(res => {
					that.$util.Tips({
						title: res
					});
				});
			},
			
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
			touchStart(){
				this.currentPage = false;
			}
		},
		//触底分页加载
		onReachBottom() {
			let that = this;
			if (that.loadend) {
				that.getInvalidList();
			}
			if ((that.cartList.valid.length == 0 && that.cartList.invalid.length == 0 && !that.loading)) {
			   that.$refs.recommendIndex.get_host_product();
			}
		}
	}
</script>

<style scoped lang="scss">
	.footerTop {
		bottom: 98rpx !important;
		bottom: calc(98rpx + constant(safe-area-inset-bottom)) !important; ///兼容 IOS<11.2/
		bottom: calc(98rpx + env(safe-area-inset-bottom)) !important; ///兼容 IOS>11.2/
	}
	.icon-gengduo{
		font-size: 20rpx;
	}
	.invalidClas {
		position: relative;
		z-index: 111;
		top: -120rpx;
	}

	.invalidClasNO {
		position: static;
		margin-top: 15px;
	}
	.store-title {
		display: flex;
		align-items: center;
		width: 100%;
		padding: 0 30rpx;
		height: 85rpx;
		border-bottom: 1px solid #f0f0f0;
		.info{
			margin-left: 28rpx;
			align-items: center;
		}
		.name{
			margin-left: 8rpx;
		}
	}

	.cartBox {
		    position: relative;
		    top: -88rpx;
	}
	.main_bg{
		@include main_bg_color(theme);
	}
	
	.px-20{
		padding: 0 20rpx 0;
	}
	.pl-20{
		padding-left: 20rpx;
	}
	.justify-center{
		justify-content: center;
	}
	.align-center {
		align-items: center;
	}
	.shoppingCart {
		width: 100%;
	}

	.shoppingCart .labelNav {
		height: 178rpx;
		padding: 34rpx 30rpx 0 ;
		font-size: 22rpx;
		color: #fff;
		width: 100%;
		box-sizing: border-box;
		@include main_bg_color(theme);
		z-index: 5;
	}

	.shoppingCart .labelNav .item .iconfont {
		font-size: 26rpx;
		margin-right: 10rpx;
	}

	.shoppingCart .nav {

		height: 90rpx;
		background-color: #fff;
		padding: 0 24rpx;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
		font-size: 28rpx;
		color: #282828;
		z-index: 6;
		border-top-left-radius: 14rpx;
		border-top-right-radius: 14rpx;
	}

	.shoppingCart .nav .num {
		margin-left: 12rpx;
	}

	.shoppingCart .nav .administrate {
		font-size: 28rpx;
		color: #333333;
	}

	.shoppingCart .noCart {
		background-color: #fff;
		padding-top: 0.1rpx;
	}

	.shoppingCart .noCart .pictrue {
		width: 414rpx;
		height: 336rpx;
		margin: 78rpx auto 56rpx auto;
	}

	.shoppingCart .noCart .pictrue image {
		width: 100%;
		height: 100%;
	}

	.shoppingCart .list {
		width: 100%;
		overflow: hidden;
		border-bottom-left-radius: 14rpx;
		border-bottom-right-radius: 14rpx;
	}
	

	.shoppingCart .list .item {
		padding: 24rpx;
		background-color: #fff;
		border-bottom-left-radius: 7px;
		border-bottom-right-radius: 7px;
	}

	.shoppingCart .list .item .picTxt {
		width: 582rpx;
		position: relative;
	}

	.shoppingCart .list .item .picTxt .pictrue {
		width: 160rpx;
		height: 160rpx;
	}

	.shoppingCart .list .item .picTxt .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 6rpx;
	}

	.shoppingCart .list .item .picTxt .text {
		width: 396rpx;
		font-size: 28rpx;
		color: #282828;
	}

	.shoppingCart .list .item .picTxt .text .reColor {
		color: #999;
	}

	.shoppingCart .list .item .picTxt .text .reElection {
		margin-top: 20rpx;
	}

	.shoppingCart .list .item .picTxt .text .reElection .title {
		font-size: 24rpx;
	}

	.shoppingCart .list .item .picTxt .text .reElection .reBnt {
		width: 120rpx;
		height: 46rpx;
		border-radius: 23rpx;
		font-size: 26rpx;
	}

	.shoppingCart .list .item .picTxt .text .infor {
		font-size: 24rpx;
		color: #999999;
		margin-top: 16rpx;
	}

	.money {
		font-size: 32rpx;
		font-weight: 600;
		@include price_color(theme);
		.price-color{
			@include price_color(theme);
		}
	}
	.mt-28{
		margin-top: 28rpx;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
	 .icon-xuanzhong11{
		@include main_color(theme);
		font-size: 36rpx;
	}
	.shoppingCart .list .item .picTxt .carnum {
		height: 47rpx;
		position: absolute;
		bottom: 7rpx;
		right: 0;
	}

	.shoppingCart .list .item .picTxt .carnum view {
		border: 1rpx solid #a4a4a4;
		width: 66rpx;
		text-align: center;
		height: 100%;
		line-height: 44rpx;
		font-size: 28rpx;
		color: #a4a4a4;
	}

	.shoppingCart .list .item .picTxt .carnum .reduce {
		border-right: 0;
		border-radius: 3rpx 0 0 3rpx;
		border-radius: 22rpx 0rpx 0rpx 22rpx;
		font-size: 34rpx;
		line-height: 40rpx;
	}

	.shoppingCart .list .item .picTxt .carnum .reduce.on {
		border-color: #e3e3e3;
		color: #dedede;
	}

	.shoppingCart .list .item .picTxt .carnum .plus {
		border-left: 0;
		border-radius: 0 3rpx 3rpx 0;
		border-radius: 0rpx 22rpx 22rpx 0rpx;
		font-size: 34rpx;
		line-height: 40rpx;
	}

	.shoppingCart .list .item .picTxt .carnum .num {
		color: #282828;
	}

	.shoppingCart .invalidGoods {
		background-color: #fff;
		
		/* #ifdef MP */
		margin-top: 140rpx;
		/* #endif */

	}

	.shoppingCart .invalidGoods .goodsNav {
		width: 100%;
		height: 90rpx;
		padding: 0 24rpx;
		box-sizing: border-box;
		font-size: 28rpx;
		color: #333333;
	}

	.shoppingCart .invalidGoods .goodsNav .iconfont {
		color: #424242;
		font-size: 28rpx;
		margin-right: 17rpx;
	}

	.shoppingCart .invalidGoods .goodsNav .del {
		font-size: 26rpx;
		color: #333;
	}

	.shoppingCart .invalidGoods .goodsNav .del .icon-shanchu1 {
		color: #333;
		font-size: 33rpx;
		vertical-align: -2rpx;
		margin-right: 8rpx;
	}

	.shoppingCart .invalidGoods .goodsList .item {
		padding: 24rpx;
	}

	.shoppingCart .invalidGoods .goodsList .picTxt {
		width: 576rpx;
	}

	.shoppingCart .invalidGoods .goodsList .item .invalid {
		font-size: 22rpx;
		color: #CCCCCC;
		height: 36rpx;
		border-radius: 3rpx;
		text-align: center;
		line-height: 36rpx;
	}

	.shoppingCart .invalidGoods .goodsList .item .pictrue {
		width: 160rpx;
		height: 160rpx;
	}

	.shoppingCart .invalidGoods .goodsList .item .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 6rpx;
	}

	.shoppingCart .invalidGoods .goodsList .item .text {
		width: 396rpx;
		font-size: 28rpx;
		color: #999;
		height: 140rpx;
	}

	.shoppingCart .invalidGoods .goodsList .item .text .name {
		width: 100%;
	}

	.shoppingCart .invalidGoods .goodsList .item .text .infor {
		font-size: 24rpx;
	}

	.shoppingCart .invalidGoods .goodsList .item .text .end {
		font-size: 26rpx;
		color: #bbb;
	}

	.footer {
		z-index: 9;
		width: 100%;
		height: 100rpx;
		background-color: #fff;
		position: fixed;
		padding: 0 24rpx;
		box-sizing: border-box;
		border-top: 1rpx solid #eee;
		bottom: var(--window-bottom);
	}

	.footer .checkAll {
		font-size: 28rpx;
		color: #282828;
		margin-left: 14rpx;
	}

	.footer .money {
		font-size: 30rpx;

		.font-color {
			font-weight: 600;
		}
	}

	.footer .placeOrder {
		color: #fff;
		font-size: 30rpx;
		width: 226rpx;
		height: 70rpx;
		border-radius: 50rpx;
		text-align: center;
		line-height: 70rpx;
		margin-left: 22rpx;
	}

	.footer .button .bnt {
		font-size: 28rpx;
		color: #999;
		border-radius: 50rpx;
		border: 1px solid #999;
		width: 160rpx;
		height: 60rpx;
		text-align: center;
		line-height: 60rpx;
	}
	.btn_cart_color{
		font-size: 14px;
		border-radius: 25px;
		width: 80px;
		height: 30px;
		text-align: center;
		line-height: 30px;
		@include coupons_border_color(theme);
		@include main_color(theme);
	}
	.footer .button form~form {
		margin-left: 17rpx;
	}
	::v-deep checkbox .uni-checkbox-input.uni-checkbox-input-checked {
		@include main_bg_color(theme);
		border: none !important;
		color: #fff!important
	}
	
	::v-deep checkbox .wx-checkbox-input.wx-checkbox-input-checked {
		@include main_bg_color(theme);
		border: none !important;
		color: #fff!important;
		margin-right: 0 !important;
	}
</style>