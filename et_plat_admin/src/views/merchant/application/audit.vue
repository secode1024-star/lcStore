<template>
  <div class="box">
    <el-drawer
      :visible.sync="dialogVisible"
      :title="isSHOW ? '商户入驻审核' : '商户详情'"
      :direction="direction"
      @close="close"
      size="700px"
    >
      <div class="demo-drawer__content divBox">
        <el-form ref="dataForm" :inline="true" :model="dataForm" label-width="100px" v-if="dialogVisible">
          <el-form-item label="商户名称：" prop="name">
            <el-input v-model="dataForm.name" :readonly="isDisabled" placeholder="请输入商户名称" />
          </el-form-item>
          <el-form-item label="商户账号：">
            <el-input v-model="dataForm.email" :readonly="isDisabled" placeholder="请输入商户账号" />
          </el-form-item>
          <el-form-item label="商户分类：" prop="categoryId">
            <span class="widths">{{ dataForm.categoryId | merCategoryFilter }}</span>
          </el-form-item>
          <el-form-item label="店铺类型：" prop="typeId">
            <span class="widths">{{ dataForm.typeId | merchantTypeFilter }}</span>
          </el-form-item>
          <el-form-item v-if="dataForm.password" label="登录密码" prop="password">
            <el-input v-model="dataForm.password" :readonly="isDisabled" placeholder="请输入登录密码" />
          </el-form-item>
          <el-form-item label="商户姓名：" prop="realName">
            <el-input v-model="dataForm.realName" :readonly="isDisabled" placeholder="请输入商户姓名" />
          </el-form-item>
          <el-form-item label="商户手机号：" prop="phone">
            <span class="widths">{{ dataForm.phone | filterEmpty }}</span>
          </el-form-item>
          <el-form-item prop="email" label="邮箱：" class="inline">
            <el-input v-model="dataForm.email" :readonly="isDisabled"></el-input>
          </el-form-item>
          <el-form-item label="手续费(%)：" prop="handlingFee">
            <el-input :disabled="isDisabled" v-model="dataForm.handlingFee" :min="0" :precision="2"></el-input>
          </el-form-item>
          <el-form-item label="商户地址：" prop="address" class="lang">
            <span class="langcent">{{ dataForm.address }}</span>
          </el-form-item>
          <el-form-item label="商户关键字：" prop="keywords" class="inline">
            <el-input v-model="dataForm.keywords" :readonly="isDisabled" placeholder="请输入商户手机号" />
          </el-form-item>
          <el-form-item label="备注：" prop="remark" class="lang">
            <span class="widths">{{ dataForm.remark ? dataForm.remark : '无' }}</span>
          </el-form-item>
          <el-form-item label="资质图片：" class="lang">
            <div class="acea-row">
              <div
                v-for="(item, index) in dataForm.qualificationPictureData"
                :key="index"
                class="pictrue"
                draggable="true"
                @dragstart="handleDragStart($event, item)"
                @dragover.prevent="handleDragOver($event, item)"
                @dragenter="handleDragEnter($event, item)"
                @dragend="handleDragEnd($event, item)"
              >
                <el-image :src="item" :preview-src-list="dataForm.qualificationPictureData"> </el-image>
              </div>
            </div>
          </el-form-item>
        </el-form>
      </div>
      <div v-if="isSHOW" class="from-foot-btn fix btn-shadow">
        <el-form ref="ruleForm" :model="ruleForm" :rules="rules" label-width="80px" class="demo-ruleForm">
          <el-form-item label="审核状态" prop="auditStatus">
            <el-radio-group v-model="ruleForm.auditStatus">
              <el-radio :label="2">通过</el-radio>
              <el-radio :label="3">拒绝</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="ruleForm.auditStatus === 3" label="原因" prop="denialReason">
            <el-input v-model="ruleForm.denialReason" type="textarea" placeholder="请输入原因" />
          </el-form-item>
          <el-form-item>
            <el-button @click="close">取 消</el-button>
            <el-button type="primary" @click="onSubmit('ruleForm')">{{
              loadingBtn ? '提交中 ...' : '确 定'
            }}</el-button>
          </el-form-item>
        </el-form>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import { merApplyAuditApi } from '@/api/merchant';
import { mapGetters } from 'vuex';
export default {
  name: 'audit',
  data() {
    return {
      dialogVisible: false,
      direction: 'rtl',
      isDisabled: true,
      rules: {
        auditStatus: [{ required: true, message: '请选择审核状态', trigger: 'change' }],
        denialReason: [{ required: true, message: '请填写拒绝原因', trigger: 'blur' }],
      },
      ruleForm: {
        denialReason: '',
        auditStatus: 2,
        id: '',
      },
      loadingBtn: false,
    };
  },
  props: {
    merData: {
      type: Object,
      default: () => null,
    },
    isSHOW: {
      type: String,
      default: () => '',
    },
  },
  computed: {
    ...mapGetters(['merchantClassify', 'merchantType']),
  },
  watch: {
    merData: {
      handler: function (val) {
        if (val.qualificationPicture) val.qualificationPictureData = JSON.parse(val.qualificationPicture);
        this.dataForm = { ...val };
      },
      deep: true,
    },
  },
  methods: {
    close() {
      this.dialogVisible = false;
      this.ruleForm = {
        denialReason: '',
        auditStatus: 2,
      };
    },
    onSubmit(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.loadingBtn = true;
          this.ruleForm.id = this.dataForm.id;
          merApplyAuditApi(this.ruleForm)
            .then((res) => {
              this.$message.success('操作成功');
              this.dialogVisible = false;
              this.$emit('subSuccess');
              this.loadingBtn = false;
            })
            .catch((res) => {
              this.loadingBtn = false;
            });
        } else {
          return false;
        }
      });
    },
  },
};
</script>

<style scoped lang="scss">
.box {
  ::v-deep.el-drawer__header {
    margin-bottom: 0 !important;
    font-size: 20px;
  }
}
.demo-drawer__content {
  min-height: 600px;
}
.widths {
  width: 169px;
  display: inline-block;
  color: #606266;
}
.langcent {
  display: inline-block;
  color: #606266;
  width: 100%;
}
.lang {
  width: 100%;
  ::v-deep.el-form-item__content {
    width: 79%;
  }
}
.divBox {
  ::v-deep .el-input__inner:hover,
  ::v-deep.el-input > input,
  ::v-deep.el-textarea > textarea {
    border: none;
    padding: 0;
  }
  ::v-deep .el-form-item {
    margin-bottom: 6px;
  }
  ::v-deep.el-card__body {
    padding: 5px;
  }
  ::v-deep .el-input.is-disabled .el-input__inner {
    background: none;
    cursor: none;
    color: #606266;
  }
}
.pictrue {
  width: 60px;
  height: 60px;
  border: 1px dotted rgba(0, 0, 0, 0.1);
  margin-right: 10px;
  position: relative;
  cursor: pointer;
  .el-image {
    width: 100%;
    height: 100%;
  }
  video {
    width: 100%;
    height: 100%;
  }
}
</style>
