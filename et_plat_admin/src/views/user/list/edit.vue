<template>
  <el-form
    :model="ruleForm"
    :rules="rules"
    ref="ruleForm"
    label-width="100px"
    class="demo-ruleForm"
    v-loading="loadinginfo"
  >
    <el-form-item label="用户编号：">
      <el-input v-model="ruleForm.uid" disabled class="selWidth"></el-input>
    </el-form-item>
    <el-form-item label="真实姓名：">
      <el-input v-model="ruleForm.realName" class="selWidth"></el-input>
    </el-form-item>
    <el-form-item label="身份证号：">
      <el-input v-model="ruleForm.cardId" class="selWidth"></el-input>
    </el-form-item>
    <el-form-item label="用户地址：">
      <el-input v-model="ruleForm.addres" class="selWidth"></el-input>
    </el-form-item>
    <el-form-item label="用户备注：">
      <el-input v-model="ruleForm.mark" type="textarea" class="selWidth"></el-input>
    </el-form-item>
    <el-form-item label="用户标签：">
      <el-select v-model="labelData" placeholder="请选择" class="selWidth" clearable filterable multiple>
        <el-option :value="item.id" v-for="(item, index) in labelLists" :key="index" :label="item.name"></el-option>
      </el-select>
    </el-form-item>
    <el-form-item label="状态">
      <el-radio-group v-model="ruleForm.status">
        <el-radio :label="true">开启</el-radio>
        <el-radio :label="false">关闭</el-radio>
      </el-radio-group>
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="submitForm('ruleForm')" :loading="loading" v-hasPermi="['platform:user:update']"
        >提交</el-button
      >
      <el-button @click="resetForm('ruleForm')">取消</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
import { levelListApi, userInfoApi, userUpdateApi } from '@/api/user';
import { Debounce } from '@/utils/validate';
const defaultObj = {
  // birthday: '',
  // cardId: '',
  uid: null,
  mark: '',
  //  phone: '',
  // realName: '',
  addres: '',
  groupId: null,
  level: '',
  isPromoter: false,
  status: false,
};
export default {
  name: 'UserEdit',
  props: {
    uid: {
      type: Number,
      default: null,
    },
  },
  data() {
    return {
      ruleForm: Object.assign({}, defaultObj),
      groupData: [],
      labelData: [],
      labelLists: [],
      rules: {},
      loading: false,
      loadinginfo: false,
    };
  },
  mounted() {
    if (this.uid) this.userInfo();
    this.labelLists = JSON.parse(localStorage.getItem('tagAllList'));
  },
  methods: {
    // 详情
    userInfo() {
      this.loadinginfo = true;
      userInfoApi(this.uid)
        .then(async (res) => {
          this.ruleForm = {
            birthday: res.birthday,
            cardId: res.cardId,
            uid: res.uid,
            mark: res.mark,
            phone: res.phone,
            realName: res.realName,
            status: res.status,
            addres: res.addres,
            groupId: res.groupId ? Number(res.groupId) : null,
            level: res.level || '',
            isPromoter: res.isPromoter,
            tagId: res.tagId || '',
          };
          this.labelData = res.tagId ? res.tagId.split(',').map(Number) : [];
          this.loadinginfo = false;
        })
        .catch(() => {
          this.loadinginfo = false;
        });
    },
    submitForm: Debounce(function (formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.loading = true;
          this.ruleForm.tagId = this.labelData.join(',');
          userUpdateApi(this.ruleForm)
            .then(async (res) => {
              this.$message.success('编辑成功');
              this.$parent.$parent.visible = false;
              this.$parent.$parent.getList();
              this.loading = false;
            })
            .catch(() => {
              this.loading = false;
            });
        } else {
          return false;
        }
      });
    }),
    resetForm(formName) {
      this.$refs[formName].resetFields();
      this.$emit('resetForm');
    },
  },
};
</script>

<style scoped>
.selWidth {
  width: 90%;
}
</style>
