<template>
  <div class="divBox">
    <el-card class="box-card">
      <upload-picture :pictureType="pictureType"></upload-picture>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'index',
  data() {
    return {
      pictureType: 'maintain',
    };
  },
};
</script>

<style scoped></style>
