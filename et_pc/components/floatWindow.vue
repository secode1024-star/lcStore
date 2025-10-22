<template>
  <div class="floatWindow">
    <div class="list">
      <div class="item" @click="kefuClick">
        <div>
          <div class="iconfont icon-lianxikefu"><img src="../assets/images/kefu.png"></div>
          <div>{{$t(`page.index.customerService`)}}</div>
        </div>
      </div>
      <div class="item" @click="goMerSettled">
        <div>
          <div class="iconfont icon-lianxikefu"><img src="../assets/images/ruzhu.png"></div>
          <div>{{$t(`page.store.title1`)}}</div>
        </div>
      </div>
      <div class="item" @click="goTop">
        <div class="iconfont icon-huidaodingbu1"><img src="../assets/images/back.png"></div>
        <div>{{$t(`page.index.top`)}}</div>
      </div>
    </div>
    
    <!-- 客服对话框组件 -->
    <CustomerServiceChat ref="customerChat" />
  </div>
</template>

<script>
  import { Debounce } from '@/utils/validate.js'
  import CustomerServiceChat from './CustomerServiceChat.vue'
  
  export default {
    name: "floatWindow",
    components: {
      CustomerServiceChat
    },
    data() {
      return {

      }
    },
    methods: {
      goMerSettled(){
        this.$router.push({
          path: `/users/merchant_settled`,
          query: { menuCur: 70}
        });
      },
      kefuClick: Debounce(function(){
        // 显示客服对话框
        this.$refs.customerChat.showChat();
      }),
      goTop: Debounce(function () {
        (function n() {
          var t = document.documentElement.scrollTop || document.body.scrollTop;
          if (t > 0) {
            window.requestAnimationFrame(n);
            window.scrollTo(0, t - t / 5)
          }
        })()
      }) ,
    }
  }
</script>

<style scoped lang="scss">
  .floatWindow {
    position: fixed;
    right: 0;
    bottom: 39%;
    width: 64px;
    z-index: 99;
    cursor: pointer;
    .list {
      .item {
        background: #FFFFFF;
        border: 1px solid #E93323;
        position: relative;
        width: 100%;
        // height: 64px;
        text-align: center;
        font-size: 12px;
        color: #5C5C5C;
        /*padding: 23px 0;*/
        line-height: 18px;
        box-shadow: 0px 0px 10px rgba(131, 71, 66, 0.1);
        opacity: 1;
        border-radius: 4px;
        margin-bottom: 10px;
        &:hover {
          color: #E93323;
        }
        .iconfont {
          margin: 5px auto;
          width: 30px;
          height: 30px;
          img{
            width: 100%;
            height: 100%;
          }
        }
        & ~ .item {
          &:before {
            position: absolute;
            content: ' ';
            width: 48px;
            height: 1px;
            background-color: #F0F0F0;
            top: 0;
            left: 50%;
            margin-left: -24px;
          }
        }
        .itemCon {
          right: 100%;
          position: absolute;
          top: 0;
          padding-right: 20px;
          .ewm {
            width: 195px;
            height: 60px;
            border: 1px solid #eeeeee;
            background-color: #fff;
            padding: 10px 15px;
            -webkit-justify-content: space-between;
            justify-content: space-between;
            align-items: center;
            color: #282828;
            .tip {
              font-size: 14px;
              width: 120px;
              text-align: left;
              line-height: 20px;
              color: rgb(189, 189, 189);
              .tel{
                color: #282828;
              }
              .chatShowBtn{
                display: inline-block;
                width: 60px;
                height: 20px;
                line-height: 20px;
                background-color: #ff7b00;
                border-radius: 100px;
                color: #fff;
                font-size: 12px;
                text-align: center;
              }
            }
            .pictrue {
              vertical-align: middle;

              .iconfont {
                margin-bottom: 0;
                color: #282828;
              }
              .arrow {
                position: absolute;
                right: 5px;
                top: 23px;
                width: 0px;
                height: 0px;
                border: 8px solid transparent;
                border-left-color: #eee;
                &:before {
                  position: absolute;
                  left: -8px;
                  top: -7px;
                  content: "";
                  width: 0px;
                  height: 0px;
                  border: 7px solid transparent;
                  border-left-color: #fff;
                }
              }
            }
          }
        }
      }
    }
  }
</style>
              }
            }
          }
        }
      }
    }
  }
</style>

              }
            }
          }
        }
      }
    }
  }
</style>

              }
            }
          }
        }
      }
    }
  }
</style>

              }
            }
          }
        }
      }
    }
  }
</style>

              }
            }
          }
        }
      }
    }
  }
</style>

