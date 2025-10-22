<script>
	import {
		HTTP_REQUEST_URL
	} from '@/config/app';
	import {
		getTheme,
		paycurrencyApi
	} from '@/api/api.js';
	import {
		mapActions
	} from 'vuex'
	import Cache from '@/utils/cache.js';
	const app = getApp();
	var script = document.createElement('script');
	script.src = "https://js.stripe.com/v3/";
	document.body.appendChild(script);
	export default {
		globalData: {
			spread: 0,
			code: 0,
			isLogin: false,
			userInfo: {},
			MyMenus: [],
			windowHeight: 0,
			navHeight: 0,
			navH: 0,
			height: 0,
			id: 0, //商品id
			isIframe: false,
			theme: Cache.get('theme') ? Cache.get('theme') : 'theme1', //主题色
			shopPayCurrency: Cache.get('shopPayCurrency') ? Cache.get('shopPayCurrency') : '$' //货币符号 - 默认美元
		},
		onLaunch: function(option) {

			let that = this;
			uni.getSystemInfo({
				success: function(res) {
					that.globalData.height = res.windowHeight;
				}
			});

			// 获取导航高度；
			uni.getSystemInfo({
				success: function(res) {
					that.globalData.navHeight = res.statusBarHeight * (750 / res.windowWidth) + 91;
				}
			});

			if (option.query.hasOwnProperty('type') && option.query.type == "iframeVisualizing") {
				this.globalData.isIframe = true;
			} else {
				this.globalData.isIframe = false;
			}
			// 主题变色
			getTheme().then(resP => {
				this.globalData.theme = `theme${Number(resP.data.value)}`
				this.$Cache.set('theme', this.globalData.theme);
				window.document.documentElement.setAttribute('data-theme', this.globalData.theme);
			})
			// 当前使用的币种
			paycurrencyApi().then(res => {
				let data = JSON.parse(res.data);
				this.$Cache.set('shopPayCurrency', data.symbol);
				this.globalData.shopPayCurrency = data.symbol;
			})
		},
		async mounted() {
			//if (this.$store.getters.isLogin && !this.$Cache.get('USER_INFO')) await this.$store.dispatch('USERINFO');
		},
		onShow: function() {
			// #ifdef H5
			uni.getSystemInfo({
				success(e) {
					/* 窗口宽度大于420px且不在PC页面且不在移动设备时跳转至 PC.html 页面 */
					if (e.windowWidth > 430 && !window.top.isPC && !/iOS|Android/i.test(e.system)) {
						// window.location.pathname = 'https://java.crmeb.net/';
						/* 若你的项目未设置根目录（默认为 / 时），则使用下方代码 */
						window.location.pathname = '/static/html/pc.html';
					}
				}
			})
			// #endif
		},
	}
</script>
<style lang="scss">
	@import url("@/plugin/animate/animate.min.css");
	@import 'static/css/base.css';
	@import 'static/iconfont/iconfont.css';
	@import 'static/css/guildford.css';
	@import 'static/css/style.scss';
	@import 'static/css/unocss.css';

	/* 条件编译，仅在H5平台生效 */
	// #ifdef H5
	body::-webkit-scrollbar,
	html::-webkit-scrollbar {
		display: none;
	}

	// #endif
	view {
		box-sizing: border-box;
	}

	.bg-color-red {
		background-color: #E93323;
	}

	.syspadding {
		padding-top: var(--status-bar-height);
	}

	.flex {
		display: flex;
	}

	.uni-scroll-view::-webkit-scrollbar {
		/* 隐藏滚动条，但依旧具备可以滚动的功能 */
		display: none
	}

	::-webkit-scrollbar {
		width: 0;
		height: 0;
		color: transparent;
	}
</style>