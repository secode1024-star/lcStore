<template>
  <div class="infoBox">
    <div class="demo-drawer__content">
      <div class="divBox" v-if="formValidate && isShow">
        <div slot="header" class="clearfix">
          <el-tabs v-model="currentTab">
            <el-tab-pane label="商品信息" name="0"></el-tab-pane>
            <el-tab-pane label="商品详情" name="1"></el-tab-pane>
            <el-tab-pane label="其他设置" name="2"></el-tab-pane>
          </el-tabs>
        </div>
        <el-form
          ref="formValidate"
          v-loading="loading"
          class="formValidate"
          :model="formValidate"
          label-width="100px"
          @submit.native.prevent
        >
          <el-row v-show="currentTab === '0'" :gutter="24">
            <!-- 商品信息-->
            <el-col :span="24">
              <el-form-item label="商品名称：" prop="storeName">
                <span class="spfont">{{ formValidate.storeName }}</span>
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="商品简介：" prop="storeInfo">
                <span class="spfont">{{ formValidate.storeInfo }}</span>
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="商品关键字：" prop="keyword">
                <span class="spfont">{{ formValidate.keyword }}</span>
              </el-form-item>
            </el-col>
            <el-col v-bind="grid2">
              <el-form-item label="商品分类：">
                <el-cascader
                  v-model="formValidate.categoryId"
                  :options="adminProductClassify"
                  :props="props1"
                  class="selWidth"
                  :show-all-levels="false"
                  :disabled="isDisabled"
                />
              </el-form-item>
            </el-col>
            <el-col v-bind="grid2">
              <el-form-item label="品牌：" prop="brandId">
                <el-select
                  class="selWidth"
                  filterable
                  v-model="formValidate.brandId"
                  :loading="loading"
                  remote
                  :disabled="isDisabled"
                  placeholder="请选择品牌"
                >
                  <el-option v-for="user in brandList" :key="user.id" :label="user.name" :value="user.id"> </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col v-bind="grid2">
              <el-form-item label="单位：" prop="unitName">
                <el-input v-model="formValidate.unitName" placeholder="请输入单位" :readonly="isDisabled" />
              </el-form-item>
            </el-col>
            <el-col v-bind="grid2">
              <el-form-item label="运费：" prop="postage">
                <el-input v-model="formValidate.postage" placeholder="请输入邮费" :readonly="isDisabled" />
              </el-form-item>
            </el-col>
            <el-col v-bind="grid2">
              <el-form-item label="商品封面图：">
                <div class="upLoadPicBox" @click="modalPicTap('1')" :disabled="isDisabled">
                  <div v-if="formValidate.image" class="pictrue"><img :src="$imageUrl(formValidate.image)" /></div>
                  <div v-else class="upLoad">
                    <i class="el-icon-camera cameraIconfont" />
                  </div>
                </div>
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="商品轮播图：">
                <div class="acea-row">
                  <div v-for="(item, index) in formValidate.sliderImages" :key="index" class="pictrue">
                    <img :src="item" />
                  </div>
                  <div v-if="formValidate.sliderImages.length < 10 && !isDisabled" class="upLoadPicBox">
                    <div class="upLoad">
                      <i class="el-icon-camera cameraIconfont" />
                    </div>
                  </div>
                </div>
              </el-form-item>
            </el-col>
            <el-col v-bind="grid2">
              <el-form-item label="商品规格：" props="specType">
                <span class="spfont">{{ formValidate.specType ? '多规格' : '单规格' }}</span>
              </el-form-item>
            </el-col>
            <el-col :xl="24" :lg="24" :md="24" :sm="24" :xs="24" class="mt10">
              <!-- 单规格表格-->
              <template v-if="formValidate.specType === false">
                <el-table :data="OneattrValue" border class="tabNumWidth" size="mini">
                  <el-table-column align="center" label="图片" width="60">
                    <template slot-scope="scope">
                      <div class="upLoadPicBox">
                        <div v-if="formValidate.image" class="pictrue tabPic"><img :src="$imageUrl(scope.row.image)" /></div>
                        <div v-else class="upLoad tabPic">
                          <i class="el-icon-camera cameraIconfont" />
                        </div>
                      </div>
                    </template>
                  </el-table-column>
                  <el-table-column
                    v-for="(item, iii) in attrValue"
                    :key="iii"
                    :label="formThead[iii].title"
                    align="center"
                  >
                    <template slot-scope="scope">
                      <span>{{ scope.row[iii] }}</span>
                    </template>
                  </el-table-column>
                </el-table>
              </template>
              <template v-if="formValidate.attr.length > 0 && formValidate.specType">
                <el-table :data="ManyAttrValue" border class="tabNumWidth" size="mini">
                  <template v-if="manyTabDate">
                    <el-table-column
                      v-for="(item, iii) in manyTabDate"
                      :key="iii"
                      align="center"
                      :label="manyTabTit[iii].title"
                    >
                      <template slot-scope="scope">
                        <span class="priceBox" v-text="scope.row[iii]" />
                      </template>
                    </el-table-column>
                  </template>
                  <el-table-column align="center" label="图片" width="60">
                    <template slot-scope="scope">
                      <div class="upLoadPicBox">
                        <div v-if="scope.row.image" class="pictrue tabPic"><img :src="$imageUrl(scope.row.image)" /></div>
                        <div v-else class="upLoad tabPic">
                          <i class="el-icon-camera cameraIconfont" />
                        </div>
                      </div>
                    </template>
                  </el-table-column>
                  <el-table-column
                    v-for="(item, iii) in attrValue"
                    :key="iii"
                    :label="formThead[iii].title"
                    align="center"
                  >
                    <template slot-scope="scope">
                      <span>{{ scope.row[iii] }}</span>
                    </template>
                  </el-table-column>
                </el-table>
              </template>
            </el-col>
          </el-row>
          <!-- 商品详情-->
          <el-row v-show="currentTab === '1' && !isDisabled">
            <el-col :span="24">
              <el-form-item label="商品详情：">
                <div class="contentPic" v-html="formValidate.content" />
                <!--<Tinymce v-model=".content"></Tinymce>-->
              </el-form-item>
            </el-col>
          </el-row>
          <el-row v-show="currentTab === '1' && isDisabled">
            <el-col :span="24">
              <el-form-item label="商品详情：">
                <span v-html="formValidate.content || '无'"></span>
              </el-form-item>
            </el-col>
          </el-row>
          <!-- 其他设置-->
          <el-row v-show="currentTab === '2'">
            <el-col :span="24">
              <el-col v-bind="grid2">
                <el-form-item label="保障服务：">
                  <el-select
                    v-if="formValidate.guaranteeIdsList.length"
                    v-model="formValidate.guaranteeIdsList"
                    placeholder="请选择保障服务"
                    multiple
                    class="selWidth"
                    :disabled="isDisabled"
                  >
                    <el-option
                      :value="item.id"
                      v-for="(item, index) in guaranteeList"
                      :key="index"
                      :label="item.name"
                    ></el-option>
                  </el-select>
                  <span>无</span>
                </el-form-item>
              </el-col>
              <el-col v-bind="grid">
                <el-form-item label="排序：">
                  <span class="spfont">{{ formValidate.sort }}</span>
                </el-form-item>
              </el-col>
            </el-col>
            <el-col :span="24">
              <el-form-item label="优惠券：" class="proCoupon">
                <div class="acea-row" style="margin-top: 8px">
                  <el-tag
                    v-for="(tag, index) in formValidate.couponList"
                    :key="index"
                    class="mr10 mb10"
                    :closable="!isDisabled"
                    :disable-transitions="false"
                  >
                    {{ tag.name }}
                  </el-tag>
                  <span v-if="formValidate.couponList.length === 0">无</span>
                </div>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </div>
    </div>
    <div v-if="isAtud" class="from-foot-btn btn-shadow">
      <el-form ref="ruleForm" :model="ruleForm" :rules="rules" label-width="80px" class="demo-ruleForm">
        <el-form-item label="审核状态" prop="auditStatus">
          <el-radio-group v-model="ruleForm.auditStatus">
            <el-radio label="success">通过</el-radio>
            <el-radio label="fail">拒绝</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="ruleForm.auditStatus === 'fail'" label="原因" prop="reason">
          <el-input v-model="ruleForm.reason" type="textarea" placeholder="请输入原因" />
        </el-form-item>
        <el-form-item>
          <el-button @click="close">取 消</el-button>
          <el-button type="primary" @click="onSubmit('ruleForm')">{{ loadingBtn ? '提交中 ...' : '确 定' }}</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script>
