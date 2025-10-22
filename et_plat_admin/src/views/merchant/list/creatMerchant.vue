<template>
  <el-dialog title="商户" :visible.sync="dialogVisible" :before-close="handleClose" :closeOnClickModal="false">
    <el-form v-loading="loadingFrom" ref="dataForm" :inline="true" :model="dataForm" label-width="100px" :rules="rules">
      <el-form-item label="" class="el-alert">
        <el-alert title="商户账号为邮箱账号，创建商户后密码将直接显示在商户列表中" type="info" effect="dark"> </el-alert>
      </el-form-item>
      <el-form-item label="商户名称" prop="name" class="lang">
        <el-input
          v-model="dataForm.name"
          :maxlength="isCn ? '8' : '16'"
          :readonly="isDisabled"
          placeholder="请输入商户名称"
        />
      </el-form-item>
      <el-form-item
        prop="email"
        label="商户账号"
        class="inline"
        :rules="[
          { required: true, message: '请输入邮箱地址', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱地址', trigger: ['blur', 'change'] },
        ]"
      >
        <el-input
          :disabled="merId > 0"
          v-model="dataForm.email"
          :readonly="isDisabled"
          placeholder="请输入商户邮箱"
        ></el-input>
      </el-form-item>
      <el-form-item label="商户手机号" prop="phone" class="inline">
        <el-input v-model="dataForm.phone" :readonly="isDisabled" placeholder="请输入商户手机号" />
      </el-form-item>
      <el-form-item label="商户姓名" prop="realName" class="inline">
        <el-input v-model="dataForm.realName" :readonly="isDisabled" placeholder="请输入商户姓名" />
      </el-form-item>
      <el-form-item label="商户分类" prop="categoryId" class="inline">
        <el-select
          v-model="dataForm.categoryId"
          placeholder="请选择商户分类"
          :disabled="isDisabled"
          @change="onChange(dataForm.categoryId)"
        >
          <el-option v-for="item in merchantClassify" :key="item.id" :label="item.name" :value="item.id"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="手续费(%)" prop="handlingFee" class="inline">
        <el-input-number
          :disabled="isDisabled"
          v-model="dataForm.handlingFee"
          :min="0"
          :precision="2"
        ></el-input-number>
      </el-form-item>
      <el-form-item label="店铺类型" prop="typeId" class="inline">
        <el-select v-model="dataForm.typeId" placeholder="请选择店铺类型" :disabled="isDisabled">
          <el-option v-for="(item, index) in merchantType" :key="index" :label="item.name" :value="item.id"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item v-if="dataForm.password" label="登录密码" prop="password" class="inline">
        <el-input v-model="dataForm.password" :readonly="isDisabled" placeholder="请输入登录密码" />
      </el-form-item>
      <el-form-item label="商户关键字" prop="keywords" class="inline">
        <el-input v-model="dataForm.keywords" :readonly="isDisabled" placeholder="请输入商户关键字" />
      </el-form-item>
      <el-form-item label="排序" prop="sort" class="inline">
        <el-input-number
          v-model="dataForm.sort"
          :disabled="isDisabled"
          :min="$constants.NUM_Range.min"
          :max="$constants.NUM_Range.max"
        ></el-input-number>
      </el-form-item>
      <el-form-item label="商户地址" prop="address" class="lang">
        <el-input
          type="textarea"
          row="3"
          v-model="dataForm.address"
          :readonly="isDisabled"
          placeholder="请输入商户地址"
        />
      </el-form-item>
      <el-form-item label="资质图片：" prop="sliderImages" class="sliderImages">
        <div class="acea-row">
          <div
            v-for="(item, index) in dataForm.sliderImages"
            :key="index"
            class="pictrue"
            draggable="true"
            @dragstart="handleDragStart($event, item)"
            @dragover.prevent="handleDragOver($event, item)"
            @dragenter="handleDragEnter($event, item)"
            @dragend="handleDragEnd($event, item)"
          >
            <img :src="item" />
            <i v-if="!isDisabled" class="el-icon-error btndel" @click="handleRemove(index)" />
          </div>
          <div v-if="dataForm.sliderImages.length < 10 && !isDisabled" class="upLoadPicBox" @click="modalPicTap('2')">
            <div class="upLoad">
              <i class="el-icon-camera cameraIconfont" />
            </div>
          </div>
        </div>
      </el-form-item>
      <!--<el-form-item label="微信分账商户号" prop="name">-->
      <!--<el-input v-model="dataForm.name" placeholder="请输入商户手机号" />-->
      <!--</el-form-item>-->
      <el-form-item label="备注" prop="remark" class="lang">
        <el-input v-model="dataForm.remark" :readonly="isDisabled" type="textarea" placeholder="请输入备注" />
      </el-form-item>
      <el-form-item label="星级评分" v-if="merId > 0" class="inline">
        <el-rate :disabled="merId > 0 && isDisabled" v-model="dataForm.starLevel" style="margin-top: 8px"></el-rate>
      </el-form-item>
      <el-form-item label="是否开启" v-if="dataForm.isSwitch" class="inline">
        <el-switch
          v-model="dataForm.isSwitch"
          :disabled="isDisabled"
          :active-value="true"
          :inactive-value="false"
          active-text="显示"
          inactive-text="隐藏"
        ></el-switch>
      </el-form-item>
      <el-form-item label="是否推荐" class="inline">
        <el-switch
          v-model="dataForm.isRecommend"
          :disabled="isDisabled"
          :active-value="true"
          :inactive-value="false"
          active-text="推荐"
          inactive-text="不推荐"
        ></el-switch>
      </el-form-item>
      <el-form-item label="是否自营" class="inline">
        <el-switch
          v-model="dataForm.isSelf"
          :disabled="isDisabled"
          :active-value="true"
          :inactive-value="false"
          active-text="自营"
          inactive-text="非自营"
        ></el-switch>
      </el-form-item>
      <el-form-item label="商品审核" class="inline">
        <el-switch
          v-model="dataForm.productSwitch"
          :disabled="isDisabled"
          :active-value="true"
          :inactive-value="false"
          active-text="开启"
          inactive-text="关闭"
        ></el-switch>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer" v-if="!isDisabled">
      <el-button @click="handleClose('dataForm')">取 消</el-button>
      <el-button type="primary" :loading="loading" @click="onsubmit('dataForm')">确 定</el-button>
    </span>
  </el-dialog>
