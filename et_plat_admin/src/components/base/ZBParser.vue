<template>
  <div>
    <parser
      v-if="formConf.fields.length > 0"
      v-loading="loading"
      :is-edit="isCreate === 1"
      :form-conf="formConf"
      :form-edit-data="editData"
      @submit="handlerSubmit"
      @resetForm="resetForm"
      :key="keyNum"
      @closeDialog="closeDialog"
    />
    <!--editData:{{ editData }}-->
    <!--    formConf:{{ formConf }}-->
    <!--    isCreate:{{ isCreate }}-->
  </div>
</template>

<script>
/**
 * 注意：和Parser唯一的区别就是这里仅仅传入表单配置id即可自动加载已配置的表单
 *      数据后渲染表单，
 *      其他业务和Parser保持一致
 */
import * as systemFormConfigApi from '@/api/systemFormConfig.js';
import parser from '@/components/FormGenerator/components/parser/Parser';
import { Debounce } from '@/utils/validate';
export default {
  name: 'ZBParser',
  components: { parser },
  props: {
    formId: {
      type: Number,
      required: true,
    },
    isCreate: {
      type: Number,
      default: 0, // 0=create 1=edit
    },
    editData: {
      type: Object,
    },
    keyNum: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      loading: false,
      formConf: { fields: [] },
    };
  },
  watch: {
    keyNum: {
      handler(val) {
        this.formConf = { fields: [] };
        this.handlerGetFormConfig(this.formId);
      },
      deep: true,
      immediate: false,
    },
  },
  mounted() {
    this.handlerGetFormConfig(this.formId);
  },
  methods: {
    closeDialog() {
      this.$emit('beforeClose');
    },
    handlerGetFormConfig(formId) {
      // 获取表单配置后生成table列
      this.loading = true;
      const _pram = { id: formId };
      systemFormConfigApi
        .getFormConfigInfo(_pram)
        .then((data) => {
          this.formConf = JSON.parse(data.content);
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    handlerSubmit: Debounce(function (formValue) {
      this.$emit('submit', formValue);
    }),
    resetForm(formValue) {
      this.$emit('resetForm', formValue);
    },
  },
};
</script>

<style scoped></style>
