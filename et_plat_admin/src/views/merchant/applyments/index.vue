<template>
  <div class="divBox">
    <el-card class="box-card">
      <Tinymce v-model="formValidate.content"></Tinymce>
    </el-card>
  </div>
</template>
<script>
import Tinymce from '@/components/Tinymce/index';
export default {
  components: { Tinymce },
};
</script>
