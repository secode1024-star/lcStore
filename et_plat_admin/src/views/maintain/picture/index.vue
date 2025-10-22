<template>
  <div class="divBox">
    <el-card class="box-card">
      <upload-picture :pictureType="pictureType" :isModal="isModal"></upload-picture>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'index',
  data() {
    return {
      pictureType: 'maintain',
      isModal: true,
    };
  },
};
</script>

<style scoped></style>
