<template>
	<view :data-theme="theme">
		<uniNavBar background-color="#fff" color="#333" :title="$t(`page.users.userAddress.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
			<view slot="left" class="iconfont icon-dingbufanhui"></view>
			<view slot="right" class="iconfont icon-more"></view>
		</uniNavBar>
		
		<form @submit="formSubmit" report-submit='true'>
			<view class='line'>
				<image src='../../../static/images/line.jpg'></image>
			</view>
			<view class='addAddress pad30'>
				<view class='list borRadius14'>
					<view class='item acea-row row-between-wrapper' style="border: none;">
						<view class='name'>{{$t(`page.users.userAddress.name`)}}</view>
						<input type='text' :placeholder='$t(`page.users.userAddress.place`) +  $t(`page.users.userAddress.name`)' placeholder-style="color:#ccc;" name='realName'
							:value="userAddress.realName" placeholder-class='placeholder' ></input>
					</view>
					<view class='item acea-row row-between-wrapper'>
						<view class='name'>{{$t(`page.users.userAddress.Email`)}}</view>
						<input type='text' :placeholder='$t(`page.users.userAddress.place`) +  $t(`page.users.userAddress.Email`)' placeholder-style="color:#ccc;" name="email"
							:value='userAddress.email' placeholder-class='placeholder' ></input>
					</view>
					<view class='item acea-row row-between-wrapper relative'>
						<view class='name'>{{$t(`page.users.userAddress.country`)}}</view>
						<!-- <text>{{country}}</text> -->
						<input type='text' placeholder-style="color:#ccc;" name="country"
							:value='country' placeholder-class='placeholder' @click="selectCountry('country')"></input>
					</view>
					<view class='item acea-row row-between-wrapper relative'>
						<view class='name'>{{$t(`page.users.userAddress.address`)}}</view>
						<input type='text' :placeholder='$t(`page.users.userAddress.place`) +  $t(`page.users.userAddress.address`)' placeholder-style="color:#ccc;" name='detail'
							placeholder-class='placeholder' :value='userAddress.detail' ></input>
					</view>
					<view class='item acea-row row-between-wrapper'>
						<view class='name'>{{$t(`page.users.userAddress.postCode`)}}</view>
						<input type='number' :placeholder='$t(`page.users.userAddress.postCode`)' placeholder-style="color:#ccc;" name="postCode"
							:value='userAddress.postCode' placeholder-class='placeholder' ></input>
					</view>
					<view class='item acea-row align-center'>
						<view  @click="selectCountry('code')">{{countryCode}} <text style="color:#D8D8D8;padding: 0 10rpx 0;">|</text> </view>
						<view class='name'>{{$t(`page.users.userAddress.phone`)}}</view>
						<input type='number' :placeholder='$t(`page.users.userAddress.place`) +  $t(`page.users.userAddress.phone`)' placeholder-style="color:#ccc;" name="phone"
							:value='userAddress.phone' placeholder-class='placeholder' style="flex: 1;"></input>
					</view>
				</view>
				<view class='default acea-row row-middle borRadius14'>
					<checkbox-group @change='ChangeIsDefault'>
						<checkbox :checked="userAddress.isDefault" />{{$t(`page.users.userAddress.default`)}}
					</checkbox-group>
				</view>

				<button class='keepBnt bg_color' form-type="submit">{{$t(`page.users.userAddress.save`)}}</button>
			</view>
		</form>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
		<tui-drawer mode="bottom" :visible="showList">
			<SortPickerList v-if="showList" ref="sortPickerList" @clickData="clickData" @close="closeList"></SortPickerList>
		</tui-drawer>
	</view>
</template>

