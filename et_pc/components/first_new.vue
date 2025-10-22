<template>
<div class="wrapper">
    <div class="seckill acea-row row-middle" v-if="activityData">
      <div class="trending-top" @click="gopage()">
        <span class="title">
            {{activityData.name}}
        </span>
        <span class="iconfont icon-gengduo more"></span>
      </div>
      <div class="seckillList">
        <div v-swiper:myScroll="swiperScroll">
          <div class="swiper-wrapper">
            <div
            @click="goDetail(item)"
              class="swiper-slide item"
              v-for="(item,index) in activityData.productList"
              :key="index"
            >
              <div
                class="picTxt"
              >
                <div class="pictrue">
                  <el-image class="img" :src="item.proImage">
                    <div slot="placeholder" class="image-slot">
                      loading<span class="dot">...</span>
                    </div>
                  </el-image>
                  <!-- <img :src="item.proImage" /> -->
                  </div>
                <div class="name line1">{{ item.title }}</div>
              </div>
            </div>
          </div>
          <div class="swiper-button-prev" slot="pagination"></div>
          <div class="swiper-button-next" slot="pagination"></div>
        </div>
      </div>
    </div>

</div>

</template>

<script>
import { goShopDetail } from '@/utils/order.js';
    export default {
    name: 'promotion',
		props: {
			activityData:{
				type: Object,
				default: ()=> {}
			}
    },
    data() {
			return {
				tempArr: [],
				params: {
					page: 1,
					limit: 10,
                },
                swiperOption: {
                    pagination: {
                    el: ".paginationBanner",
                    clickable: true,
                    },
                    navigation: {
                    nextEl: ".swiper-button-next",
                    prevEl: ".swiper-button-prev",
                    },
                    autoplay: {
                    disableOnInteraction: false,
                    delay: 5000,
                    },
                    loop: true,
                    speed: 1000,
                    observer: true,
                    observeParents: true,
                },
                swiperScroll: {
                    navigation: {
                    nextEl: ".swiper-button-next",
                    prevEl: ".swiper-button-prev",
                    },
                    freeMode: true,
                    freeModeMomentum: false,
                    slidesPerView: "auto",
                    observer: true,
                    observeParents: true,
                },
			}
    },
    methods: {
      gopage() {
        this.$router.push({
          path: "/goods/activity_list",
          query: {
            id: this.activityData.id,
            type: this.activityData.type,
            name: this.activityData.name
          }
        })
      },
      goDetail(item){
        goShopDetail(item.proId, this);
      },
    }
  }
</script>
<style lang="scss" scoped>
  .seckill {
    width: 1200px;
    height: 413px;
    background: #FFFFFF;
    margin: auto;
    margin-top: 40px;

    .trending-top {
      width: 100%;
      display: flex;
      justify-content: space-between;
      align-items: center;
      cursor: pointer;

      .title {
        font-size: 26px;
        text-align: center;
        margin: 28px 20px;
      }
      .more {
        font-size: 14px;
        text-align: center;
        float: right;
        color: #666;
        margin-right: 20px;
      }
    }

    .seckillList {
      width: 1200px;
      height: 325px;
      background-color: #fff;
      position: relative;
      .swiper-wrapper {
        margin-left: 20px;
      }

      .item {
        cursor: pointer;
        display: inline-block;
        width: 250px;
        position: relative;

        .picTxt {
          width: 100%;
          margin-left: 20px;
          margin: 0 auto;
        }

        & ~ .item:before {
          content: " ";
          position: absolute;
          width: 1px;
          height: 98px;
          background-color: #f4f4f4;
          top: 50%;
          margin-top: -49px;
        }
        .pictrue {
          width: 250px;
          height: 305px;
          margin: 0 auto;
          .img {
            width: 100%;
            height: 100%;
          }
        }
        .name {
          color: #282828;
          text-align: center;
          width: 164px;
          margin: 10px auto 0 auto;
        }
        // .money {
        //   text-align: center;
        //   width: 164px;
        //   margin: 12px auto 0 auto;
        //   .font-color {
        //     font-weight: bold;
        //     font-size: 16px;
        //   }
        //   .y_money {
        //     color: #a3a3a3;
        //     text-decoration: line-through;
        //     margin-left: 6px;
        //   }
        // }
      }
    }
  }

.swiper-button-next{background-image:url("../assets/images/right01.png");width: 25px;height: 34px;background-size: 100% 100%;right: 0;}
.swiper-button-prev{background-image:url("../assets/images/left01.png");width: 25px;height: 34px;background-size: 100% 100%;left:0;}
.seckillList:hover .swiper-button-next{background-image:url("../assets/images/right02.png");}
.seckillList:hover .swiper-button-prev{background-image:url("../assets/images/left02.png");}
</style>
