<template>
	<view :data-theme="theme">
		<view class="main_bg">
			<uniNavBar background-color="transparent" color="#fff" :title="$t(`page.users.orderConfirm.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
				<view slot="left" class="iconfont icon-dingbufanhui"></view>
				<view slot="right" class="iconfont icon-more"></view>
			</uniNavBar>
		</view>
		<view class='order-submission'>
			<view class="allAddress">
				<view class='address acea-row row-between-wrapper' @tap='onAddress'>
					<view class='addressCon' v-if="addressInfo.realName">
						<view class='name'>{{addressInfo.realName}}
							<text class='phone'>{{addressInfo.phone}}</text>
						</view>
						<view class="acea-row">
							<text class='default font_color'
								v-if="addressInfo.isDefault">[{{$t(`page.goodsSearch.Default`)}}]</text>
							<text class="line2">{{addressInfo.province}}{{addressInfo.city}}{{addressInfo.district}}{{addressInfo.detail}}</text>	
						</view>
					</view>
					<view class='addressCon' v-else>
						<view class='setaddress'>{{$t(`page.users.orderConfirm.setAddress`)}}</view>
					</view>
					<view class='iconfont icon-gengduo'></view>
				</view>
				<view class='line'>
					<image src='/static/images/line.jpg'></image>
				</view>
			</view>
			<view class="pad30">
				<view v-for="(item, index) in cartInfo" :key="index">
					<orderGoods :cartInfo="item.orderInfoList" :orderInfo="item" :orderProNum="orderProNum"></orderGoods>
				</view>
				
				<view class='wrapper borRadius14'>
					<view class='item acea-row row-between-wrapper' @tap='couponTap'>
						<view>{{$t(`page.users.orderConfirm.coupons`)}}</view>
						<view class='discount'>{{couponTitle}}
							<text class='iconfont icon-gengduo'></text>
						</view>
					</view>
					<view class='item' v-if="textareaStatus">
						<view class="flex justify-between">
							<view>{{$t(`page.users.orderConfirm.note`)}}</view>
							<view>
								<text style="color:#666;">{{markNum ? markNum : 150}}</text>/<text>150</text>
							</view>
						</view>
						<textarea placeholder-class='placeholder' @input='bindHideKeyboard' maxlength="150"
							value="" name="mark" :placeholder='$t(`page.users.orderConfirm.placeNote`)'></textarea>
					</view>
				</view>
				<view class='wrapper borRadius14'>
					<view class='item'>
						<view>{{$t(`page.orderPayStatus.payType`)}}</view>
						<view class='list acea-row'>
							<template v-for="(item,index) in cartArr" >
								<view class='payItem acea-row row-middle' :class='active==index ?"on":""'
									@tap='payItem(index)' v-if="item.payStatus" :key='index'>
									<view class='name acea-row row-center-wrapper'>
										<image class='iconfont animated' :src="item.icon"></image>
										{{item.name}}
									</view>
								</view>
							</template>
						</view>
					</view>
				</view>
				<view class='moneyList borRadius14'>
					<view class='item acea-row row-between-wrapper'>
						<view>{{$t(`page.users.orderConfirm.allPrice`)}}：</view>
						<view class='money'>{{shopPayCurrency}}{{orderInfoVo.proTotalFee || 0}}</view>
					</view>
					<view class='item acea-row row-between-wrapper' v-if="orderInfoVo.couponFee > 0">
						<view>{{$t(`page.users.orderConfirm.CouponDeduction`)}}：</view>
						<view class='money'>-{{shopPayCurrency}}{{orderInfoVo.couponFee}}</view>
					</view>
					<view class='item acea-row row-between-wrapper' v-if="orderInfoVo.deductionPrice > 0">
						<view>{{$t(`page.users.orderConfirm.integral`)}}：</view>
						<view class='money'>-{{shopPayCurrency}}{{orderInfoVo.deductionPrice}}</view>
					</view>
					<view class='item acea-row row-between-wrapper' v-if="orderInfoVo.freightFee > 0">
						<view>{{$t(`page.users.orderConfirm.freight`)}}：</view>
						<view class='money'>+{{shopPayCurrency}}{{orderInfoVo.freightFee}}</view>
					</view>
				</view>
				<view style='height:120rpx;'></view>
			</view>
			<view class='footer acea-row row-between-wrapper'>
				<view>{{$t(`page.users.orderConfirm.total`)}}:
					<text class='price_color'>{{shopPayCurrency}}{{orderInfoVo.payFee || 0}}</text>
				</view>
				<view class='settlement' style='z-index:100' @tap="SubOrder">{{$t(`page.users.orderConfirm.payPal`)}}</view>
			</view>
		</view>
		<couponListWindow :shopPayCurrency="shopPayCurrency" :coupon='coupon' @ChangCouponsClone="ChangCouponsClone" :openType='openType' @ChangCoupons="ChangCoupons" :orderShow="orderShow"></couponListWindow>
		<addressWindow ref="addressWindow" @changeTextareaStatus="changeTextareaStatus" :address='address'
			:pagesUrl="pagesUrl" @OnDefaultAddress="OnDefaultAddress"  @OnChangeAddress="OnChangeAddress" @changeClose="changeClose"></addressWindow>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
	</view>
