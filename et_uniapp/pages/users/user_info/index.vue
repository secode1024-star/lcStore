<template>
	<view :data-theme="theme">
		<uniNavBar background-color="#fff" color="#333" :title="$t(`page.users.userInfo.navTitle`)" :border='false' @clickLeft='returns' @clickRight="open">
			    <view slot="left" class="iconfont icon-dingbufanhui"></view>
			    <view slot="right" class="iconfont icon-more"></view>
		</uniNavBar>
		<form @submit="formSubmit" report-submit='true'>
			<view class='personal-data'>
				<view class='list'>
					<view class="item acea-row row-between-wrapper" style="height: 144rpx;">
						<view>{{$t(`page.users.userInfo.avatar`)}}</view>
						<view class="pictrue" @click.stop='uploadpic'>
							<image :src='newAvatar ? newAvatar : userInfo.avatar'></image>
						</view>
					</view>
					<view class='item acea-row row-between-wrapper'>
						<view>{{$t(`page.users.userInfo.name`)}}</view>
						<view class='input'>
							<input type='text' name='nickname' :value='userInfo.nickname' maxlength="20"></input>
						</view>
					</view>
					<view class='item acea-row row-between-wrapper'>
						<view>ID</view>
						<view class='input acea-row row-between-wrapper'>
							<input type='text' :value='uid' disabled='true' class='id'></input>
							<text class='iconfont icon-suozi'></text>
						</view>
					</view>
					<view class='item acea-row row-between-wrapper' v-if="userInfo.email">
						<view>{{$t(`page.users.userInfo.email`)}}</view>
						<view class="input acea-row row-between-wrapper">
							<input type='text' disabled='true' name='email' :value='userInfo.email'></input>
							<text class='iconfont icon-suozi'></text>
						</view>
					</view>
					<view class='item acea-row row-between-wrapper' v-if="userInfo.phone">
						<view>{{$t(`page.users.userInfo.phone`)}}</view>
						<view class="input acea-row row-between-wrapper">
							<input type='number' disabled='true' name='phone' :value='userInfo.phone'></input>
							<text class='iconfont icon-suozi'></text>
						</view>
					</view>
					<view class="item acea-row row-between-wrapper" v-if="userInfo.userType == 'email' || userInfo.userType == 'phone'">
						<view>{{$t(`page.users.userInfo.password`)}}</view>
						<view class="input" @click="reset(userInfo.userType,'reset')">
							{{$t(`message.tips.edidM`)}}<text class="iconfont icon-xuanze"></text>
						</view>
					</view>
				</view>
				<button class='modifyBnt bg_color' formType="submit">{{$t(`page.users.userInfo.save`)}}</button>
				<view class="logOut cart-color acea-row row-center-wrapper" @click="modal = true">{{$t(`page.users.userInfo.logOut`)}}</view>
			</view>
		</form>
		<tui-drawer mode="right" :visible="rightDrawer" @close="closeDrawer">
			<user-drawer @close="closeDrawer"></user-drawer>
		</tui-drawer>
		<tui-modal :show="modal" @click="handleClick" @cancel="hide" :title="$t(`message.login.prompt`)" :content="$t(`message.login.logout`)"></tui-modal>
	</view>
</template>

<script>
	import tuiModal from "@/components/tui-modal/tui-modal"
	import {userEdit,getLogout} from '@/api/user.js';
	import {switchH5Login} from '@/api/api.js';
	import {toLogin} from '@/libs/login.js';
	import {mapGetters} from "vuex";
	import {Debounce} from '@/utils/validate.js'
	let app = getApp();
	export default {
		data() {
			return {
				memberInfo: {},
				loginType: 'h5', //app.globalData.loginType
				userIndex: 0,
				newAvatar: '',
				theme:app.globalData.theme,
				rightDrawer: false,
				modal: false
			};
		},
		components:{
			tuiModal
		},
		computed: mapGetters(['isLogin', 'uid', 'userInfo']),
		onLoad() {
			uni.setNavigationBarTitle({
				title: this.$t(`page.users.userInfo.navTitle`)
			})
			if (!this.isLogin) {
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
			reset(type,scene){
				uni.navigateTo({
					url:'/pages/users/user_pwd_edit/index?type=' + type + '&scene=' + scene
				})
			},
			/**
			 * 退出登录
			 * 
			 */
			handleClick(e) {
				let index = e.index,that = this;
				if (index === 1) {
					getLogout().then(res => {
						that.$Cache.set('login_back_url', '/pages/index/index')
						that.$store.commit("LOGOUT");
						uni.reLaunch({
							url: '/pages/index/index'
						});
					});
				} 
				this.hide();
			},
			hide() {
				this.modal = false;
			},
			/**
			 * 上传文件
			 * 
			 */
			uploadpic: function() {
				let that = this;
				that.$util.uploadImageOne({
					url: 'upload/image',
					name: 'multipart',
					model: "maintain",
					pid: 0
				}, function(res) {
					that.newAvatar = res.data.url;
				});
			},

			/**
			 * 提交修改
			 */
			formSubmit: Debounce(function(e) {
				let that = this,
					value = e.detail.value
				if (!value.nickname) return that.$util.Tips({
					title: this.$t(`page.users.userInfo.msg`)
				});
				value.avatar = that.newAvatar?that.newAvatar:that.userInfo.avatar;
				userEdit(value).then(res => {
					that.$store.commit("changInfo", {
						amount1: 'avatar',
						amount2: that.newAvatar
					});
					return that.$util.Tips({
						title: this.$t(`message.login.saveSU`),
						icon: 'success'
					}, {
						tab: 3,
						url: 1
					});

				}).catch(msg => {
					return that.$util.Tips({
						title: msg || '保存失败，您并没有修改'
					}, {
						tab: 3,
						url: 1
					});
				});
			}),
			returns(){
				uni.navigateBack()
			}
		}
	}
</script>

<style scoped lang="scss">
	.personal-data .list {
		background-color: #fff;
	}

	.personal-data .list .item {
		border-bottom: 1rpx solid #f2f2f2;
		padding: 0 30rpx;
		line-height: 114rpx;
		font-size: 32rpx;
		color: #282828;
	}

	.personal-data .list .item .phone {
		width: 160rpx;
		height: 56rpx;
		font-size: 24rpx;
		color: #fff;
		line-height: 56rpx;
		border-radius: 32rpx
	}

	.personal-data .list .item .pictrue {
		width: 88rpx;
		height: 88rpx;
		position: relative;
	}

	.personal-data .list .item .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 50%;
	}

	.personal-data .list .item .input {
		width: 415rpx;
		text-align: right;
		color: #868686;
	}

	.personal-data .list .item .input .id {
		width: 365rpx;
	}

	.personal-data .list .item .input .iconfont {
		font-size: 35rpx;
	}

	.personal-data .modifyBnt {
		font-size: 32rpx;
		color: #fff;
		width: 690rpx;
		height: 90rpx;
		border-radius: 50rpx;
		text-align: center;
		line-height: 90rpx;
		margin: 76rpx auto 0 auto;
	}
	.bg_color{
		@include main_bg_color(theme);
	}
	.personal-data .logOut {
		font-size: 32rpx;
		text-align: center;
		width: 690rpx;
		height: 90rpx;
		border-radius: 45rpx;
		margin: 30rpx auto 0 auto;
	}
	::v-deep.tui-red{
		@include main_bg_color(theme);
	}
	::v-deep.tui-red-outline{
		@include main_color(theme);
		@include coupons_border_color(theme);
	}
</style>
