<template>
	<view :data-theme="theme">
		<uniNavBar background-color="#fff" color="#333" :title="$t(`page.users.userAddressList.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
			<view slot="left" class="iconfont icon-dingbufanhui"></view>
			<view slot="right" class="iconfont icon-more"></view>
		</uniNavBar>
		<view class='line'>
			<image src='../../../static/images/line.jpg' v-if="addressList.length"></image>
		</view>
		<view class='address-management' :class='addressList.length < 1 && page > 1 ? "fff":""'>
			<radio-group class="radio-group" @change="radioChange" v-if="addressList.length">
				<view class='item borRadius14' v-for="(item,indexn) in addressList" :key="indexn">
					<view class='address' @click='goOrder(item.id)'>
						<view class='consignee'>{{item.realName}}<text class='phone'>{{item.email}}</text></view>
						<view>{{item.detail}}</view>
					</view>
					<view class='operation acea-row row-between-wrapper'>
						<radio class="radio" :value="indexn.toString()" :checked="item.isDefault">
							<text>{{$t(`page.users.userAddressList.default`)}}</text>
						</radio>
						<view class='acea-row row-middle'>
							<view @click='editAddress(item.id)'><text class='iconfont icon-bianji'></text></view>
							<view @click='modal = true,index = indexn'><text class='iconfont icon-shanchu'></text></view>
						</view>
					</view>
				</view>
			</radio-group>
			<view class='loadingicon acea-row row-center-wrapper' v-if="addressList.length">
				<text class='loading iconfont icon-jiazai' :hidden='loading==false'></text>{{loadTitle}}
			</view>
			<view class='noCommodity text-center' v-if="addressList.length < 1 && page > 1">
				<view class='pictrue'>
					<image src='../../../static/images/noAddress.png'></image>
				</view>
				<text class="text-ccc">{{$t(`page.users.userAddressList.emptyAddress`)}}</text>
			</view>
			<view style='height:120rpx;'></view>
		</view>
		<view class='footer acea-row row-between-wrapper'>
			<view class='addressBnt bg_color on' @click='addAddress'><text class='iconfont icon-tianjiadizhi'></text>{{$t(`page.users.userAddressList.add`)}}</view>
		</view>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
		<tui-modal :show="modal" @click="handleClick" @cancel="hide" :title="$t(`message.login.prompt`)" :content="$t(`message.login.confirmDel`)"></tui-modal>
	</view>
</template>

