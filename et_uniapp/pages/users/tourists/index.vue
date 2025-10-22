<template>
	<view>
		<view class="ChangePassword">
			<view>
				<uniNavBar background-color="#fff" left-icon="back" color="#000" :border='false' @clickLeft='returns'></uniNavBar>
			</view>
			<view>
				<view class="shading">{{$t(`page.users.login.tourists`)}}</view>
				<view class="list">
					<div class="item">
						<div class="acea-row row-middle">
							<text class="star"></text>
							<text class="iconfont icon-youxiang"></text>
							<input type="text" class="texts" :placeholder="$t(`page.users.register.placeEmail`)" v-model="email"/>
						</div>
					</div>
					<div class="item">
						<div class="acea-row row-middle">
							<text class="iconfont icon-shouji"></text>
							<view class="acea-row row-middle pos_line" @click="selectCountry()">
								<image :src="countryFlag" class="flag"></image>
								<image src="../../../static/images/xiala.png" class="select_code"></image>
							</view>
							<text class="px-20">+{{countryCode}}</text>
							<input type="number" class="texts" v-model="phone" :placeholder="$t(`page.users.register.placePhone`)" style="margin:0" />
						</div>
					</div>
				</view>
				<button form-type="submit" class="confirmBnt bg_color"  @click="submit()">{{$t(`page.users.login.continue`)}}</button>
			</view>
		</view>
		<tui-drawer mode="bottom" :visible="showList" @close="closeDrawer">
			<SortPickerList ref="sortPickerList" @clickData="clickData"  @close="closeList"></SortPickerList>
		</tui-drawer>
	</view>
</template>

<script>
	import sendVerifyCode from "@/mixins/SendVerifyCode";
	import SortPickerList from "@/components/sortPickerList/index.vue";
	import {mapGetters} from "vuex";
	import {loginVisor,getUserInfo} from '@/api/user'
	import {Debounce} from '@/utils/validate.js'
	const app = getApp();
	const BACK_URL = "login_back_url";
	export default {
		mixins: [sendVerifyCode],
		data() {
			return {
				email:'',
				phone:'',
				showList:false,
				countryCode:'86',
				countryFlag:'../../../static/flag/cn.png'
			};
		},
		components:{
			SortPickerList
		},
		onLoad() {
			
		},
		onReady() {
			var that = this
			that.$refs["sortPickerList"].initPage();
		},
		methods: {
			returns() {
				uni.navigateBack()
			},
			selectCountry(){
				this.showList = true;
			},
			clickData(data) {
				this.countryCode = data.value;
				this.countryFlag = data.flag;
				this.showList = false;
			},
			closeList(){
				this.showList = false;
			},
			submit:Debounce(function(){
				let that = this;
				if (!that.email) return that.$util.Tips({
					title: '请填写邮箱'
				});
				if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/i.test(that.email)) return that.$util.Tips({
					title: '请输入正确的邮箱'
				});
				uni.showLoading({
					title: 'loading'
				});
				loginVisor({
					"countryCode": that.countryCode,
					"email": that.email,
					"phone": that.phone
				}).then(res=>{
					this.$store.commit("LOGIN", {
						'token': res.data.token
					});
					that.getUserInfo(res.data);
				})
			}),
			getUserInfo(data) {
				let that = this;
				this.$store.commit("SETUID", data.uid);
				getUserInfo().then(res => {
					uni.hideLoading();
					this.$store.commit("UPDATE_USERINFO", res.data);
					// this.getPreOrder();
					let backUrl = this.$Cache.get(BACK_URL) || "/pages/index/index";
					return that.$util.Tips({
						title: this.$t(`message.login.loginSuccess`),
						icon:'success'
					}, {
						tab: 4,
						url: backUrl
					});
				})
			},
			/**
			 * 预下单
			 */
			getPreOrder: function() {
				this.$Order.getPreOrder('buyNow', [{
					"attrValueId": parseFloat(this.attr.productSelect.unique),
					"productId": parseFloat(this.id),
					"productNum": parseFloat(this.attr.productSelect.cart_num)
				}]);
			},
		}
	}
</script>

<style lang="scss" scoped>
	page {
		background-color: #fff !important;
		padding: 30rpx;
		box-sizing: border-box;
	}
	.navBar{
		padding: 30rpx 0 0 30rpx;
	}
	.shading {
		display: flex;
		align-items: center;
		justify-content: center;
		width: 100%;
		margin-top: 140rpx;
		margin-bottom: 100rpx;
		font-size: 50rpx;
		font-family: PingFangSC-Semibold, PingFang SC;
		font-weight: 600;
		color: #220000;
		line-height: 50rpx;
	}
	.star{
		position: relative;
		&::before{
			content: "*";
			font-size: 20rpx;
			color: red;
			position: absolute;
			left: -20rpx;
			top: 50%;
			transform: translateY(-50%);
		}
	}
	.ChangePassword .phone {
		font-size: 32rpx;
		font-weight: bold;
		text-align: center;
		margin-top: 55rpx;
	}
	.acea-row.row-middle {
		input {
			margin-left: 20rpx;
			display: block;
		}
	}
	.list {
		border-radius: 16rpx;
		overflow: hidden;
		margin-bottom: 80rpx;
		padding: 0 60rpx 0;
	
		.item {
			border-bottom: 1px solid #F0F0F0;
			background: #fff;
	
			.iconfont {
				font-size: 30rpx;
				color: #B4B4B4;
			}
	
			.row-middle {
				position: relative;
				padding: 16rpx 24rpx;
	
				.texts {
					flex: 1;
					font-size: 28rpx;
					height: 80rpx;
					line-height: 80rpx;
					display: flex;
					justify-content: center;
					align-items: center;
				}
	
				input {
					flex: 1;
					font-size: 28rpx;
					height: 80rpx;
					line-height: 80rpx;
					display: flex;
					justify-content: center;
					align-items: center;
				}
	
				.code {
					position: absolute;
					right: 30rpx;
					top: 50%;
					color: $theme-color;
					font-size: 26rpx;
					transform: translateY(-50%);
				}
			}
		}
	
		.forget {
			font-size: 24rpx;
			font-family: PingFangSC-Regular, PingFang SC;
			font-weight: 400;
			color: #666666;
			margin-top: 24rpx;
			text-align: right;
		}
	}

	.ChangePassword .confirmBnt {
		font-size: 32rpx;
		width: 580rpx;
		height: 90rpx;
		border-radius: 45rpx;
		color: #fff;
		margin: 92rpx auto 0 auto;
		text-align: center;
		line-height: 90rpx;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
	.font_color{
		@include main_color(theme);
	}
	.flag{
		width: 40rpx;
		height:26rpx;
		display: inline-block;
		margin-left: 26rpx;
	}
	.select_code{
		width: 16px;height: 8px;
		display: inline-block;
		margin-left: 16rpx;
	}
	.pos_line{
		position: relative;
		&::after{
			content: '';
			position: absolute;
			right: 0;
			top: 50%;
			transform: translateY(-50%);
			width: 1px;
			height: 28rpx;
			background-color: #eee;
		}
	}
	.px-20{
		padding: 0 20rpx 0;
	}
	.email::before {
		content: "*";
		font-size: 20rpx;
		color: red;
	}
</style>