</template>

<script>
import * as merchant from '@/api/merchant';
import { mapGetters } from 'vuex';

export default {
  name: 'creatClassify',
  computed: {
    ...mapGetters(['merchantClassify', 'merchantType']),
  },
  props: {
    //商户id
    merId: {
      type: Number,
      default: 0,
    },
    isDisabled: {
      type: Boolean,
      default: false,
    },
    dialogVisible: {
      type: Boolean,
      default: false,
    },
    indexKey: {
      type: Number,
      default: 0,
    },
  },
  data() {
    const validatePhone = (rule, value, callback) => {
      if (!value) {
        return callback(new Error('请填写手机号'));
      } else {
        callback();
      }
    };
    return {
      loading: false,
      loadingFrom: false,
      rules: {
        name: [{ required: true, message: '请输入商户名称', trigger: 'blur' }],
        account: [{ required: true, message: '请输入商户账号', trigger: 'blur' }],
        categoryId: [{ required: true, message: '请选择商户分类', trigger: 'change' }],
        typeId: [{ required: true, message: '请选择店铺类型', trigger: 'change' }],
        password: [{ required: true, message: '请输入登录密码', trigger: 'blur' }],
        realName: [{ required: true, message: '请输入商户姓名', trigger: 'blur' }],
        keywords: [{ required: true, message: '请输入商户关键字', trigger: 'blur' }],
        address: [{ required: true, message: '请输入商户地址', trigger: 'blur' }],
        phone: [{ required: true, validator: validatePhone, trigger: 'blur' }],
        handlingFee: [{ required: true, message: '请输入手续费', trigger: 'blur' }],
        sliderImages: [{ required: true, message: '请上传资质图片', type: 'array', trigger: 'change' }],
      },
      dataForm: {
        account: '',
        address: '',
        categoryId: null,
        email: '',
        handlingFee: 0,
        isRecommend: false,
        isSelf: false,
        isSwitch: false,
        keywords: '',
        name: '',
        password: '',
        phone: '',
        productSwitch: false,
        qualificationPicture: '',
        realName: '',
        remark: '',
        sort: 0,
        typeId: null,
        sliderImages: [],
        id: 0,
      },
      isCn: true,
    };
  },
  watch: {
    indexKey: {
      handler: function (val) {
        this.onInfo();
      },
      deep: true,
    },
    'dataForm.name': function (val) {
      let pattern = new RegExp('[\u4E00-\u9FA5]+');
      let pattern2 = new RegExp('[A-Za-z]+');
      if (pattern.test(val)) {
        this.isCn = true;
      } else if (pattern2.test(val)) {
        this.isCn = false;
      }
    },
  },
  mounted() {
    if (!this.merchantClassify.length) this.$store.dispatch('merchant/getMerchantClassify');
    if (!this.merchantType.length) this.$store.dispatch('merchant/getMerchantType');
    if (this.merId > 0) this.onInfo();
  },
  methods: {
    onChange(id) {
      this.dataForm.handlingFee = this.merchantClassify.find((item) => item.id === id).handlingFee;
    },
    // 详情
    onInfo() {
      if (!this.merchantClassify.length) this.$store.dispatch('merchant/getMerchantClassify');
      if (!this.merchantType.length) this.$store.dispatch('merchant/getMerchantType');
      this.loadingFrom = true;
      merchant.merchantDetailApi(this.merId).then((res) => {
        this.$set(res, 'sliderImages', JSON.parse(res.qualificationPicture));
        this.dataForm = res;
        this.loadingFrom = false;
      });
    },
    // 点击商品图
    modalPicTap(tit) {
      const _this = this;
      this.$modalUpload(
        function (img) {
          if (img.length > 10) return this.$message.warning('最多选择10张图片！');
          if (img.length + _this.dataForm.sliderImages.length > 10) return this.$message.warning('最多选择10张图片！');
          img.map((item) => {
            _this.dataForm.sliderImages.push(item.sattDir);
          });
        },
        tit,
        'store',
      );
    },
    handleClose() {
      this.$nextTick(() => {
        this.$emit('closeModel');
        this.$refs['dataForm'].resetFields();
      });
    },
    handleRemove(i) {
      this.dataForm.sliderImages.splice(i, 1);
    },
    onClose() {
      this.$refs['dataForm'].resetFields();
      this.$emit('closeModel');
      this.loading = false;
      this.$emit('getList');
    },
    onsubmit(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.loading = true;
          this.dataForm.qualificationPicture = JSON.stringify(this.dataForm.sliderImages);
          this.dataForm.id === 0
            ? merchant
                .merchantAddApi(this.dataForm)
                .then((res) => {
                  this.$message.success('商户创建成功！登录密码已显示在商户列表中');
                  this.onClose();
                })
                .catch(() => {
                  this.loading = false;
                })
            : merchant
                .merchantUpdateApi(this.dataForm)
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
    handleDragEnter(e, item) {
      e.dataTransfer.effectAllowed = 'move';
      if (item === this.dragging) {
        return;
      }
      const newItems = [...this.dataForm.sliderImages];
      const src = newItems.indexOf(this.dragging);
      const dst = newItems.indexOf(item);
      newItems.splice(dst, 0, ...newItems.splice(src, 1));
      this.dataForm.sliderImages = newItems;
    },
  },
};
</script>

<style scoped lang="scss">
.sliderImages {
  ::v-deep .el-form-item__error {
    width: 100px;
  }
}
.el-alert {
  line-height: 20px;
  margin-left: 41px;
  margin-bottom: 9px;
  width: 90%;
  ::v-deep.el-form-item__content {
    width: 94%;
  }
}
.lang {
  width: 93.5%;
  ::v-deep.el-form-item__content {
    width: 79%;
  }
}
.inline {
  // width: 228px;
  ::v-deep.el-form-item__content,
  ::v-deep.el-input-number {
    width: 228px;
  }
  ::v-deep.el-select {
    width: 100%;
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
