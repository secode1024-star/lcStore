<template>
  <el-form
    :model="formValidate"
    :rules="rules"
    ref="formValidate"
    label-width="120px"
    class="demo-formValidate"
    v-loading="loading"
  >
    <el-form-item label="活动名称：" prop="name">
      <el-input type="text" v-model="formValidate.name" maxlength="50" placeholder="请输入活动名称"></el-input>
    </el-form-item>
    <el-form-item label="活动简介：" prop="instruction">
      <el-input
        type="textarea"
        v-model="formValidate.instruction"
        maxlength="50"
        placeholder="请输入活动简介"
      ></el-input>
    </el-form-item>
    <el-form-item label="活动类型：" prop="type">
      <el-select v-model="formValidate.type" placeholder="请选择活动类型">
        <el-option v-for="(item, index) in typeList" :key="index" :label="item.name" :value="item.val"></el-option>
      </el-select>
      <div v-show="formValidate.type === 3">选大图模式时，需单独给商品传封面图片！（320px x 390px）</div>
    </el-form-item>
    <el-form-item label="活动排序：" prop="sort" class="productScore">
      <el-input-number v-model="formValidate.sort" :min="1" :max="999" label="活动排序"></el-input-number>
    </el-form-item>
    <label v-show="formValidate.type === 3 && formValidate.proLists.length" class="fengmian el-form-item__label"
      >封面图：</label
    >
    <el-form-item label="活动Banner：">
      <div class="acea-row">
        <div
          v-for="(item, index) in formValidate.bannerList"
          :key="index"
          class="pictrue"
          draggable="true"
          @dragstart="handleDragStart($event, item)"
          @dragover.prevent="handleDragOver($event, item)"
          @dragenter="handleDragEnter($event, item)"
          @dragend="handleDragEnd($event, item)"
        >
          <img :src="item" />
          <i class="el-icon-error btndel" @click="handleRemoveBanner(index)" />
        </div>
        <div v-if="formValidate.bannerList.length < 5" class="upLoadPicBox" @click="modalPicTap('2')">
          <div class="upLoad">
            <i class="el-icon-camera cameraIconfont" />
          </div>
        </div>
      </div>
    </el-form-item>
    <el-form-item label="商品：" prop="proLists">
      <div class="acea-row">
        <div v-for="(item, index) in formValidate.proLists" :key="index" class="mb35">
          <div
            draggable="true"
            @dragstart="handleDragStart($event, item)"
            @dragover.prevent="handleDragOver($event, item)"
            @dragenter="handleDragEnter($event, item, 'goods')"
            @dragend="handleDragEnd($event, item)"
          >
            <div class="pictrue">
              <img :src="$imageUrl(item.image)" />
              <i class="el-icon-error btndel" @click="handleRemove(index)" />
            </div>
            <el-tooltip class="item" effect="dark" :content="item.storeName" placement="top-start">
              <span class="storeName">{{ item.storeName }}</span>
            </el-tooltip>
            <div v-show="formValidate.type === 3" class="upLoadPicBox" @click="modalPicTap('1', index)">
              <div v-if="item.proImage" class="pictrue tabPic"><img :src="item.proImage" /></div>
              <div v-else class="upLoad tabPic">
                <i class="el-icon-camera cameraIconfont" />
              </div>
            </div>
          </div>
        </div>
        <div class="upLoadPicBox">
          <div class="upLoad" @click="changeGood">
            <i class="el-icon-plus cameraIconfont" />
          </div>
        </div>
      </div>
    </el-form-item>
    <el-form-item>
      <el-button
        size="mini"
        type="primary"
        @click="submitForm('formValidate')"
        v-hasPermi="['platform:activity:update']"
        :loading="loadingbtn"
        >提交</el-button
      >
    </el-form-item>
  </el-form>
</template>

