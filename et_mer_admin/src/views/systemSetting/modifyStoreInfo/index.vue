<template>
  <div class="divBox relative">
    <el-card class="box-card">
      <div slot="header" class="clearfix" ref="tableheader">
        <el-tabs
          v-model="loginType"
          @tab-click="getChange"
          v-hasPermi="['merchant:base:info', 'merchant:config:info', 'merchant:transfer:info']"
        >
          <el-tab-pane :label="item.name" :name="item.type.toString()" v-for="(item, index) in headeNum" :key="index" />
        </el-tabs>
        <!--商户信息-->
        <div v-if="loginType === '1' && checkPermi(['merchant:base:info'])" class="information">
          <div class="basic-information" v-loading="loading">
            <div>商户名称：{{ merData.name }}</div>
            <div>商户邮箱：{{ merData.email }}</div>
            <div>商户负责人手机号：{{ merData.phone }}</div>
            <div>商户负责人姓名：{{ merData.realName }}</div>
            <div>商户分类：{{ merData.merCategory }}</div>
            <div>商户类别：{{ merData.isSelf | selfTypeFilter }}</div>

            <div>店铺类型：{{ merData.merType }}</div>
            <div>商户手续费：{{ merData.handlingFee }}%</div>
            <div>添加商品：{{ merData.productSwitch ? '需平台审核' : '平台免审核' }}</div>
            <div>商户星级：<el-rate v-model="merData.starLevel" disabled text-color="#ff9900"> </el-rate></div>
            <div>商户入驻时间：{{ merData.createTime }}</div>
            <div v-if="merData.qualificationPicture">
              商户资质：
              <div class="acea-row">
                <div v-for="(item, index) in JSON.parse(merData.qualificationPicture)" :key="index" class="pictrue">
                  <el-image :src="item" :preview-src-list="[item]"> </el-image>
                </div>
              </div>
            </div>
            <div v-hasPermi="['merchant:switch:update']">
              开启商户：
              <el-switch
                v-model="merData.isSwitch"
                :active-value="true"
                :inactive-value="false"
                active-text="开启"
                inactive-text="关闭"
                @change="changeSwitch"
              >
              </el-switch>
            </div>
          </div>
        </div>
        <!--店铺信息-->
        <div v-if="loginType === '2' && checkPermi(['merchant:config:info'])" class="business-msg">
          <div class="form-data">
            <z-b-parser
              v-if="loginType === '2'"
              :is-create="1"
              :form-conf="formConf"
              :edit-data="editData"
              :form-id="157"
              :key-num="keyNum"
              @submit="handlerSubmit"
              @resetForm="resetForm"
            />
          </div>
        </div>
        <!--转帐信息-->
        <div v-if="loginType === '3' && checkPermi(['merchant:transfer:info'])" class="business-msg">
          <div class="form-data">
            <z-b-parser
              v-if="loginType === '3'"
              :is-create="1"
              :form-conf="formConf"
              :edit-data="transferData"
              :form-id="158"
              @submit="transferhandlerSubmit"
              @resetForm="resetForm"
              :key-num="keyNum"
            />
          </div>
        </div>
      </div>
    </el-card>
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
import {
  merchantSwitchApi,
  merchantTransferEditApi,
  getBaseInfoApi,
  merchantUpdateApi,
  merchantConfigInfoApi,
  merchantTransferApi,
} from '@/api/merchant';
import { getToken } from '@/utils/auth';
import { Debounce } from '@/utils/validate';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
import ZBParser from '../../../components/base/ZBParser';
export default {
  name: 'Information',
  components: { ZBParser },
  data() {
    var checkPhone = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请输入客服电话'));
      } else {
        let regPone = null;
        const mobile = /^1(3|4|5|6|7|8|9)\d{9}$/; // 最新16手机正则
        const tel = /^(0[0-9]{2,3}\-)([2-9][0-9]{4,7})+(\-[0-9]{1,4})?$/; // 座机
        if (value.charAt(0) == 0) {
          // charAt查找第一个字符方法，用来判断输入的是座机还是手机号
          regPone = tel;
        } else {
          regPone = mobile;
        }
        if (!regPone.test(value)) {
          return callback(new Error("请填写客服电话(座机格式'区号-座机号码')"));
        }
        callback();
      }
    };
    const validatePhone = (rule, value, callback) => {
      if (!value) {
        return callback(new Error('请填写手机号'));
      } else if (!/^1[3456789]\d{9}$/.test(value)) {
        callback(new Error('手机号格式不正确!'));
      } else {
        callback();
      }
    };
    return {
      formConf: { fields: [] },
      isCreate: 0,
      loginType: '1',
      headeNum: [
        { type: '1', name: '商户信息' },
        { type: '2', name: '店铺信息' },
        { type: '3', name: '转账信息' },
      ],
      merData: {}, // 默认数据
      submitLoading: false, // 提交loading
      editData: {},
      transferData: {},
      keyNum: 0,
      loading: false,
    };
  },
  created() {
    if (checkPermi(['merchant:base:info'])) this.getInfo();
    if (checkPermi(['merchant:config:info'])) this.getConfigInfo();
    if (checkPermi(['merchant:transfer:info'])) this.getMerchantTransfer();
  },
  mounted: function () {},
  methods: {
    checkPermi,
    changeSwitch() {
      merchantSwitchApi()
        .then((res) => {
          this.$modal.msgSuccess('修改成功');
        })
        .catch(() => {
          this.merData.isSwitch = !this.merData.isSwitch;
        });
    },
    getChange() {
      this.keyNum += 1;
    },
    handlerSubmit: Debounce(function (formValue) {
      merchantUpdateApi(formValue).then((res) => {
        this.$message.success('操作成功');
        this.getConfigInfo();
      });
    }),
    transferhandlerSubmit: Debounce(function (formValue) {
      merchantTransferEditApi(formValue).then((res) => {
        this.$message.success('操作成功');
        this.getMerchantTransfer();
      });
    }),
    // 获取商户信息
    getInfo() {
      this.loading = true;
      getBaseInfoApi()
        .then((res) => {
          this.merData = res;
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    // 获取商户配置信息
    getConfigInfo() {
      merchantConfigInfoApi().then((res) => {
        this.editData = res;
      });
    },
    // 获取转账信息
    getMerchantTransfer() {
      merchantTransferApi().then((res) => {
        this.transferData = res;
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.pictrue {
  width: 60px;
  height: 60px;
  border: 1px dotted rgba(0, 0, 0, 0.1);
  margin-right: 10px;
  position: relative;
  cursor: pointer;
  ::v-deep.el-image {
    width: 60px;
    height: 60px;
  }
  video {
    width: 100%;
    height: 100%;
  }
}
::v-deep.el-textarea__inner {
  height: 90px;
}
.information {
  width: 100%;
  display: flex;
  flex-direction: column;
  padding: 25px 0 0 94px;
  /*align-items: center;*/
  h2 {
    text-align: center;
    color: #303133;
    font-weight: bold;
    font-size: 20px;
  }
  .lab-title {
    width: max-content;
    font-size: 14px;
    font-weight: bold;
    color: #303133;
    margin: 10px 10%;
    &::before {
      content: '';
      display: inline-block;
      width: 3px;
      height: 13px;
      background-color: #1890ff;
      margin-right: 6px;
      position: relative;
      top: 1px;
    }
  }
  .user-msg {
    padding: 0 20px;
    margin-top: 30px;
  }
  .basic-information {
    font-size: 14px;
    font-weight: 400;
    text-rendering: optimizeLegibility;
    font-family: PingFangSC-Regular, PingFang SC;
    color: #000;
    > div {
      margin-bottom: 18px;
      flex-wrap: nowrap;
      display: flex;
      align-items: center;
      flex-wrap: nowrap;
      white-space: nowrap;
    }
  }
  .trip {
    padding-left: 10px;
    color: #ffb027;
    font-weight: normal;
  }
  .selWidth {
    width: 100%;
  }
  .demo-ruleForm {
    overflow: hidden;
    .form-item {
      width: 48%;
      display: inline-block;
    }
  }
  .form-data {
    padding: 30px 8%;
    .map-sty {
      width: 90%;
      text-align: right;
      margin: 0 0 0 10%;
    }
    .pictrue img {
      border-radius: 4px;
      object-fit: cover;
    }
    .tip-form {
      display: flex;
      align-items: center;
      span {
        white-space: nowrap;
        padding-left: 10px;
        line-height: 20px;
      }
    }
  }
  .submit-button {
    display: flex;
    justify-content: center;
    position: fixed;
    bottom: 20px;
    // left: 50%;
    width: 80%;
    padding: 10px 0;
    background-color: rgba(255, 255, 255, 0.7);
  }
}
.font_red {
  color: red;
  margin-right: 5px;
  font-weight: bold;
}

.margin_main {
  position: relative;
  .margin_price {
    cursor: pointer;
  }
  &:hover {
    .margin_modal {
      display: flex;
    }
  }
  .margin_modal {
    position: absolute;
    left: 0;
    top: 30px;
    border-radius: 8px;
    background: #fff;
    align-items: center;
    justify-content: center;
    z-index: 9;
    width: 250px;
    height: 320px;
    box-shadow: 2px 2px 3px 0 rgba(0, 0, 0, 0.3);
    display: none;
    .alic {
      text-align: center;
    }
    img {
      display: block;
      width: 150px;
      height: 116px;
      margin: 0 auto 50px;
    }
    span {
      margin-bottom: 10px;
      display: block;
      font-weight: normal;
      text-align: center;
    }
    .text_g {
      font-size: 16px;
      color: #303133;
    }
    .text_b {
      color: #606266;
      font-size: 18px;
      font-weight: bold;
      margin-bottom: 14px;
      &.b02 {
        color: #ef9b6f;
      }
      &.b01 {
        color: #57d1a0;
      }
    }
    .el-button {
      margin-top: 25px;
    }
  }
  .margin_refused {
    display: block;
    margin-bottom: 10px;
    text-align: center;
    color: #606266;
    span {
      display: inline;
      // color: red;
    }
  }
}
.margin_count {
  position: relative;
  display: inline-block;
  .pay_btn:hover + .erweima {
    display: block;
  }
  .erweima {
    position: absolute;
    left: 0;
    top: 30px;
    z-index: 9;
    display: none;
    width: 250px;
    height: 320px;
    text-align: center;
    background: #fff;
    border-radius: 8px;
    padding: 10px;
    box-shadow: 2px 2px 3px 0 rgba(0, 0, 0, 0.3);

    img {
      width: 160px;
      height: 160px;
      margin-top: 20px;
    }
    .pay_type {
      font-size: 16px;
      color: #303133;
      font-weight: normal;
    }
    .pay_price {
      font-size: 18px;
      color: #e57272;
      margin: 10px 0;
    }
    .pay_title {
      font-size: 16px;
      color: #303133;
      margin-top: 20px;
    }
    .pay_time {
      font-size: 12px;
      color: #6d7278;
    }
  }
}
::v-deep .el-upload--picture-card {
  width: 58px;
  height: 58px;
  line-height: 70px;
}

::v-deep.el-upload-list__item {
  width: 58px;
  height: 58px;
}

.upLoadPicBox_qualification {
  display: flex;
  flex-wrap: wrap;
  .uploadpicBox_list {
    position: relative;
    height: 58px;
    width: 58px;
    margin: 0 20px 20px 0;
    .uploadpicBox_list_image {
      position: absolute;
      top: 0;
      left: 0;
      width: 58px;
      height: 58px;
      border-radius: 4px;
      overflow: hidden;
      img {
        width: 100%;
        height: 100%;
      }
    }

    .uploadpicBox_list_method {
      position: absolute;
      top: 0;
      left: 0;
      font-size: 18px;
      font-weight: bold;
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: space-around;
      background: rgba(0, 0, 0, 0.4);
      border-radius: 4px;
      opacity: 0;
      width: 100%;
      height: 100%;
      transition: 0.3s;
    }
  }
}
.uploadpicBox_list:hover .uploadpicBox_list_method {
  z-index: 11;
  opacity: 1;
}
</style>
