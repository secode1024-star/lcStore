<template>
  <div class="el-form">
    <div class="img-box-wrapper">
      <el-upload
        list-type="picture-card"
        :headers="myHeaders"
        :limit="limitNum"
        :action="upLoadUrl"
        :on-remove="handleRemove"
        :http-request="handleUploadForm"
        :on-exceed="handleExceed"
        :show-file-list="isShow"
        :disabled="pics.length>maxlength"
        :before-upload="beforeUpload"
        :on-change="handleEditChange"
        :class="{hide:hideUploadEdit}">
        <i class="el-icon-plus"></i>
      </el-upload>
    </div>
  </div>
</template>

<script>
  import {Debounce} from '@/utils/validate.js'

  export default {
    name: "upload",
    data() {
      return {
        myHeaders: {},
        pics: [],
        upLoadUrl: process.env.BASE_URL + "/api/front/upload/image",
        hideUploadEdit: false
      }
    },
    props: {
      // 最多可上传的张数
      maxlength: {
        type: Number,
        default: 5
      },
      // 最多可上传的张数
      limitNum: {
        type: Number,
        default: 5
      },
      isShow: {
        type: Boolean,
        default: true
      }
    },
    methods: {
      handleExceed() {
        this.$message.warning(this.$t(`message.tips.upPic`));
      },
      // 上传
      handleUploadForm(param) {
        const formData = new FormData();
        formData.append('multipart', param.file);
        this.$axios
          .post(process.env.BASE_URL + "/api/front/upload/image?model=product&pid=1", formData)
          .then((res) => {
            this.pics.push(res.data.url);
            this.$emit('picList', this.isShow ? this.pics : res.data.url)
          })
      },
      beforeUpload: Debounce(function (file) {
        const isImage = file.type === "image/jpeg" || file.type === "image/png";
        if (!isImage) {
          this.$message.error(this.$t(`message.tips.picTips`));
        }
        return isImage;
      }),
      handleEditChange(file, fileList) {
        this.hideUploadEdit = fileList.length >= this.limitNum
      },
      handleRemove(file, fileList) {
        this.pics = [];
        fileList.forEach(item => {
          this.pics.push(item.url);
        });
        this.hideUploadEdit = false;
        this.$emit('picList', this.pics)
      },
    }
  }
</script>

<style scoped lang="scss">
  .el-form {
    ::v-deep.el-upload--picture-card {
      width: 100px;
      height: 100px;
      border-style: solid;
      line-height: 100px;
    }
  }

  .img-box-wrapper {
    display: flex;
    flex-wrap: wrap;
    ::v-deep.el-upload-list--picture-card .el-upload-list__item {
      width: 100px;
      height: 100px;
    }
    .img-item {
      position: relative;
      width: 100px;
      height: 100px;
      margin-right: 20px;
      margin-bottom: 12px;
      border: 1px solid #c0ccda;
      border-radius: 6px;
      img {
        width: 100%;
        height: 100%;
        border-radius: 6px;
      }
      .icon {
        position: absolute;
        right: -10px;
        top: -8px;
        font-size: 20px;
        cursor: pointer;
        color: #e93323;
      }
    }
  }

  ::v-deep .hide .el-upload--picture-card {
    display: none;
  }
</style>