<script>
import { activityAddApi, activityUpdateApi, activityInfoApi } from '@/api/activity';
import { Debounce } from '@/utils/validate';
export default {
  name: 'creataAtivity',
  props: {
    num: {
      type: Number,
      required: 0,
    },
    ativityId: {
      type: Number,
      required: 0,
    },
  },
  data() {
    var checkProductScore = (rule, value, callback) => {
      if (!value) {
        return callback(new Error('评价星级不能为空'));
      } else {
        callback();
      }
    };
    return {
      typeList: [
        {
          val: 1,
          name: '轮播列表',
        },
        {
          val: 2,
          name: '大小格',
        },
        {
          val: 3,
          name: '大图模式',
        },
      ],
      loadingbtn: false,
      loading: false,
      pics: [],
      image: '',
      formValidate: {
        name: '',
        sort: 0,
        id: null,
        proList: [],
        proLists: [],
        type: null,
        instruction: '',
        banner: '',
        bannerList: [],
      },
      rules: {
        type: [{ required: true, message: '请选择活动类型', trigger: 'change' }],
        proLists: [{ required: true, message: '请选择商品', trigger: 'change', type: 'array' }],
        name: [{ required: true, message: '请填写活动名称', trigger: 'blur' }],
        instruction: [{ required: true, message: '请填写活动简介', trigger: 'blur' }],
      },
    };
  },
  watch: {
    ativityId: {
      handler: function (val) {
        if (val === 0) this.resetForm('formValidate');
      },
      deep: true,
    },
  },
  mounted() {
    if (this.ativityId === 0) {
      this.resetForm('formValidate');
    } else {
      this.info();
    }
  },
  methods: {
    changeGood() {
      const _this = this;
      this.$modalGoodList(
        function (row) {
          if (row.length === 0) {
            _this.formValidate.proLists = [];
          } else {
            row.map((item) => {
              _this.formValidate.proLists.push({
                proId: item.id,
                sort: null,
                proImage: item.proImage || '',
                proName: item.storeName,
                productImage: item.image,
                id: item.id,
                image: item.image,
                storeName: item.storeName,
              });
            });
            var hash = {};
            _this.formValidate.proLists = row.reduce(function (item, next) {
              /* eslint-disable */
              hash[next.id] ? '' : (hash[next.id] = true && item.push(next));
              return item;
            }, []);
          }
        },
        'many',
        _this.formValidate.proLists,
      );
    },
    // 点击商品图
    modalPicTap(tit, i) {
      const _this = this;
      _this.$modalUpload(
        function (img) {
          if (tit === '1') {
            _this.$set(_this.formValidate.proLists[i], 'proImage', img[0].sattDir);
          }
          if (tit === '2') {
            if (img.length > 5) return this.$message.warning('最多选择5张图片！');
            if (img.length + _this.formValidate.bannerList.length > 5)
              return this.$message.warning('最多选择5张图片！');
            img.map((item) => {
              _this.formValidate.bannerList.push(item.sattDir);
            });
          }
        },
        tit,
        'store',
      );
    },
    handleRemoveBanner(i) {
      this.formValidate.bannerList.splice(i, 1);
    },
    handleRemove(i) {
      this.formValidate.proLists.splice(i, 1);
    },
    changeIndex(array) {
      let attrs = [];
      array.map((item, index) => {
        attrs.push({
          sort: index + 1,
          proId: item.id,
          proImage: item.proImage,
        });
      });
      return attrs;
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.loadingbtn = true;
          this.formValidate.proList = this.changeIndex(this.formValidate.proLists);
          this.formValidate.banner = JSON.stringify(this.formValidate.bannerList);
          if (this.formValidate.type === 3) {
          } else {
            this.formValidate.proList.map((item) => {
              item.proImage = '';
            });
          }
          this.ativityId === 0
            ? activityAddApi(this.formValidate)
                .then(() => {
                  this.$message.success('新增成功');
                  this.loadingbtn = false;
                  this.$emit('getList');
                })
                .catch(() => {
                  this.loadingbtn = false;
                })
            : activityUpdateApi(this.formValidate)
                .then(() => {
                  this.$message.success('编辑成功');
                  this.loadingbtn = false;
                  this.$emit('getList');
                })
                .catch(() => {
                  this.loadingbtn = false;
                });
        } else {
          return false;
        }
      });
    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
    info() {
      this.loading = true;
      activityInfoApi(this.ativityId)
        .then((res) => {
          this.formValidate = res;
          this.$set(this.formValidate, 'proLists', []);
          this.$set(
            this.formValidate,
            'bannerList',
            this.formValidate.banner ? JSON.parse(this.formValidate.banner) : [],
          );
          this.formValidate.proList.map((item) => {
            this.formValidate.proLists.push({
              proId: item.proId,
              sort: item.sort,
              proImage: item.proImage,
              id: item.proId,
              image: item.productImage,
              storeName: item.proName,
            });
          });
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    // 移动
    handleDragStart(e, item) {
      this.dragging = item;
    },
    handleDragEnd(e, item) {
      this.dragging = null;
    },
    handleDragOver(e) {
      e.dataTransfer.dropEffect = 'move';
    },
    handleDragEnter(e, item, type) {
      e.dataTransfer.effectAllowed = 'move';
      if (item === this.dragging) {
        return;
      }
      const newItems = type === 'goods' ? [...this.formValidate.proLists] : [...this.formValidate.bannerList];
      const src = newItems.indexOf(this.dragging);
      const dst = newItems.indexOf(item);
      newItems.splice(dst, 0, ...newItems.splice(src, 1));
      if (type === 'goods') {
        this.formValidate.proLists = newItems;
      } else {
        this.formValidate.bannerList = newItems;
      }
    },
  },
};
</script>

<style scoped lang="scss">
.fengmian {
  position: absolute;
  top: 389px;
  left: 52px;
}
.productScore {
  ::v-deep .el-rate {
    line-height: 2.4 !important;
  }
}
.storeName {
  width: 60px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  display: block;
  cursor: pointer;
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
}
</style>