import Tinymce from '@/components/Tinymce/index';
import {
  productCouponListApi,
  productAuditApi,
  brandListApi,
  guaranteeListApi,
  categoryApi,
  productDetailApi,
  productUpdateApi,
} from '@/api/store';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
import { Debounce } from '@/utils/validate';
import { mapGetters } from 'vuex';
const defaultObj = {
  image: '',
  sliderImages: [],
  videoLink: '',
  sliderImage: '',
  storeName: '',
  storeInfo: '',
  keyword: '',
  cateIds: [], // 商品分类id
  couponList: [],
  cateId: null, // 商品分类id传值
  unitName: '',
  sort: 0,
  giveIntegral: 0,
  ficti: 0,
  isShow: false,
  attrValue: [
    {
      image: '',
      price: 0,
      cost: 0,
      otPrice: 0,
      stock: 0,
      weight: 0,
      volume: 0,
      productName: '',
      material: '',
      packQuantity: 0,
      capacity: '',
      origin: '',
      skuLadderPrice: '',
      size: '',
    },
  ],
  attr: [],
  selectRule: '',
  isSub: false,
  content: '',
  specType: false,
  id: undefined,
  couponIds: [],
  coupons: [],
  postage: '1',
  categoryId: '',
  guaranteeIds: '',
  guaranteeIdsList: [],
  brandId: '',
};
const objTitle = {
  price: {
    title: '售价',
  },
  cost: {
    title: '成本价',
  },
  otPrice: {
    title: '原价',
  },
  stock: {
    title: '库存',
  },
  weight: {
    title: '重量（KG）',
  },
  volume: {
    title: '体积(m³)',
  },
  productName: {
    title: '品名',
  },
  material: {
    title: '材质(成分)',
  },
  packQuantity: {
    title: '装箱数量',
  },
  capacity: {
    title: '容量',
  },
  origin: {
    title: '产地',
  },
  skuLadderPrice: {
    title: 'SKU(阶梯价格)',
  },
  size: {
    title: '尺寸',
  },
};
export default {
  name: 'ProductProductAdd',
  props: {
    isShow: {
      type: Boolean,
      default: true,
    },
    isAtud: {
      type: Boolean,
      default: false,
    },
    productId: {
      type: [Number, String],
      default: () => null,
    },
  },
  components: { Tinymce },
  data() {
    return {
      rules: {
        auditStatus: [{ required: true, message: '请选择审核状态', trigger: 'change' }],
        reason: [{ required: true, message: '请填写拒绝原因', trigger: 'blur' }],
      },
      isAppend: true,
      proId: 0,
      ruleForm: {
        reason: '',
        auditStatus: 'success',
        id: '',
      },
      direction: 'rtl',
      //dialogVisible: false,
      isDisabled: true,
      props2: {
        children: 'childList',
        label: 'name',
        value: 'id',
        multiple: true,
        emitPath: false,
      },
      props1: {
        children: 'childList',
        label: 'name',
        value: 'id',
        multiple: false,
        emitPath: false,
      },
      checkboxGroup: [],
      recommend: [
        { name: '可能喜欢', value: 'isGood', type: '5' },
        { name: '热卖商品', value: 'isHot', type: '2' },
        { name: '主打商品', value: 'isBest', type: '1' },
      ],
      tabs: [],
      fullscreenLoading: false,
      props: { multiple: true },
      active: 0,
      OneattrValue: [Object.assign({}, defaultObj.attrValue[0])], // 单规格
      ManyAttrValue: [Object.assign({}, defaultObj.attrValue[0])], // 多规格
      ruleList: [],
      merCateList: [], // 商户分类筛选
      shippingList: [], // 运费模板
      formThead: Object.assign({}, objTitle),
      formValidate: Object.assign({}, defaultObj),
      formDynamics: {
        ruleName: '',
        ruleValue: [],
      },
      tempData: {
        page: 1,
        limit: 9999,
      },
      manyTabTit: {},
      manyTabDate: {},
      grid2: {
        xl: 12,
        lg: 12,
        md: 12,
        sm: 24,
        xs: 24,
      },
      // 规格数据
      formDynamic: {
        attrsName: '',
        attrsVal: '',
      },
      isBtn: false,
      manyFormValidate: [],
      currentTab: '0',
      isChoice: '',
      grid: {
        xl: 8,
        lg: 8,
        md: 12,
        sm: 24,
        xs: 24,
      },
      ruleValidate: {
        storeName: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
        cateIds: [{ required: true, message: '请选择商品分类', trigger: 'change', type: 'array', min: '1' }],
        keyword: [{ required: true, message: '请输入商品关键字', trigger: 'blur' }],
        unitName: [{ required: true, message: '请输入单位', trigger: 'blur' }],
        storeInfo: [{ required: true, message: '请输入商品简介', trigger: 'blur' }],
        postage: [{ required: true, message: '请输入运费', trigger: 'change' }],
        image: [{ required: true, message: '请上传商品图', trigger: 'change' }],
        sliderImages: [{ required: true, message: '请上传商品轮播图', type: 'array', trigger: 'change' }],
        specType: [{ required: true, message: '请选择商品规格', trigger: 'change' }],
        brandId: [{ required: true, message: '请选择商品品牌', trigger: 'change' }],
      },
      attrInfo: {},
      tableFrom: {
        page: 1,
        limit: 9999,
        keywords: '',
      },
      tempRoute: {},
      keyNum: 0,
      isAttr: false,
      showAll: false,
      videoLink: '',
      guaranteeList: [],
      brandList: [],
      search: {
        limit: 10,
        page: 1,
        cid: '',
        brandName: '',
      },
      totalPage: 0,
      total: 0,
      loading: false,
      loadingBtn: false,
    };
  },
  computed: {
    ...mapGetters(['adminProductClassify', 'productBrand']),

    attrValue() {
      const obj = Object.assign({}, defaultObj.attrValue[0]);
      delete obj.image;
      return obj;
    },
    oneFormBatch() {
      const obj = [Object.assign({}, defaultObj.attrValue[0])];
      return obj;
    },
  },
  watch: {
    'formValidate.attr': {
      handler: function (val) {
        if (this.formValidate.specType && this.isAttr) this.watCh(val); //重要！！！
      },
      immediate: false,
      deep: true,
    },
  },
  created() {
    this.currentTab = '0';
    this.tempRoute = Object.assign({}, this.$route);
    if (this.$route.params.id && this.formValidate.specType) {
      this.$watch('formValidate.attr', this.watCh);
    }
    if (!this.adminProductClassify.length) this.$store.dispatch('product/getAdminProductClassify');
    // if(!this.productBrand.length)
    //   this.$store.dispatch('product/getMerProductBrand')
  },
  mounted() {
    this.getProductGuarantee();
    this.getbrandList();
    this.getInfo();
  },
  methods: {
    checkPermi,
    //审核取消
    close() {
      this.$emit('handleClose');
    },
    // 审核提交
    onSubmit(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.loadingBtn = true;
          this.ruleForm.id = this.productId;
          productAuditApi(this.ruleForm)
            .then((res) => {
              this.$message.success('操作成功');
              // this.dialogVisible = false;
              this.currentTab = '0';
              this.ruleForm.reason = '';
              this.$emit('subSuccess');
              this.loadingBtn = false;
            })
            .catch((res) => {
              this.loadingBtn = false;
            });
        } else {
          return false;
        }
      });
    },
    changeNodes(data) {
      if (data.length > 0) {
        for (var i = 0; i < data.length; i++) {
          if (!data[i].childList || data[i].childList.length < 1) {
            data[i].childList = undefined;
          } else {
            this.changeNodes(data[i].childList);
          }
        }
      }
      return data;
    },
    // 保障服务列表
    getProductGuarantee() {
      guaranteeListApi().then((res) => {
        this.guaranteeList = res;
      });
    },
    // 品牌列表
    getbrandList() {
      this.search.cid = this.formValidate.categoryId;
      brandListApi(this.search).then((res) => {
        this.brandList = res.list;
      });
    },
    watCh(val) {
      const tmp = {};
      const tmpTab = {};
      this.formValidate.attr.forEach((o, i) => {
        // tmp['value' + i] = { title: o.attrName }
        // tmpTab['value' + i] = ''
        tmp[o.attrName] = { title: o.attrName };
        tmpTab[o.attrName] = '';
      });
      this.ManyAttrValue = this.attrFormat(val);
      this.ManyAttrValue.forEach((val, index) => {
        const key = Object.values(val.attrValue).sort().join('/');
        if (this.attrInfo[key]) this.ManyAttrValue[index] = this.attrInfo[key];
      });
      this.attrInfo = [];
      this.ManyAttrValue.forEach((val) => {
        this.attrInfo[Object.values(val.attrValue).sort().join('/')] = val;
      });
      this.manyTabTit = tmp;
      this.manyTabDate = tmpTab;
      this.formThead = Object.assign({}, this.formThead, tmp);
    },
    attrFormat(arr) {
      let data = [];
      const res = [];
      return format(arr);
      function format(arr) {
        if (arr.length > 1) {
          arr.forEach((v, i) => {
            if (i === 0) data = arr[i]['attrValue'];
            const tmp = [];
            if (!data) return;
            data.forEach(function (vv) {
              arr[i + 1] &&
                arr[i + 1]['attrValue'] &&
                arr[i + 1]['attrValue'].forEach((g) => {
                  const rep2 = (i !== 0 ? '' : arr[i]['attrName'] + '_') + vv + '$&' + arr[i + 1]['attrName'] + '_' + g;
                  tmp.push(rep2);
                  if (i === arr.length - 2) {
                    const rep4 = {
                      image: '',
                      price: 0,
                      cost: 0,
                      otPrice: 0,
                      stock: 0,
                      weight: 0,
                      volume: 0,
                      productName: '',
                      material: '',
                      packQuantity: 0,
                      capacity: '',
                      origin: '',
                      skuLadderPrice: '',
                      size: '',
                    };
                    rep2.split('$&').forEach((h, k) => {
                      const rep3 = h.split('_');
                      if (!rep4['attrValue']) rep4['attrValue'] = {};
                      rep4['attrValue'][rep3[0]] = rep3.length > 1 ? rep3[1] : '';
                    });
                    for (let attrValueKey in rep4.attrValue) {
                      rep4[attrValueKey] = rep4.attrValue[attrValueKey];
                    }
                    res.push(rep4);
                  }
                });
            });
            data = tmp.length ? tmp : [];
          });
        } else {
          const dataArr = [];
          arr.forEach((v, k) => {
            v['attrValue'].forEach((vv, kk) => {
              dataArr[kk] = v['attrName'] + '_' + vv;
              res[kk] = {
                image: '',
                price: 0,
                cost: 0,
                otPrice: 0,
                stock: 0,
                weight: 0,
                volume: 0,
                productName: '',
                material: '',
                packQuantity: 0,
                capacity: '',
                origin: '',
                attrValue: { [v['attrName']]: vv },
              };
              // Object.values(res[kk].attrValue).forEach((v, i) => {
              //   res[kk]['value' + i] = v
              // })
              for (let attrValueKey in res[kk].attrValue) {
                res[kk][attrValueKey] = res[kk].attrValue[attrValueKey];
              }
            });
          });
          data.push(dataArr.join('$&'));
        }
        return res;
      }
    },
    // 详情
    getInfo() {
      this.loading = true;
      productDetailApi(this.productId)
        .then(async (res) => {
          // this.isAttr = true;
          let info = res;
          this.formValidate = {
            image: this.$selfUtil.setDomain(info.image),
            sliderImage: info.sliderImage,
            sliderImages: JSON.parse(info.sliderImage),
            storeName: info.storeName,
            storeInfo: info.storeInfo,
            keyword: info.keyword,
            cateIds: info.cateId.split(','), // 商品分类id
            cateId: info.cateId, // 商品分类id传值
            unitName: info.unitName,
            sort: info.sort,
            isShow: info.isShow,
            tempId: info.tempId,
            attr: info.attr,
            attrValue: info.attrValue,
            selectRule: info.selectRule,
            isSub: info.isSub,
            content: this.$selfUtil.replaceImgSrcHttps(info.content),
            specType: info.specType,
            id: info.id,
            giveIntegral: info.giveIntegral,
            ficti: info.ficti,
            coupons: info.coupons,
            couponIds: info.couponIds,
            postage: info.postage,
            brandId: info.brandId,
            categoryId: info.categoryId,
            guaranteeIds: info.guaranteeIds, //保障服务传值
            couponList: info.couponList || [],
            guaranteeIdsList: info.guaranteeIds ? info.guaranteeIds.split(',').map(Number) : [], //保障服务
          };
          let imgs = JSON.parse(info.sliderImage);
          let imgss = [];
          Object.keys(imgs).map((i) => {
            imgss.push(this.$selfUtil.setDomain(imgs[i]));
          });
          this.formValidate.sliderImages = [...imgss];
          if (this.getFileType(this.formValidate.sliderImages[0]) == 'video') {
            //如果返回数据轮播图的第一张是视频，就将其赋值给videoLink做渲染，同时将其在轮播图中删除
            this.$set(this.formValidate, 'videoLink', this.formValidate.sliderImages[0]);
            this.formValidate.sliderImages.splice(0, 1);
          }
          if (info.specType) {
            this.formValidate.attr = info.attr.map((item) => {
              return {
                attrName: item.attrName,
                attrValue: item.attrValues.split(','),
              };
            });
            this.ManyAttrValue = info.attrValue;
            this.ManyAttrValue.forEach((val) => {
              val.image = this.$selfUtil.setDomain(val.image);
              val.attrValue = JSON.parse(val.attrValue);
              this.attrInfo[Object.values(val.attrValue).sort().join('/')] = val;
            });
            /***多规格商品如果被删除过sku，优先展示api返回的数据,否则会有没有删除的错觉***/
            let manyAttr = this.attrFormat(this.formValidate.attr);
            if (manyAttr.length !== this.ManyAttrValue.length) {
              this.$set(this, 'showAll', true);
              this.isAttr = false;
            } else {
              this.isAttr = true;
            }
            /*******/
            const tmp = {};
            const tmpTab = {};
            this.formValidate.attr.forEach((o, i) => {
              // tmp['value' + i] = { title: o.attrName }
              // tmpTab['value' + i] = ''
              tmp[o.attrName] = { title: o.attrName };
              tmpTab[o.attrName] = '';
            });

            // 此处手动实现后台原本value0 value1的逻辑
            this.formValidate.attrValue.forEach((item) => {
              for (let attrValueKey in item.attrValue) {
                item[attrValueKey] = item.attrValue[attrValueKey];
              }
            });

            this.manyTabTit = tmp;
            this.manyTabDate = tmpTab;
            this.formThead = Object.assign({}, this.formThead, tmp);
          } else {
            this.OneattrValue = info.attrValue;
          }
          this.loading = false;
        })
        .catch((res) => {
          this.loading = false;
        });
    },
    // 表单验证
    validate(prop, status, error) {
      if (status === false) {
        this.$message.warning(error);
      }
    },
    zh_uploadFile() {
      if (this.videoLink) {
        this.$set(this.formValidate, 'videoLink', this.videoLink);
      }
    },
    getFileType(fileName) {
      // 后缀获取
      let suffix = '';
      // 获取类型结果
      let result = '';
      try {
        const flieArr = fileName.split('.');
        suffix = flieArr[flieArr.length - 1];
      } catch (err) {
        suffix = '';
      }
      // fileName无后缀返回 false
      if (!suffix) {
        return false;
      }
      suffix = suffix.toLocaleLowerCase();
      // 图片格式
      const imglist = ['png', 'jpg', 'jpeg', 'bmp', 'gif'];
      // 进行图片匹配
      result = imglist.find((item) => item === suffix);
      if (result) {
        return 'image';
      }
      // 匹配 视频
      const videolist = ['mp4', 'm2v', 'mkv', 'rmvb', 'wmv', 'avi', 'flv', 'mov', 'm4v'];
      result = videolist.find((item) => item === suffix);
      if (result) {
        return 'video';
      }
      // 其他 文件类型
      return 'other';
    },
  },
};
</script>
<style scoped lang="scss">
.spfont {
  color: #606266;
}
.from-foot-btn {
  width: 100%;
  padding: 20px;
}
.fix {
  z-index: 10;
  position: absolute;
  left: 0;
  bottom: 0px;
  padding-bottom: 10px;
  background: #fff;
}
.btn-shadow {
  box-shadow: 0px -2px 4px 0px rgba(0, 0, 0, 0.05);
}
.infoBox {
  ::v-deep.el-drawer__header {
    margin-bottom: 0;
    font-size: 20px;
  }
  ::v-deep .el-input.is-disabled .el-input__inner {
    background: none;
    cursor: none;
    color: #606266;
  }
  ::v-deep.el-icon-arrow-down,
  ::v-deep .el-icon-arrow-up {
    display: none;
  }
}
.divBox {
  ::v-deep .el-input__inner:hover,
  ::v-deep.el-input > input,
  ::v-deep.el-textarea > textarea {
    border: none;
    padding: 0;
  }
  ::v-deep .el-form-item {
    margin-bottom: 0;
  }
  ::v-deep.el-card__body {
    padding: 5px;
  }
}
.disLabel {
  ::v-deep .el-form-item__label {
    margin-left: 36px !important;
  }
}
.disLabelmoren {
  ::v-deep.el-form-item__label {
    margin-left: 120px !important;
  }
}
.priamry_border {
  border: 1px solid #1890ff;
  color: #1890ff;
}
.color-item {
  height: 30px;
  line-height: 30px;
  padding: 0 10px;
  color: #fff;
  margin-right: 10px;
}
.color-list .color-item.blue {
  background-color: #1e9fff;
}
.color-list .color-item.yellow {
  background-color: rgb(254, 185, 0);
}
.color-list .color-item.green {
  background-color: #009688;
}
.color-list .color-item.red {
  background-color: #ed4014;
}
.proCoupon {
  ::v-deepel-form-item__content {
    margin-top: 5px;
  }
}
.tabPic {
  width: 40px !important;
  height: 40px !important;
  img {
    width: 100%;
    height: 100%;
  }
}
.noLeft {
  ::v-deepel-form-item__content {
    margin-left: 0 !important;
  }
}
/*.tabNumWidth{*/
/*::v-deepel-input-number--medium{*/
/*width: 121px !important;*/
/*}*/
/*::v-deepel-input-number__increase{*/
/*width: 20px !important;*/
/*font-size: 12px !important;*/
/*}*/
/*::v-deepel-input-number__decrease{*/
/*width: 20px !important;*/
/*font-size: 12px !important;*/
/*}*/
/*::v-deepel-input-number--medium .el-input__inner {*/
/*padding-left: 25px !important;*/
/*padding-right: 25px !important;*/
/*}*/
/*::v-deep thead{*/
/*line-height: normal !important;*/
/*}*/
/*::v-deep .el-table .cell{*/
/*line-height: normal !important;*/
/*}*/
/*}*/
.selWidth {
  width: 100%;
}
.selWidthd {
  width: 100px;
}
.button-new-tag {
  height: 28px;
  line-height: 26px;
  padding-top: 0;
  padding-bottom: 0;
}
.input-new-tag {
  width: 90px;
  margin-left: 10px;
  vertical-align: bottom;
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
.labeltop {
  ::v-deepel-form-item__label {
    float: none !important;
    display: inline-block !important;
    width: auto !important;
  }
}
.iview-video-style {
  width: 300px;
  height: 180px;
  border-radius: 10px;
  background-color: #707070;
  margin: 0 120px 20px;
  position: relative;
  overflow: hidden;
}

.iview-video-style .iconv {
  color: #fff;
  line-height: 180px;
  width: 50px;
  height: 50px;
  display: inherit;
  font-size: 26px;
  position: absolute;
  top: -74px;
  left: 50%;
  margin-left: -25px;
}

.iview-video-style .mark {
  position: absolute;
  width: 100%;
  height: 30px;
  top: 0;
  background-color: rgba(0, 0, 0, 0.5);
  text-align: center;
}
</style>
