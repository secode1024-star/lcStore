<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix" ref="tableheader">
        <span>用户注册协议</span>
      </div>
      <Tinymce v-model="merTypeDescData" class="mb35"></Tinymce>
      <div class="acea-row row-center-wrapper">
        <el-button type="primary" @click="SaveUniq">提交</el-button>
      </div>
    </el-card>
  </div>
</template>
<script>
import Tinymce from '@/components/Tinymce/index';
import { configSaveUniq, configGetUniq } from '@/api/systemConfig';
export default {
  components: { Tinymce },
  data() {
    return {
      merTypeDescData: '',
    };
  },
  mounted() {
    this.getAuthQuery();
  },
  methods: {
    getAuthQuery() {
      configGetUniq({ key: 'merLoginAgreement' }).then((data) => {
        this.merTypeDescData = data;
      });
    },
    SaveUniq() {
      if (!this.merTypeDescData) return this.$message.warning('请添加内容');
      configSaveUniq({ key: 'merLoginAgreement', value: this.merTypeDescData }).then((data) => {
        this.$message.success('提交成功');
      });
    },
  },
};
</script>
<style scoped>
.clearfix span {
  text-align: center;
  font-size: 20px;
  font-weight: 800;
  display: block;
}
</style>
