<template>
	<view class="swiperItem">
		<view class="swiper tui-skeleton-rect">
			<swiper :indicator-dots="false" :autoplay="true"  circular="true" interval="2500" duration="500" >
				<block v-for="(item,index) in imgUrls" :key="index">
					<swiper-item>
						<view @click="menusTap(item.url)">
							<image :src="item.pic" class="slide-image" lazy-load></image>
						</view>
					</swiper-item>
				</block>
			</swiper>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				
			}
		},
		props: {
			imgUrls:{
				type: Array,
				default: []
			},
		},
		methods:{
			menusTap(url){
				uni.navigateTo({
					url
				})
			},
		}
	}
</script>

<style lang="scss">
</style>
