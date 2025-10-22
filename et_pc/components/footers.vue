<template>
  <div>
    <div class="footer">
      <div class="wrapper_1200">
        <ul class="acea-row row-around row-middle">
          <li class="acea-row row-middle">
            <div class="picture"><span class="iconfont icon-pinzhong"></span></div>
            <div>{{$t(`page.index.footer1`)}}</div>
          </li>
          <li class="acea-row row-middle">
            <div class="picture"><span class="iconfont icon-zhifa"></span></div>
            <div>{{$t(`page.index.footer2`)}}</div>
          </li>
          <li class="acea-row row-middle">
            <div class="picture"><span class="iconfont icon-hanghuo"></span></div>
            <div>{{$t(`page.index.footer3`)}}</div>
          </li>
          <li class="acea-row row-middle">
            <div class="picture"><span class="iconfont icon-dijia"></span></div>
            <div>{{$t(`page.index.footer4`)}}</div>
          </li>
        </ul>
        <div class="recordNum">
          <div>
            <div>
              <span>{{$t(`page.orderDetails.phone`)}}：18053919966</span>
              <span style="margin-left:40px">{{$t(`page.index.mainNav[3].name`)}}：{{$t(`page.index.address`)}}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
// +----------------------------------------------------------------------
// | 寰球联采 [ 连接全球，共创未来 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2025 https://www.hqlccn.com All rights reserved.
// +----------------------------------------------------------------------
// | 寰球联采全球采购平台
// +----------------------------------------------------------------------
// | Author: 寰球联采开发团队 <admin@hqlccn.com>
// +----------------------------------------------------------------------
    export default {
      name: "footers",
      components: {},
      mixins: [],
      data(){
        return{
          companyInfo:{},
          codeUrl:'',
          iScode:false
        }
      },
      head() {
        return {
          meta: [
            {
              hid:'keywords',name:'keywords',content:this.companyInfo.site_keywords
            },
            {
              hid:'description',name:'description',content:this.companyInfo.site_description
            },
          ]
        }
      },
      beforeMount(){
        this.getCompanyInfo();
      },
      mounted(){

      },
      methods:{
        goTop(){
          (function n() {
            var t = document.documentElement.scrollTop || document.body.scrollTop;
            if (t > 0) {
              window.requestAnimationFrame(n);
              window.scrollTo(0, t - t / 5)
            }
          })()
        },
        goRecommend(){

        },
        wxCode(){
          this.iScode = true
        },
        wxCodeHide(){
          this.iScode = false
        },
        goCart(){
          // this.$router.push({path:'/shopping_cart'});
        },
        getCompanyInfo(){
          // this.$axios.get("/api/pc/config").then(res=>{
          //   this.companyInfo = res.data;
          //   this.$store.commit('logo', res.data.site_logo);
          //   this.$cookies.set('logo',res.data.site_logo);
          //   this.$store.commit('titles', res.data.site_name);
          //   this.$cookies.set('titles',res.data.site_name);
          //   this.$store.commit('qrCode', res.data.wechat_qrcode);
          //   this.$store.commit('consumerHotline', res.data.sys_phone);
          //   this.$cookies.set('consumerHotline',res.data.sys_phone);
          //   this.$store.commit('domainName', res.data.site_url);
          //   this.$cookies.set('domainName',res.data.site_url);
          //   this.$store.commit('openService', res.data.is_open_service);
          //   this.$cookies.set('openService',res.data.is_open_service);
          // })
        }
      }
    }
</script>

<style scoped lang="scss">
  .footer{
    margin-top: 50px;
    background-color: #f2f2f2;
    // position: fixed;
    bottom: 0;
    width: 100%;
    z-index: 9999;
    ul{
      height: 104px;
      border-bottom: 1px solid #E2E2E2;
      li{
        .picture{
          width: 40px;
          height: 40px;
          border: 1px solid #707070;
          border-radius: 50%;
          text-align: center;
          line-height: 40px;
          margin-right: 14px;
          .iconfont{
            font-size: 23px;
            color: #707070;
          }
        }
      }
    }
    .recordNum{
      text-align: center;
      font-size: 12px;
      line-height: 22px;
      color: #282828;
      padding: 30px 0 48px 0;
      img{
        width: 14px;
        height: 14px;
        display: inline-block;
        margin-right: 1px;
        position: relative;
        top: 2px;
      }
      .address{
        margin-left: 40px;
      }
      .record{
        margin-top: 6px;
        .num{
          margin-left: 10px;
          &:hover{
            color: #E93323
          }
        }
      }
    }
    span.copyright{
        cursor: default;
    }
    .copyright{
        color: #999;
        &:after{
            content: '|';
            display: inline-block;
            color: #ccc;
            font-size: 16px;
            margin: 0 10px;
        }
        &:last-child{
            &:after{
                display: none;
            }
        }
    }
  }
</style>
