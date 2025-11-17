<template>
  <div>
    <el-form ref="editPram" :model="editPram" label-width="130px">
      <el-form-item
        label="分类名称"
        prop="name"
        :rules="[{ required: true, message: '请输入分类名称', trigger: ['blur', 'change'] }]"
      >
        <el-input v-model="editPram.name" maxlength="30" placeholder="分类名称" />
      </el-form-item>
      <el-form-item label="父级">
        <el-cascader
          ref="cascader"
          v-model="editPram.pid"
          :disabled="isCreate === 1"
          @change="change"
          :options="parentOptions"
          :props="categoryProps"
          style="width: 100%"
        />
      </el-form-item>
      <!--</el-form-item>-->
      <el-form-item label="菜单图标" v-if="biztype.value === 5">
        <el-input placeholder="请选择菜单图标" v-model="editPram.icon">
          <el-button slot="append" icon="el-icon-circle-plus-outline" @click="addIcon"></el-button>
        </el-input>
      </el-form-item>
      <el-form-item label="分类图标(180*180)">
        <div class="upLoadPicBox" @click="modalPicTap('1')">
          <div v-if="editPram.icon" class="pictrue">
            <img :src="editPram.icon" />
          </div>
          <div v-else class="upLoad">
            <i class="el-icon-camera cameraIconfont" />
          </div>
        </div>
      </el-form-item>
      <el-form-item label="排序">
        <el-input-number v-model="editPram.sort" :min="$constants.NUM_Range.min" :max="$constants.NUM_Range.max" />
      </el-form-item>
      <el-form-item label="扩展字段" v-if="biztype.value !== 1 && biztype.value !== 3 && biztype.value !== 5">
        <el-input v-model="editPram.extra" type="textarea" placeholder="扩展字段" />
      </el-form-item>
      <el-form-item>
        <el-button
          type="primary"
          :loading="loadingBtn"
          @click="handlerSubmit('editPram')"
          v-hasPermi="['platform:category:update', 'platform:category:save']"
          >确定</el-button
        >
        <el-button @click="close">取消</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>
<!--创建和编辑公用一个组件-->
<script>
import * as categoryApi from '@/api/categoryApi.js';
import * as selfUtil from '@/utils/ZBKJIutil.js';
import * as storeApi from '@/api/store.js';
export default {
  // name: "edit"
  props: {
    prent: {
      type: Object,
      required: true,
    },
    isCreate: {
      type: Number,
      default: 0,
    },
    editData: {
      type: Object,
    },
    biztype: {
      type: Object,
      required: true,
    },
    allTreeList: {
      type: Array,
    },
  },
  data() {
    return {
      loadingBtn: false,
      constants: this.$constants,
      editPram: {
        icon: null,
        name: null,
        pid: 0,
        sort: 0,
        id: 0,
        level: 1,
      },
      categoryProps: {
        value: 'id',
        label: 'name',
        children: 'children',
        expandTrigger: 'hover',
        checkStrictly: true,
        emitPath: false,
      },
      parentOptions: [],
    };
  },
  mounted() {
    this.initEditData();
  },
  methods: {
    change() {
      if (this.$refs['cascader'].getCheckedNodes()[0])
        this.editPram.level = parseInt(this.$refs['cascader'].getCheckedNodes()[0].level) + 1;
    },
    // 点击图标
    addIcon() {
      const _this = this;
      _this.$modalIcon(function (icon) {
        _this.editPram.extra = icon;
      });
    },
    // 点击商品图
    modalPicTap(tit, num, i) {
      const _this = this;
      const attr = [];
      this.$modalUpload(
        function (img) {
          if (tit === '1' && !num) {
            _this.editPram.icon = img[0].sattDir;
          }
          if (tit === '2' && !num) {
            img.map((item) => {
              attr.push(item.attachment_src);
              _this.formValidate.slider_image.push(item);
            });
          }
        },
        tit,
        'store',
      );
    },
    close() {
      this.$emit('hideEditDialog');
    },
    initEditData() {
      this.parentOptions = [...this.allTreeList];
      const { icon, name, pid, sort, level, id } = this.editData;
      if (this.isCreate === 1) {
        this.editPram.icon = icon;
        this.editPram.name = name;
        this.editPram.pid = pid;
        this.editPram.sort = sort;
        this.editPram.level = level;
        this.editPram.id = id;
      } else {
        this.editPram.pid = this.prent.id;
        this.editPram.level = parseInt(this.prent.level) + 1;
      }
    },
    handlerSubmit(formName) {
      this.$refs[formName].validate((valid) => {
        if (!valid) return;
        this.handlerSaveOrUpdate(this.isCreate === 0);
      });
    },
    handlerSaveOrUpdate(isSave) {
      if (this.editPram.pid === 0) this.editPram.level = 1;
      if (!this.editPram.level) this.editPram.level = parseInt(this.prent.level) + 1;
      if (isSave) {
        this.loadingBtn = true;
        storeApi
          .productCategoryAddApi(this.editPram)
          .then((data) => {
            this.$emit('hideEditDialog', {
              action: 'create',
              category: {
                id: data.id || this.editPram.id,
                name: this.editPram.name
              }
            });
            this.$message.success('创建目录成功');
            this.$store.commit('product/SET_AdminProductClassify', []);
            this.loadingBtn = false;
          })
          .catch(() => {
            this.loadingBtn = false;
          });
      } else {
        if (this.editPram.pid === this.editData.id) return this.$message.warning('父级不能选当前分类');
        this.loadingBtn = true;
        storeApi
          .productCategoryUpdateApi(this.editPram)
          .then((data) => {
            this.$emit('hideEditDialog', {
              action: 'update',
              category: {
                id: this.editPram.id,
                name: this.editPram.name
              }
            });
            this.$message.success('更新目录成功');
            this.$store.commit('product/SET_AdminProductClassify', []);
            this.loadingBtn = false;
          })
          .catch(() => {
            this.loadingBtn = false;
          });
      }
    },
  },
};
</script>

<style scoped></style>
