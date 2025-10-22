<template>
  <div class="qualify-wrapper wrapper_1200">
    <div class="qualify-main">
      <div class="qualifyMain">
        <!--店铺资质图片-->
        <div v-if="isShow" class="qualify-count">
          <div class="title">Business license x</div>
          <div class="content">
            <span class="name">address:</span>
            <span class="text">{{ merchantList.address }}</span>
          </div>
          <div class="content">
            <span class="name">collectNum:</span>
            <span class="text">{{ merchantList.collectNum }}</span>
          </div>
          <div class="content">
            <span class="name">email:</span>
            <span class="text">{{ merchantList.email }}</span>
          </div>
          <div class="content">
            <span class="name">intro:</span>
            <span class="text">{{ merchantList.intro }}</span>
          </div>
          <div class="content">
            <span class="name">phone:</span>
            <span class="text">{{ merchantList.phone }}</span>
          </div>
          <div class="content">
            <span class="name">realName:</span>
            <span class="text">{{ merchantList.realName }}</span>
          </div>
          <div class="content">
            <span class="name">qualificationPicture:</span>
            <div class="text pic">
              <img v-for="(item,index) in JSON.parse(merchantList.qualificationPicture)" :key="index" :src="item" alt="" />
            </div>
          </div>
        </div>
        <!--输入验证码-->
        <div v-else>
          <div class="com-title">{{$t(`page.user.qunTitle`)}}</div>
          <div class="desc">
            {{$t(`page.user.qunDesc`)}}
          </div>
          <el-form
            ref="ruleForm"
            label-width="80px"
            class="demo-ruleForm"
            @submit.native.prevent
          >
            <el-form-item label="验证码:">
              <el-input
                v-model="verCodeValue"
                :placeholder="$t(`page.user.qunCode`)"
                class="verifiCode"
              ></el-input>
              <!-- <span class="imageCode" @click="getVerCodeImage"><img :src="captchaData.captcha" alt=""></span> -->
              <canvasCode ref="canvasCode" @refresh_yzm="codeChange" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="onSubmit">{{$t(`page.user.submit`)}}</el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
// +----------------------------------------------------------------------
// | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2016~2023 https://www.crmeb.com All rights reserved.
// +----------------------------------------------------------------------
// | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
// +----------------------------------------------------------------------
// | Author: CRMEB Team <admin@crmeb.com>
// +----------------------------------------------------------------------
import { Message } from "element-ui";
import canvasCode from "@/components/canvascode";
export default {
  name: "qualifications",
  auth: "guest",
  data() {
    return {
      captchaData: {},
      verCodeValue: "",
      isShow: false,
      merchantList: {
        qualificationPicture:[]
      },
      content: "",
      show_num: "",
    };
  },
  async asyncData({ app, query }) {
    let merchantList = await app.$axios.get(
      `/api/front/merchant/detail/${query.id}`
    );
    return {
      merchantList: merchantList.data,
      storeName: query.storeName,
      id: query.id,
    };
  },
  head() {
    return {
      title: "用户协议与隐私政策"
    };
  },
  beforeMount() {},
  components: {
    canvasCode,
  },
  mounted() {
    let num = this.$refs.canvasCode.show_num;
    this.show_num = num.join("");
  },
  methods: {
    onSubmit() {
      let that = this;
      if (that.verCodeValue) {
        if (this.show_num !== this.verCodeValue) {
          return that.$message.error('请填写正确的验证码');
        } else {
          this.isShow  =true;
        }
      } else {
        that.$message.error("请输入验证码");
      }
    },
    codeChange(num) {
      this.show_num = num.join("");
    },
  },
};
</script>

<style lang="scss" scoped>
.qualify-wrapper {
  margin-top: 20px;
  .qualify-main {
    background: #ffffff;
    padding: 0 34px 60px;
    min-height: 670px;
  }
  .com-title {
    font-size: 20px;
    color: #282828;
    border: none;
    line-height: 74px;
    border-bottom: 1px solid #ececec;
  }
  .qualifyMain {
    .desc {
      display: block;
      margin-top: 40px;
      color: #969696;
      font-size: 16px;
    }
  }
  .el-form {
    margin-top: 60px;
    .verifiCode {
      width: 248px;
    }
    .imageCode,
    .verifiCode {
      float: left;
    }
    .imageCode {
      display: inline-block;
      margin-left: 12px;
      width: 124px;
      height: 44px;
      cursor: pointer;
      img {
        width: 124px;
        height: 44px;
      }
    }
  }
}
.qualify-count {
  padding: 30px 0;
  .title {
    font-size: 18px;
    font-family: PingFangSC-Semibold, PingFang SC;
    font-weight: 600;
    color: #333333;
    line-height: 18px;
    margin-bottom: 40px;
  }
  .content {
    margin-bottom: 26px;
    display: flex;
    .name {
      width: 200px;
      display: inline-block;
      font-size: 16px;
      font-family: ArialMT;
      color: #666666;
      line-height: 16px;
    }
    .text {
      font-size: 16px;
      font-family: ArialMT;
      color: #333333;
      line-height: 16px;
    }
    .pic {
      width: 868px;
      display: flex;
      justify-content: space-between;
      flex-wrap: wrap;
    }
    img {
      width: 424px;
      height: 299px;
      margin-bottom: 20px;
    }
  }
}
</style>