<script>
	import {
		editAddress,
		getAddressDetail,
		addressIpInfo
	} from '@/api/user.js';
	import {getCity} from '@/api/api.js';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import {Debounce} from '@/utils/validate.js'
	import SortPickerList from "@/components/sortPickerList/index.vue";
	let app = getApp();
	export default {
		data() {
			return {
				id: 0, //地址id
				userAddress: {
					isDefault: false,
					email:'',
					postCode:'',
				}, //地址详情
				countryCode:'',
				country:'',
				cityId: 0,
				theme: app.globalData.theme,
				rightDrawer: false,
				showList:false,
				checkType:'country'
			};
		},
		components:{
			SortPickerList
		},
		computed: mapGetters(['isLogin']),
		onLoad(options) {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.userAddress.navTitle`)
			})
			if (this.isLogin) {
				this.preOrderNo = options.preOrderNo || 0;
				this.id = options.id || 0;
				this.getUserAddress();
				this.getIpInfo();
			} else {
				toLogin();
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
			closeList(){
				this.showList = false;
			},
			returns(){
				uni.navigateBack()
			},
			getUserAddress: function() {
				if (!this.id) return false;
				let that = this;
				getAddressDetail(this.id).then(res => {
					that.$set(that, 'userAddress', res.data);
					that.$set(that, 'country', res.data.country);
					that.$set(that, 'countryCode', res.data.countryCode);
					that.city_id = res.data.cityId;
				});
			},
			//获取所在地
			getIpInfo(){
				let that = this;
				addressIpInfo().then(res=>{
					if(!this.id){
						this.$set(this,'country',res.data.country_name);
						this.$set(this,'countryCode',res.data.country_calling_code);
						this.$set(this.userAddress,'detail',res.data.region + ' ' + res.data.city);
					}
				})
			},
			selectCountry(type){
				this.showList = true;
				this.checkType = type;
			},
			clickData(data) {
				this.countryCode = '+' + data.value;
				if(this.checkType == 'country'){
					this.country = data.country;
				}
				this.showList = false;
			},
			/**
			 * 提交用户添加地址
			 * 
			 */
			formSubmit: Debounce(function(e) {
				let that = this,value = e.detail.value;
				if (!value.realName) return that.$util.Tips({
					title: this.$t(`message.login.name`)
				});
				if (!value.email) return that.$util.Tips({
					title: this.$t(`message.login.emailEmpty`)
				});
				if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(value.email)) return that.$util.Tips({
					title: this.$t(`message.login.correctEmail`)
				});
				if (!value.detail) return that.$util.Tips({
					title: this.$t(`message.login.detail`)
				});
				if (!value.postCode) return that.$util.Tips({
					title: this.$t(`message.login.postCode`)
				});
				if (!value.phone) return that.$util.Tips({
					title:this.$t(`message.login.emptyPhone`)
				})
				value.id = that.id;
				value.countryCode = that.countryCode;
				value.isDefault = that.userAddress.isDefault;
				value.country = that.country;
				uni.showLoading({
					title: this.$t(`message.login.save`),
					mask: true
				})
				editAddress(value).then(res => {
					if (that.id)
						that.$util.Tips({
							title: this.$t(`message.login.updateSU`),
							icon: 'success'
						});
					else
						that.$util.Tips({
							title: this.$t(`message.login.saveSU`),
							icon: 'success'
						});
					setTimeout(function() {
						if (that.preOrderNo > 0) {
							uni.redirectTo({
								url: '/pages/users/order_confirm/index?preOrderNo=' + that.preOrderNo + '&addressId=' + (that.id ? that.id : res.data.id)
							})
						} else {
							return history.back();
						}
					}, 1000);
				}).catch(err => {
					return that.$util.Tips({
						title: err
					});
				})
			}),
			ChangeIsDefault: function(e) {
				this.$set(this.userAddress, 'isDefault', !this.userAddress.isDefault);
			}
		}
	}
</script>

<style scoped lang="scss">
	.addAddress {
		padding-top: 20rpx;
	}

	.bg_color {
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
	.addAddress .list {
		background-color: #fff;
		padding: 0 24rpx;
	}

	.addAddress .list .item {
		border-top: 1rpx solid #eee;
		height: 90rpx;
		line-height: 90rpx;
	}

	.addAddress .list .item .name {
		// width: 195rpx;
		font-size: 30rpx;
		color: #333;
	}

	.addAddress .list .item .address {
		flex: 1;
		margin-left: 50rpx;
	}

	.addAddress .list .item input {
		width: 468rpx;
		font-size: 30rpx;
		font-weight: 400;
		text-align: right;
	}

	.addAddress .list .item .placeholder {
		color: #ccc;
	}

	.addAddress .list .item picker .picker {
		width: 410rpx;
		font-size: 30rpx;
	}

	.addAddress .default {
		padding: 0 30rpx;
		height: 90rpx;
		background-color: #fff;
		margin-top: 23rpx;
	}

	.addAddress .default checkbox {
		margin-right: 15rpx;
	}

	.addAddress .keepBnt {
		width: 690rpx;
		height: 86rpx;
		border-radius: 50rpx;
		text-align: center;
		line-height: 86rpx;
		margin: 80rpx auto 24rpx auto;
		font-size: 32rpx;
		color: #fff;
	}

	.addAddress .wechatAddress {
		width: 690rpx;
		height: 86rpx;
		border-radius: 50rpx;
		text-align: center;
		line-height: 86rpx;
		margin: 0 auto;
		font-size: 32rpx;
		// color: #E93323 ;
		@include main_color(theme);
		@include coupons_border_color(theme);
	}

	.font_color {
		@include main_color(theme);
	}

	.relative {
		position: relative;
	}

	.icon-dizhi {
		font-size: 44rpx;
		z-index: 100;
	}

	.abs_right {
		position: absolute;
		right: 0;
	}

	/deep/ checkbox .uni-checkbox-input.uni-checkbox-input-checked {
		@include main_bg_color(theme);
		@include coupons_border_color(theme);
		color: #fff !important
	}

	/deep/ checkbox .wx-checkbox-input.wx-checkbox-input-checked {
		@include main_bg_color(theme);
		@include coupons_border_color(theme);
		color: #fff !important;
		margin-right: 0 !important;
	}
</style>