<script>
	import {
		getAddressList,
		setAddressDefault,
		delAddress,
		editAddress,
		postAddress
	} from '@/api/user.js';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import tuiModal from "@/components/tui-modal/tui-modal"
	import {setThemeColor} from '@/utils/setTheme.js'
	let app = getApp();
	export default {
		data() {
			return {
				addressList: [],
				loading: false,
				loadend: false,
				loadTitle: this.$t(`page.goodsList.more`),
				page: 1,
				limit: 20,
				theme:app.globalData.theme,
				rightDrawer: false,
				modal: false,
				index:0
			};
		},
		computed: mapGetters(['isLogin']),
		components:{
			tuiModal
		},
		watch:{
			isLogin:{
				handler:function(newV,oldV){
					if(newV){
						this.getUserAddress(true);
					}
				},
				deep:true
			}
		},
		onLoad(options) {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.userAddressList.navTitle`)
			})
			if (this.isLogin) {
				this.preOrderNo = options.preOrderNo || 0;
				this.getAddressList(true);
			} else {
				toLogin();
			}
		},
		onShow: function() {
			let that = this;
			that.getAddressList(true);
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
			/**
			 * 获取地址列表
			 * 
			 */
			getAddressList: function(isPage) {
				let that = this;
				if (isPage) {
					that.loadend = false;
					that.page = 1;
					that.$set(that, 'addressList', []);
				};
				if (that.loading) return;
				if (that.loadend) return;
				that.loading = true;
				that.loadTitle = '';
				getAddressList({
					page: that.page,
					limit: that.limit
				}).then(res => {
					let list = res.data.list;
					let loadend = list.length < that.limit;
					that.addressList = that.$util.SplitArray(list, that.addressList);
					that.$set(that, 'addressList', that.addressList);
					that.loadend = loadend;
					that.loadTitle = loadend ? this.$t('page.goodsList.nono') : this.$t('page.goodsList.more');
					that.page = that.page + 1;
					that.loading = false;
				}).catch(err => {
					that.loading = false;
					that.loadTitle = 'load more';
				});
			},
			/**
			 * 设置默认地址
			 */
			radioChange: function(e) {
				let index = parseInt(e.detail.value),
					that = this;
				let address = this.addressList[index];
				if (address == undefined) return that.$util.Tips({
					title: this.$t(`message.login.notExist`) 
				});
				setAddressDefault(address.id).then(res => {
					for (let i = 0, len = that.addressList.length; i < len; i++) {
						if (i == index) that.addressList[i].isDefault = true;
						else that.addressList[i].isDefault = false;
					}
					that.$util.Tips({
						title: this.$t(`message.login.setSU`) ,
						icon: 'success'
					}, function() {
						that.$set(that, 'addressList', that.addressList);
					});
				}).catch(err => {
					return that.$util.Tips({
						title: err
					});
				});
			},
			/**
			 * 编辑地址
			 */
			editAddress: function(id) {
				uni.navigateTo({
					url: '/pages/users/user_address/index?id=' + id
				})
			},
			/**
			 * 删除地址
			 */
			handleClick(e) {
				let index = e.index;
				if (index === 0) {
				} else {
					let that = this,address = this.addressList[that.index];
					if (address == undefined) return that.$util.Tips({
						title: this.$t(`message.login.notExist`)
					});
					delAddress(address.id).then(res => {
						that.getAddressList(true);
						// that.addressList.splice(index, 1);
						// that.$set(that, 'addressList', that.addressList);
						that.$util.Tips({
							title: this.$t(`message.login.delSU`),
							icon: 'success'
						});
					}).catch(err => {
						return that.$util.Tips({
							title: err
						});
					});
				}
				this.hide();
			},
			hide() {
				this.modal = false;
			},
			/**
			 * 新增地址
			 */
			addAddress: function() {
				uni.navigateTo({
					url: '/pages/users/user_address/index?preOrderNo=' + this.preOrderNo
				})
			},
			goOrder: function(id) {
				if(this.preOrderNo){
					uni.redirectTo({
						url: '/pages/users/order_confirm/index?is_address=1&preOrderNo=' + this.preOrderNo + '&addressId=' +  id 
					})
				}
			},
		},
		onReachBottom: function() {
			this.getAddressList(true);
		}
	}
</script>

<style lang="scss" scoped>
	.address-management{
		padding: 20rpx 30rpx;
	}
	.address-management.fff {
		background-color: #fff;
		height: 1300rpx
	}
	.bg_color{
		@include main_bg_color(theme);
	}
	.line {
		width: 100%;
		height: 3rpx;
		image {
			width: 100%;
			height: 100%;
			display: block;
		}
	}
	.address-management .item {
		background-color: #fff;
		padding: 0 20rpx;
		margin-bottom: 20rpx;
	}

	.address-management .item .address {
		padding: 35rpx 0;
		border-bottom: 1rpx solid #eee;
		font-size: 28rpx;
		color: #282828;
	}

	.address-management .item .address .consignee {
		font-size: 28rpx;
		font-weight: bold;
		margin-bottom: 8rpx;
	}

	.address-management .item .address .consignee .phone {
		margin-left: 30rpx;
	}

	.address-management .item .operation {
		height: 83rpx;
		font-size: 28rpx;
		color: #282828;
	}

	.address-management .item .operation .radio text {
		margin-left: 13rpx;
	}

	.address-management .item .operation .iconfont {
		color: #2c2c2c;
		font-size: 35rpx;
		vertical-align: -2rpx;
		margin-right: 10rpx;
	}

	.address-management .item .operation .iconfont.icon-shanchu {
		margin-left: 35rpx;
		font-size: 38rpx;
	}

	 .footer {
		position: fixed;
		width: 100%;
		bottom: 0;
		height: 106rpx;
		padding: 0 30rpx;
		box-sizing: border-box;
	}

    .footer .addressBnt {
		width: 330rpx;
		height: 76rpx;
		border-radius: 50rpx;
		text-align: center;
		line-height: 76rpx;
		font-size: 30rpx;
		color: #fff;
	}

	 .footer .addressBnt.on {
		width: 690rpx;
		margin: 0 auto;
	}

	 .footer .addressBnt .iconfont {
		font-size: 35rpx;
		margin-right: 8rpx;
		vertical-align: -1rpx;
	}

	 .footer .addressBnt.wxbnt {
		@include left_color(theme);
	}
	
	 .radio{
		 /deep/.wx-radio-input.wx-radio-input-checked {
		 	@include main_bg_color(theme);
		 	@include coupons_border_color(theme);
		 }
		 /deep/.uni-radio-input.uni-radio-input-checked {
		 	@include main_bg_color(theme);
		 	border: none !important;
		 }
	 }
	
	/deep/.tui-red{
		@include main_bg_color(theme);
	}
	/deep/.tui-red-outline{
		@include main_color(theme);
		@include coupons_border_color(theme);
	}
</style>
