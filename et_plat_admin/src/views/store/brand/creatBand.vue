<template>
  <el-dialog
    v-if="dialogVisible"
    title="品牌"
    :visible.sync="dialogVisible"
    :before-close="handleClose"
    :closeOnClickModal="false"
  >
    <el-form
      ref="dataForm"
      :model="dataForm"
      label-width="100px"
      v-if="dialogVisible"
      :rules="rules"
      v-loading="loadingFrom"
    >
      <el-form-item label="品牌名称" prop="name">
        <el-input v-model="dataForm.name" placeholder="请输入品牌名称" />
      </el-form-item>
      <el-form-item label="商品分类" prop="categoryIdData">
        <el-cascader
          ref="cascader"
          v-model="dataForm.categoryIdData"
          :options="adminProductClassify"
          :props="categoryProps"
          style="width: 100%"
        />
      </el-form-item>
      <el-form-item label="品牌图标(180*180)">
        <div class="upLoadPicBox" @click="modalPicTap('1')">
          <div v-if="dataForm.icon" class="pictrue">
            <img :src="dataForm.icon" />
          </div>
          <div v-else class="upLoad">
            <i class="el-icon-camera cameraIconfont" />
          </div>
        </div>
      </el-form-item>
      <el-form-item label="排序" prop="sort">
        <el-input-number
          v-model="dataForm.sort"
          :min="$constants.NUM_Range.min"
          :max="$constants.NUM_Range.max"
        ></el-input-number>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="handleClose('dataForm')">取 消</el-button>
      <el-button type="primary" :loading="loading" @click="onsubmit('dataForm')">确 定</el-button>
    </span>
  </el-dialog>
</template>

<script>
import * as storeApi from '@/api/store';
import { mapGetters } from 'vuex';
export default {
  name: 'creatClassify',
  props: {
    editData: {
      type: Object,
      default: () => {
        return {};
      },
    },
  },
  computed: {
    ...mapGetters(['adminProductClassify']),
  },
  data() {
    return {
      categoryProps: {
        value: 'id',
        label: 'name',
        children: 'childList',
        expandTrigger: 'hover',
        checkStrictly: false,
        emitPath: false,
        multiple: true,
      },
      dialogVisible: false,
      treeList: [],
      loading: false,
      loadingFrom: false,
      rules: {
        name: [{ required: true, message: '请输入品牌名称', trigger: 'blur' }],
        categoryIdData: [{ required: true, message: '请选择商品分类', trigger: 'change' }],
      },
      dataForm: { ...this.editData },
    };
  },
  watch: {
    editData: {
      handler: function (val) {
        if (val.categoryIds) val.categoryIdData = val.categoryIds.split(',');
        val.sort = val.sort ? val.sort : 0;
        val.icon = val.icon ? val.icon : '';
        this.dataForm = { ...val };
      },
      deep: true,
    },
  },
  methods: {
    // 点击商品图
    modalPicTap(tit) {
      const _this = this;
      this.$modalUpload(
        function (img) {
          _this.dataForm.icon = img[0].sattDir;
        },
        tit,
        'store',
      );
    },
    handleClose() {
      this.$refs['dataForm'].resetFields();
      this.$nextTick(() => {
        this.dialogVisible = false;
      });
    },
    onClose() {
      this.$refs['dataForm'].resetFields();
      this.$nextTick(() => {
        this.dialogVisible = false;
      });
      this.loading = false;
      this.$emit('getList');
      localStorage.removeItem('productBrand');
    },
    onsubmit(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.loading = true;
          this.dataForm.categoryIds = this.dataForm.categoryIdData.toString();
          !this.dataForm.id
            ? storeApi
                .brandAddApi(this.dataForm)
                .then((res) => {
                  this.$message.success('操作成功');
                  this.onClose();
                })
                .catch(() => {
                  this.loading = false;
                })
            : storeApi
                .brandUpdateApi(this.dataForm)
                .then((res) => {
                  this.$message.success('操作成功');
                  this.onClose();
                })
                .catch(() => {
                  this.loading = false;
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
.lang {
  width: 100%;
  ::v-deep.el-form-item__content {
    width: 79%;
  }
}
.pictrue {
  width: 60px;
  height: 60px;
  border: 1px dotted rgba(0, 0, 0, 0.1);
  margin-right: 10px;
  position: relative;
  cursor: pointer;
  img {
    width: 100%;
    height: 100%;
  }
  video {
    width: 100%;
    height: 100%;
  }
}
</style>
