<template>
  <el-dialog :visible.sync="modals" title="发送货" class="order_box" :before-close="handleClose" width="600px">
    <el-form ref="formItem" :model="formItem" label-width="110px" @submit.native.prevent :rules="rules">
      <div>
        <el-form-item label="快递公司：" prop="expressCode">
          <el-select v-model="formItem.expressCode" filterable style="width: 80%">
            <el-option v-for="(item, i) in express" :value="item.code" :key="i" :label="item.name"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="快递单号：" prop="expressNumber">
          <el-input v-model="formItem.expressNumber" placeholder="请输入快递单号" style="width: 80%"></el-input>
        </el-form-item>
      </div>
    </el-form>
    <div slot="footer">
      <el-button size="small" type="primary" @click="putSend('formItem')" :loading="loading">提交</el-button>
      <el-button size="small" @click="cancel('formItem')">取消</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { orderSendApi } from '@/api/order';
import { expressAllApi } from '@/api/logistics';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
import { Debounce } from '@/utils/validate';
export default {
  name: 'orderSend',
  props: {
    orderId: String,
  },
  data() {
    return {
      loading: false,
      formItem: {
        type: '1',
        expressCode: '',
        expressNumber: '',
        orderNo: '',
      },
      modals: false,
      express: [],
      exportTempList: [],
      tempImg: '',
      rules: {
        expressCode: [{ required: true, message: '请选择快递公司', trigger: 'change' }],
        expressNumber: [{ required: true, message: '请输入快递单号', trigger: 'blur' }],
      },
    };
  },
  mounted() {},
  methods: {
    checkPermi,
    // 物流公司列表
    getList() {
      expressAllApi().then(async (res) => {
        this.express = res;
      });
    },
    // 提交
    putSend: Debounce(function (name) {
      this.formItem.orderNo = this.orderId;
      this.$refs[name].validate((valid) => {
        if (valid) {
          this.loading = true;
          orderSendApi(this.formItem)
            .then((async) => {
              this.$message.success('发送货成功');
              this.modals = false;
              this.$refs[name].resetFields();
              this.$emit('submitFail');
              this.loading = false;
            })
            .catch(() => {
              this.loading = false;
            });
        } else {
          this.$message.error('请填写信息');
        }
      });
    }),
    handleClose() {
      this.cancel('formItem');
    },
    cancel(name) {
      this.modals = false;
      this.$refs[name].resetFields();
      this.formItem.type = '1';
    },
  },
};
</script>

<style scoped lang="scss">
.width8 {
  width: 80%;
}

.width9 {
  width: 70%;
}

.tempImgList {
  // opacity: 1;
  width: 38px !important;
  height: 30px !important;
  // margin-top: -30px;
  cursor: pointer;
  position: absolute;
  z-index: 11;
  img {
    width: 38px !important;
    height: 30px !important;
  }
}
</style>