</template>
<script>
	import {
		//orderConfirm,
		getCouponsOrderPrice,
		orderCreate,
		postOrderComputed,
		payPayment,
		wechatQueryPayResult,
		loadPreOrderApi,
		payMethod
	} from '@/api/order.js';
	import {getAddressList,getAddressDetail} from '@/api/user.js';
	import {storeListApi} from '@/api/store.js';
	import couponListWindow from '@/components/couponListWindow';
	import addressWindow from '@/components/addressWindow';
	import orderGoods from '@/components/orderGoods';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import {Debounce} from '@/utils/validate.js'
	let app = getApp();
	export default {
		components: {
			couponListWindow,
			addressWindow,
			orderGoods
		},
		data() {
			return {
				shopPayCurrency: app.globalData.shopPayCurrency, //货币符号
				orderShow: 'orderShow', //下单页面使用优惠券组件不展示tab切换页
				textareaStatus: true,
				payType: 'stripe', //支付方式
				openType: 1, //优惠券打开方式 1=使用
				active: 0, //支付方式切换
				coupon: {
					coupon: false,
					list: [],
					statusTile: '立即使用'
				}, //优惠券组件
				address: {
					address: false,
					addressId: 0
				}, //地址组件
				addressInfo: {}, //地址信息
				addressId: 0, //地址id
				couponId: 0, //优惠券id
				cartId: '', //购物车id
				userInfo: {}, //用户信息
				mark: '', //备注信息
				couponTitle: this.$t(`page.goodsDetail.choose1`), //优惠券
				coupon_price: 0, //优惠券抵扣金额
				integral: 0,
				formIds: [], //收集formid
				status: 0,
				is_address: false,
				system_store: {},
				storePostage: 0,
				contacts: '',
				contactsTel: '',
				mydata: {},
				storeList: [],
				store_self_mention: 0,
				cartInfo: [],
				priceGroup: {},
				animated: false,
				totalPrice: 0,
				integralRatio: "0",
				pagesUrl: "",
				orderKey: "",
				// usableCoupon: {},
				offlinePostage: "",
				payChannel: 'mobile',
				orderInfoVo: {},
				addressList: [], //地址列表数据
				orderProNum: 0,
				preOrderNo: '', //预下单订单号
				theme:app.globalData.theme,
				rightDrawer: false,
				payInfo: {},
				
				//支付方式
				cartArr: [
					{
						"name": "Stripe",
						"icon": require("@/static/images/stripe.png"),
						value: 'stripe',
						title: 'Stripe支付',
						payStatus: 0,
					},
					{
							"name": "PayPal",
							"icon": require("@/static/images/PayPal.png"),
							value: 'paypal',
							title: 'PayPal支付',
							payStatus: 1,
					},
					{
							"name": "Wechat",
							"icon": require("@/static/images/wechat.png"),
							value: 'wechat',
							title: 'wechat支付',
							payStatus: 1,
					}
				],
			};
		},
		computed:{
			...mapGetters(['isLogin', 'systemPlatform', 'productType']),
			markNum(){
				let markNum = 0;
				if(this.mark){
					markNum = 150 - this.mark.length
					return markNum
				}
			}
		},
		watch: {
			isLogin: {
				handler: function(newV, oldV) {
					if (newV) {
						this.getloadPreOrder();
					}
				},
				deep: true
			}
		},
		onLoad(options) {
			var script = document.createElement('script');
			script.src = "https://js.stripe.com/v3/";
			document.body.appendChild(script);
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.orderConfirm.navTitle`)
			})
            this.preOrderNo = options.preOrderNo || 0;
			this.addressId = options.addressId || 0;
			this.is_address = options.is_address ? true : false;
			if (this.isLogin) {
				this.getloadPreOrder();
				this.getPayMethod();
			} else {
				toLogin();
			}
		},
		/**
		 * 生命周期函数--监听页面显示
		 */
		onShow: function() {
			let _this = this
			// wx.getLaunchOptionsSync 
			this.textareaStatus = true;

			uni.$on("handClick", res => {
				if (res) {
					_this.system_store = res.address
				}
				// 清除监听
				uni.$off('handClick');
			})
		},
		mounted() {
			 if(this.payInfo.paypalStatus && this.payInfo.stripeStatus){
			      this.active = 0
			      this.payType = 'stripe'
			    }else{
			      this.active = this.payInfo.paypalStatus ? 1 : 0
			      this.payType = this.payInfo.paypalStatus ? 'paypal' : 'stripe'
			    }
		},
		methods: {
			getPayMethod(){
				payMethod().then(res => {
					this.payInfo = res.data;
					this.cartArr[0].payStatus=res.data.stripeStatus
					this.cartArr[1].payStatus=res.data.paypalStatus
					this.cartArr[2].payStatus=res.data.wechatPaySwitch
				}).catch(err => {
					return this.$util.Tips({
						title: err
					});
				});
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
			returns(){
				uni.navigateBack()
			},
			// 订单详情
			getloadPreOrder: function() {
				loadPreOrderApi(this.preOrderNo).then(res => {
					let orderInfoVo = res.data
					this.orderInfoVo = orderInfoVo;
					this.cartInfo = orderInfoVo.orderList;
					this.orderProNum = orderInfoVo.orderProNum;
					this.address.addressId = this.addressId ? this.addressId :orderInfoVo.addressId;
					this.$nextTick(function() {
						this.$refs.addressWindow.getAddressList();
					})
				}).catch(err => {
					this.$util.Tips({
						title: err
					}, '/pages/users/order_list/index');
				})
			},
			// 关闭地址弹窗；
			changeClose: function() {
				this.$set(this.address, 'address', false);
			},
			/*
			 * 跳转门店列表
			 */
			showStoreList: function() {
				let _this = this
				if (this.storeList.length > 0) {
					uni.navigateTo({
						url: '/pages/users/goods_details_store/index'
					})
				}
			},
			// 计算订单价格
			computedPrice: function() {
				postOrderComputed({
					addressId: this.address.addressId,
					couponId: this.couponId,
					shippingType: 1,
					preOrderNo: this.preOrderNo
				}).then(res => {
					let data = res.data;
					this.orderInfoVo.couponFee = data.couponFee;
					this.orderInfoVo.deductionPrice = data.deductionPrice;
					this.orderInfoVo.freightFee = data.freightFee;
					this.orderInfoVo.payFee = data.payFee;
					this.orderInfoVo.proTotalFee = data.proTotalFee;
				}).catch(err => {
					return this.$util.Tips({
						title: err
					});
				});
			},
			bindPickerChange: function(e) {
				let value = e.detail.value;
				this.shippingType = value;
				this.computedPrice();
			},
			ChangCouponsClone: function() {
				this.$set(this.coupon, 'coupon', false);
			},
			changeTextareaStatus: function() {
				for (let i = 0, len = this.coupon.list.length; i < len; i++) {
					this.coupon.list[i].use_title = '';
					this.coupon.list[i].is_use = 0;
				}
				this.textareaStatus = true;
				this.status = 0;
				this.$set(this.coupon, 'list', this.coupon.list);
			},
			/**
			 * 处理点击优惠券后的事件
			 * 
			 */
			ChangCoupons: function(e) {
				// this.usableCoupon = e
				// this.coupon.coupon = false
				let index = e,
					list = this.coupon.list,
					couponTitle = this.$t(`page.goodsDetail.choose1`),
					couponId = 0;
				for (let i = 0, len = list.length; i < len; i++) {
					if (i != index) {
						list[i].use_title = '';
						list[i].isUse = 0;
					}
				}
				if (list[index].isUse) {
					//不使用优惠券
					list[index].use_title = '';
					list[index].isUse = 0;
				} else {
					//使用优惠券
					list[index].use_title = '不使用';
					list[index].isUse = 1;
					couponTitle = list[index].name;
					couponId = list[index].id;
				}
				this.couponTitle = couponTitle;
				this.couponId = couponId;
				this.$set(this.coupon, 'coupon', false);
				this.$set(this.coupon, 'list', list);
				this.computedPrice();
			},
			/**
			 * 首次进页面展示默认地址
			 */
			OnDefaultAddress: function(e) {
				this.addressInfo = e;
				this.address.addressId = e.id;
			},
			/**
			 * 选择地址后改变事件
			 * @param object e
			 */
			OnChangeAddress: function(e) {
				this.addressInfo = e;
				this.address.addressId = e.id;
				this.textareaStatus = true;
				this.address.address = false;
				this.computedPrice();
			},
			bindHideKeyboard: function(e) {
				this.mark = e.detail.value;
			},
			/**
			 * 获取当前金额可用优惠券
			 * 
			 */
			getCouponList: function() {
				getCouponsOrderPrice(this.preOrderNo).then(res => {
					this.$set(this.coupon, 'list', res.data);
					this.openType = 1;
				});
			},
			couponTap: function() {
				this.coupon.coupon = true;
				if(!this.coupon.list.length)this.getCouponList();
			},
			car: function() {
				let that = this;
				that.animated = false;
			},
			onAddress: function() {
				let that = this;
				that.textareaStatus = false;
				that.address.address = true;
				that.pagesUrl = '/pages/users/user_address_list/index?preOrderNo='+ this.preOrderNo;
			},
			payItem: function(e) {
				let that = this;
				let active = e;
				that.active = active;
				that.animated = true;
				that.payType = that.cartArr[active].value;
				setTimeout(function() {
					that.car();
				}, 500);
			},
			//创建订单
			payment: function(data) {
				let that = this;
				orderCreate(data).then(res => {
					uni.hideLoading();
					that.$Cache.setItem({
						name: 'orderNo',
						value:res.data.orderNo
					})
					// 订单创建成功，直接跳转到订单列表，不进入支付流程
					that.$util.Tips({
						title: '订单提交成功！',
						icon: 'success'
					}, {
						tab: 3,
						url: '/pages/order_details/index?orderNo=' + res.data.orderNo
					});
				}).catch(err => {
					uni.hideLoading();
					return that.$util.Tips({
						title: err
					});
				});
			},
			//订单支付
			getOrderPay: function(orderNo, message) {
				let that = this; 
				let goPages = '/pages/order_pay_status/index?order_id=' + orderNo + '&msg=' + message;
				//支付订单请求接口，调用公共函数
				that.$Order.goPay({
					orderNo: orderNo,
					payChannel: that.payChannel,
					payType: that.payType
				});
			},
			// 立即结算
			SubOrder: Debounce(function(e) {
				let that = this,
					data = {};

				if (!that.payType) return that.$util.Tips({
					title: this.$t(`message.orderConfirm.payType`)
				});
				if (!that.address.addressId && !that.shippingType) return that.$util.Tips({
					title: this.$t(`message.orderConfirm.emptyAddress`)
				});
				data = {
					realName: that.contacts,
					phone: that.contactsTel,
					addressId: that.address.addressId,
					couponId: that.couponId,
					payType: that.payType,
					preOrderNo: that.preOrderNo,
					mark: that.mark,
					storeId: that.system_store.id || 0,
					shippingType: 1,
					payChannel: that.payChannel

				};
				uni.showLoading({
					title: this.$t(`message.orderConfirm.payLoading`)
				});
				that.payment(data);
			})
		}
	}
</script>

<style lang="scss" scoped>
	.font_color{
		@include main_color(theme);
	}
	.price_color{
		@include price_color(theme);
	}
	.main_bg{
		@include main_bg_color(theme);
	}
	.line2{
		width: 504rpx;
	}
	.textR {
		text-align: right;
	}

	.order-submission .line {
		width: 100%;
		height: 3rpx;
	}

	.order-submission .line image {
		width: 100%;
		height: 100%;
		display: block;
	}

	.order-submission .address {
		padding: 28rpx;
		background-color: #fff;
		box-sizing: border-box;
	}

	.order-submission .address .addressCon {
		width: 596rpx;
		font-size: 26rpx;
		color: #666;
	}

	.order-submission .address .addressCon .name {
		font-size: 30rpx;
		color: #282828;
		font-weight: bold;
		margin-bottom: 10rpx;
	}

	.order-submission .address .addressCon .name .phone {
		margin-left: 50rpx;
	}

	.order-submission .address .addressCon .default {
		margin-right: 12rpx;
	}

	.order-submission .address .addressCon .setaddress {
		color: #333;
		font-size: 28rpx;
	}

	.order-submission .address .iconfont {
		font-size: 35rpx;
		color: #707070;
	}

	.order-submission .allAddress {
		width: 100%;
		@include index-gradient(theme);
		padding: 24rpx 30rpx 0 30rpx;
	}


	.order-submission .allAddress .address {
		width: 690rpx;
		max-height: 180rpx;
		margin: 0 auto;
		border-radius: 14rpx 14rpx 0 0;
	}

	.order-submission .allAddress .line {
		width: 100%;
		margin: 0 auto;
	}

	.order-submission .wrapper .item .discount .placeholder {
		color: #ccc;
	}

	.order-submission .wrapper {
		background-color: #fff;
		margin-top: 15rpx;
	}

	.order-submission .wrapper .item {
		padding: 27rpx 24rpx;
		font-size: 30rpx;
		color: #333333;
		border-bottom: 1px solid #F5F5F5;
	}

	.order-submission .wrapper .item .discount {
		font-size: 30rpx;
		color: #333;
	}

	.order-submission .wrapper .item .discount .iconfont {
		color: #515151;
		font-size: 30rpx;
		margin-left: 15rpx;
	}

	.order-submission .wrapper .item .discount .num {
		font-size: 32rpx;
		margin-right: 20rpx;
	}

	.order-submission .wrapper .item .shipping {
		font-size: 30rpx;
		color: #999;
		position: relative;
		padding-right: 58rpx;
	}

	.order-submission .wrapper .item .shipping .iconfont {
		font-size: 35rpx;
		color: #707070;
		position: absolute;
		right: 0;
		top: 50%;
		transform: translateY(-50%);
		margin-left: 30rpx;
	}

	.order-submission .wrapper .item textarea {
		background-color: #f9f9f9;
		width: auto !important;
		height: 140rpx;
		border-radius: 14rpx;
		margin-top: 30rpx;
		padding: 15rpx;
		box-sizing: border-box;
		font-weight: 400;
	}

	.order-submission .wrapper .item .placeholder {
		color: #ccc;
	}

	.order-submission .wrapper .item .list {
		margin-top: 35rpx;
		justify-content: space-between;
	}

	.order-submission .wrapper .item .list .payItem {
		border: 1px solid #eee;
		border-radius: 14rpx;
		height: 86rpx;
		width: 100%;
		box-sizing: border-box;
		margin-top: 20rpx;
		font-size: 28rpx;
		color: #282828;
		justify-content: center;
	}

	.order-submission .wrapper .item .list .payItem.on {
		// border-color: #fc5445;
		@include coupons_border_color(theme);
		color: $theme-color;
	}

	.order-submission .wrapper .item .list .payItem .name {
		text-align: center;
	}

	.order-submission .wrapper .item .list .payItem .name .iconfont {
		width: 44rpx;
		height: 44rpx;
		text-align: center;
		line-height: 44rpx;
		color: #fff;
		font-size: 30rpx;
		margin-right: 15rpx;
	}

	.order-submission .wrapper .item .list .payItem .name .iconfont.icon-weixin2 {
		background-color: #41b035;
	}
	.order-submission .wrapper .item .list .payItem .name .iconfont.icon-zhifubao {
		background-color: #00AAEA;
	}
	.order-submission .wrapper .item .list .payItem .tip {
		width: 49%;
		text-align: center;
		font-size: 26rpx;
		color: #aaa;
	}

	.order-submission .moneyList {
		margin-top: 15rpx;
		background-color: #fff;
		padding: 30rpx;
	}

	.order-submission .moneyList .item {
		font-size: 28rpx;
		color: #282828;
	}

	.order-submission .moneyList .item~.item {
		margin-top: 20rpx;
	}

	.order-submission .moneyList .item .money {
		color: #666666;
	}

	.order-submission .footer {
		width: 100%;
		height: 100rpx;
		background-color: #fff;
		padding: 0 30rpx;
		font-size: 28rpx;
		color: #333;
		box-sizing: border-box;
		position: fixed;
		bottom: 0;
		left: 0;
		height: calc(100rpx + constant(safe-area-inset-bottom)); ///兼容 IOS<11.2/
		height: calc(100rpx + env(safe-area-inset-bottom)); ///兼容 IOS>11.2/
	}

	.order-submission .footer .settlement {
		font-size: 30rpx;
		color: #fff;
		width: 320rpx;
		height: 70rpx;
		@include main_bg_color(theme);
		border-radius: 50rpx;
		text-align: center;
		line-height: 70rpx;
	}

	.footer .transparent {
		opacity: 0
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
