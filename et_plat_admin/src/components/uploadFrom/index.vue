<template>
  <div>
    <el-dialog
      title="上传图片"
      :visible.sync="visible"
      width="950px"
      :modal="booleanVal"
      append-to-body
      :before-close="handleClose"
    >
      <upload-picture v-if="visible" :isMore="isMore" :modelName="modelName" @getImage="getImage" />
    </el-dialog>
  </div>
</template>

<script>
import UploadPicture from '../base/uploadPicture';
export default {
  name: 'UploadFroms',
  components: { UploadPicture },
  data() {
    return {
      visible: false,
      callback: function () {},
      isMore: '',
      modelName: '',
      ISmodal: false,
      booleanVal: false,
    };
  },
  watch: {
    // show() {
    //   this.visible = this.show
    // }
  },
  methods: {
    handleClose() {
      this.visible = false;
    },
    getImage(img) {
      this.callback(img);
      this.visible = false;
    },
  },
};
</script>

<style scoped></style>
