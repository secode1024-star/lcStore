<template>
  <div class="Box">
    <el-card>
      <div class="line-ht">
        生成的商品默认是没有上架的，请手动上架商品！
        <!-- <span v-if="copyConfig.copyType && copyConfig.copyType==1">您当前剩余{{copyConfig.copyNum}}条采集次数，
          <router-link :to="{path:'/operation/systemSms/pay?type=copy'}">
            <span style="color:#1890ff;">增加采集次数</span>
          </router-link>
        </span> -->
      </div>
    </el-card>
    <el-form
      class="formValidate mt20"
      ref="formValidate"
      :model="formValidate"
      :rules="ruleInline"
      label-width="120px"
      @submit.native.prevent
      v-loading="loading"
    >
      <el-form-item>
        <el-radio-group v-model="form">
          <el-radio :label="1">淘宝</el-radio>
          <el-radio :label="2">京东</el-radio>
          <el-radio :label="3">苏宁</el-radio>
          <el-radio :label="4">拼多多</el-radio>
          <el-radio :label="5">天猫</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-row :gutter="24">
        <el-col :span="24">
          <el-form-item label="链接地址：">
            <el-input v-model="url" placeholder="请输入链接地址" class="selWidth" size="small">
              <el-button
                slot="append"
                icon="el-icon-search"
                @click="add"
                size="small"
                v-hasPermi="['merchant:product:import:product']"
              />
            </el-input>
          </el-form-item>
        </el-col>
        <el-col v-if="formValidate">
          <el-col :span="24">
            <el-form-item label="商品名称：" prop="storeName">
              <el-input v-model="formValidate.storeName" maxlength="249" placeholder="请输入商品名称"></el-input>
            </el-form-item>
          </el-col>
          <el-col v-bind="grid">
            <el-form-item label="商户商品分类：" prop="cateIds">
              <el-cascader
                v-model="formValidate.cateIds"
                :options="merProductClassify"
                :props="props2"
                clearable
                class="selWidth"
                :show-all-levels="false"
                :disabled="isDisabled"
              />
            </el-form-item>
          </el-col>
          <el-col v-bind="grid">
            <el-form-item label="平台商品分类：" prop="categoryId">
              <el-cascader
                @change="onChangeCategory"
                v-model="formValidate.categoryId"
                :options="productClassify"
                :props="props1"
                filterable
                clearable
                class="selWidth"
                :show-all-levels="false"
                :disabled="isDisabled"
              />
            </el-form-item>
          </el-col>
          <el-col v-bind="grid">
            <el-form-item label="品牌：" prop="brandId">
              <el-select
                class="selWidth"
                clearable
                filterable
                v-model="formValidate.brandId"
                v-selectLoadMore="selectLoadMore"
                :loading="loading"
                remote
                :disabled="isDisabled"
                :remote-method="remoteMethod"
                placeholder="请选择品牌"
              >
                <el-option v-for="user in brandList" :key="user.id" :label="user.name" :value="user.id"> </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col v-bind="grid">
            <el-form-item label="保障服务：">
              <el-select
                v-model="formValidate.guaranteeIdsList"
                placeholder="请选择保障服务"
                clearable
                filterable
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
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="商品简介：" prop="storeInfo">
              <el-input
                v-model="formValidate.storeInfo"
                maxlength="250"
                type="textarea"
                :rows="3"
                placeholder="请输入商品简介"
              ></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="商品关键字：" prop="keyword">
              <el-input v-model="formValidate.keyword" placeholder="请输入商品关键字"></el-input>
            </el-form-item>
          </el-col>
          <el-col v-bind="grid">
            <el-form-item label="单位：" prop="unitName">
              <el-input v-model="formValidate.unitName" placeholder="请输入单位" class="selWidth"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="商品封面图：" prop="image">
              <div class="upLoadPicBox" @click="modalPicTap('1')">
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
                <div
                  v-for="(item, index) in formValidate.sliderImages"
                  :key="index"
                  class="lunBox mr5"
                  draggable="false"
                  @dragstart="handleDragStart($event, item)"
                  @dragover.prevent="handleDragOver($event, item)"
                  @dragenter="handleDragEnter($event, item)"
                  @dragend="handleDragEnd($event, item)"
                >
                  <div class="pictrue"><img :src="item" /></div>
                  <el-button-group>
                    <el-button size="mini" @click.native="checked(item, index)">主图</el-button>
                    <el-button size="mini" @click.native="handleRemove(index)">移除</el-button>
                  </el-button-group>
                </div>
              </div>
            </el-form-item>
          </el-col>
          <el-col :xs="18" :sm="18" :md="18" :lg="12" :xl="12">
            <el-form-item label="运费" prop="postage">
              <el-input-number
                v-model="formValidate.postage"
                placeholder="请输入邮费"
                :min="0"
                :max="99999"
                :precision="1"
                :disabled="isDisabled"
              />
            </el-form-item>
          </el-col>
          <!--批量设置-->
          <el-col v-if="formValidate.specType || formValidate.attr.length" :span="24" class="noForm">
            <el-form-item label="批量设置：" class="labeltop">
              <el-table :data="oneFormBatch" border class="tabNumWidth" size="mini">
                <el-table-column align="center" label="图片" min-width="80">
                  <template slot-scope="scope">
                    <div class="upLoadPicBox" @click="modalPicTap('1', 'pi')">
                      <div v-if="scope.row.image" class="pictrue pictrueTab">
                        <img :src="$imageUrl(scope.row.image)" />
                      </div>
                      <div v-else class="upLoad pictrueTab">
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
                  min-width="120"
                >
                  <template slot-scope="scope">
                    <el-input
                      v-model="scope.row[iii]"
                      :type="formThead[iii].title === '商品编号' ? 'text' : 'number'"
                      :min="0"
                      class="priceBox"
                      @keyup.native="keyupEvent(iii, scope.row[iii], scope.$index, 1)"
                    />
                  </template>
                </el-table-column>
                <el-table-column align="center" label="操作" min-width="80">
                  <template>
                    <el-button type="text" class="submission" @click="batchAdd">批量添加</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="商品规格：" props="spec_type" label-for="spec_type">
              <el-table :data="formValidate.attrValue" border class="tabNumWidth" size="mini">
                <template v-if="manyTabDate">
                  <el-table-column
                    v-for="(item, iii) in manyTabDate"
                    :key="iii"
                    align="center"
                    :label="manyTabTit[iii].title"
                    min-width="80"
                  >
                    <template slot-scope="scope">
                      <span class="priceBox" v-text="scope.row[iii]" />
                    </template>
                  </el-table-column>
                </template>
                <el-table-column align="center" label="图片" min-width="80">
                  <template slot-scope="scope">
                    <el-form-item
                      :rules="[{ required: true, message: '请上传图片', trigger: 'change' }]"
                      :prop="'attrValue.' + scope.$index + '.image'"
                    >
                      <div class="upLoadPicBox" @click="modalPicTap('1', 'duo', scope.$index)">
                        <div v-if="scope.row.image" class="pictrue pictrueTab">
                          <img :src="$imageUrl(scope.row.image)" />
                        </div>
                        <div v-else class="upLoad pictrueTab">
                          <i class="el-icon-camera cameraIconfont" />
                        </div>
                      </div>
                    </el-form-item>
                  </template>
                </el-table-column>
                <el-table-column
                  v-for="(item, iii) in attrValue"
                  :key="iii"
                  :label="formThead[iii].title"
                  align="center"
                  min-width="120"
                >
                  <template slot-scope="scope">
                    <el-form-item
                      :rules="[{ required: true, message: '请输入' + formThead[iii].title, trigger: 'blur' }]"
                      :prop="formThead[iii].title !== '商品编号' ? 'attrValue.' + scope.$index + '.' + iii : ''"
                    >
                      <el-input
                        v-model="scope.row[iii]"
                        :type="formThead[iii].title === '商品编号' ? 'text' : 'number'"
                        @keyup.native="keyupEvent(iii, scope.row[iii], scope.$index, 2)"
                        class="priceBox"
                      />
                    </el-form-item>
                    <!--<el-input v-model="scope.row[iii]" :type="formThead[iii].title==='商品编号'?'text':'number'"-->
                    <!--class="priceBox"/>-->
                  </template>
                </el-table-column>
                <el-table-column align="center" label="操作" min-width="80">
                  <template slot-scope="scope">
                    <el-button type="text" class="submission" @click="delAttrTable(scope.$index)">删除</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="商品详情：">
              <Tinymce v-model="formValidate.content"></Tinymce>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <template>
              <el-row :gutter="24">
                <el-col :span="24">
                  <template>
                    <el-row :gutter="24">
                      <el-col :span="8">
                        <el-form-item label="排序：">
                          <el-input-number
                            v-model="formValidate.sort"
                            :min="1"
                            :max="9999"
                            placeholder="请输入排序"
                            @keyup.native="proving1"
                            :disabled="isDisabled"
                          />
                        </el-form-item>
                      </el-col>
                    </el-row>
                  </template>
                </el-col>
              </el-row>
            </template>
          </el-col>

          <el-col :span="24">
            <el-form-item>
              <el-button
                type="primary"
                :loading="modal_loading"
                class="submission"
                @click="handleSubmit('formValidate')"
                >提交
              </el-button>
            </el-form-item>
          </el-col>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
import {
  copyProductApi,
  crawlFromApi,
  treeListApi,
  crawlSaveApi,
  importProductApi,
  productCreateApi,
  copyConfigApi,
  productGuaranteeApi,
  brandListApi,
} from '@/api/store';
import Tinymce from '@/components/Tinymce/index';
import { Debounce } from '@/utils/validate';
import { mapGetters } from 'vuex';
const defaultObj = [
  {
    image: '',
    price: null,
    stock: null,
    barCode: '',
    weight: 0,
    volume: 0,
    capacity: '',
    origin: '',
  },
];
const objTitle = {
  price: {
    title: '售价',
  },
  stock: {
    title: '库存',
  },
  barCode: {
    title: '商品编号',
  },
  weight: {
    title: '重量（KG）',
  },
  volume: {
    title: '体积(m³)',
  },
  capacity: {
    title: '容量',
  },
  origin: {
    title: '产地',
  },
};
export default {
  name: 'taoBao',
  directives: {
    // 计算是否滚动到最下面
    selectLoadMore: {
      bind(el, binding) {
        // 获取element-ui定义好的scroll盒子
        const SELECTWRAP_DOM = el.querySelector('.el-select-dropdown .el-select-dropdown__wrap');
        SELECTWRAP_DOM.addEventListener('scroll', function () {
          if (this.scrollHeight - this.scrollTop < this.clientHeight + 1) {
            binding.value();
          }
        });
      },
    },
  },
  components: { Tinymce },
  data() {
    return {
      loading: false,
      formThead: Object.assign({}, objTitle),
      manyTabTit: {},
      manyTabDate: {},
      formValidate: null,
      form: 1,
      props2: {
        children: 'childList',
        label: 'name',
        value: 'id',
        multiple: true,
        emitPath: false,
        checkStrictly: true,
      },
      props1: {
        children: 'childList',
        label: 'name',
        value: 'id',
        multiple: false,
        emitPath: false,
      },
      checkboxGroup: [], //
      recommend: [],
      modal_loading: false,
      ManyAttrValue: [Object.assign({}, defaultObj[0])], // 多规格
      imgList: [],
      tempData: {
        page: 1,
        limit: 9999,
      },
      // shippingList: [],
      images: '',
      url: '',
      modalPic: false,
      isChoice: '',
      isDisabled: false,
      ruleInline: {
        storeName: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
        categoryId: [{ required: true, message: '请选择平台商品分类', trigger: 'change' }],
        cateIds: [{ required: true, message: '请选择商品分类', trigger: 'change', type: 'array', min: '1' }],
        unitName: [{ required: true, message: '请输入单位', trigger: 'blur' }],
        tempId: [{ required: true, message: '请选择运费模板', trigger: 'change', type: 'number' }],
        storeInfo: [{ required: true, message: '请输入商品简介', trigger: 'blur' }],
        postage: [{ required: true, message: '请输入运费', trigger: 'change' }],
        image: [{ required: true, message: '请上传商品图', trigger: 'change' }],
        sliderImages: [{ required: true, message: '请上传商品轮播图', type: 'array', trigger: 'change' }],
        keyword: [{ required: true, message: '请输入商品关键字', trigger: 'blur' }],
        attrValue: [{ required: true, message: '请上传商品轮播图', type: 'array', trigger: 'change' }],
        specType: [{ required: true, message: '请选择商品规格', trigger: 'change' }],
        brandId: [{ required: true, message: '请选择商品品牌', trigger: 'change' }],
      },
      grid: {
        xl: 12,
        lg: 12,
        md: 12,
        sm: 24,
        xs: 24,
      },
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
      loadingBtn: false,
      productClassify: [], //平台商品分类
    };
  },
  created() {},
  computed: {
    ...mapGetters(['adminProductClassify', 'merProductClassify', 'productBrand']),
    attrValue() {
      const obj = Object.assign({}, defaultObj[0]);
      delete obj.image;
      return obj;
    },
    oneFormBatch() {
      const obj = [Object.assign({}, defaultObj[0])];
      delete obj[0].barCode;
      return obj;
    },
  },
  watch: {
    'formValidate.attr': {
      handler: function (val) {
        if (val) this.watCh(val);
      },
      immediate: false,
      deep: true,
    },
  },
  mounted() {
    // this.$store.dispatch('product/getAdminProductClassify')
    if (!this.adminProductClassify.length) this.$store.dispatch('product/getAdminProductClassify');
    if (!this.merProductClassify.length) this.$store.dispatch('product/getMerProductClassify');
    if (!this.productBrand.length) this.$store.dispatch('product/getMerProductBrand');
    this.getProductGuarantee();
    if (this.$route.params.id) {
      this.setTagsViewTitle();
      this.getInfo();
    }
    this.productClassify = this.addDisabled(this.adminProductClassify);
  },
  methods: {
    //限制平台商品分类只能选择第三级
    addDisabled(dropdownList) {
      const list = [];
      try {
        dropdownList.forEach((e, index) => {
          let e_new = {
            id: e.id,
            name: e.name,
            level: e.level,
            pid: e.pid,
            isShow: e.isShow,
          };
          if (!e.childList && (e.level === 1 || e.level === 2)) {
            e_new = { ...e_new, disabled: true };
          }
          if (e.childList) {
            const childList = this.addDisabled(e.childList);
            e_new = { ...e_new, childList: childList };
          }
          list.push(e_new);
        });
      } catch (error) {
        console.log(error);
        return [];
      }
      return list;
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
      productGuaranteeApi().then((res) => {
        this.guaranteeList = res;
      });
    },

    onChangeCategory() {
      this.formValidate.brandId = '';
      this.getbrandList();
    },
    // 下拉加载更多
    selectLoadMore() {
      this.search.limit = this.search.limit + 1;
      if (this.search.limit > this.totalPage) return;
      this.getbrandList(); // 请求接口
    },
    // 远程搜索
    remoteMethod(query) {
      this.loading = true;
      this.search.keywords = query;
      this.search.limit = 1;
      this.brandList = [];
      setTimeout(() => {
        this.loading = false;
        this.getbrandList(); // 请求接口
      }, 200);
    },
    // 品牌列表
    getbrandList() {
      this.search.cid = this.formValidate.categoryId;
      brandListApi(this.search).then((res) => {
        if (!res.list.length) {
          this.$message.warning('此分类下面无品牌，请联系管理员添加此分类下的品牌！');
          this.brandList = [{ name: '此分类下面无品牌，请联系管理员添加此分类下的品牌！', id: undefined }];
        } else {
          this.brandList = res.list;
        }
      });
    },
    keyupEvent(key, val, index, num) {
      var re = /^\D*([0-9]\d*\.?\d{0,2})?.*$/;
      switch (num) {
        case 1:
          if (val <= 0) {
            this.oneFormBatch[index][key] = 0.01;
          } else {
            this.oneFormBatch[index][key] =
              key === 'stock'
                ? parseInt(val)
                : this.$set(this.oneFormBatch[index], key, parseFloat(val.replace(re, '$1')));
          }
          break;
        default:
          if (val <= 0) {
            this.formValidate.attrValue[index][key] = 0.01;
          } else {
            this.formValidate.attrValue[index][key] =
              key === 'stock'
                ? parseInt(val)
                : this.$set(this.formValidate.attrValue[index], key, parseFloat(val.replace(re, '$1')));
          }
          break;
      }
    },
    // 删除表格中的属性
    delAttrTable(index) {
      this.formValidate.attrValue.splice(index, 1);
    },
    // 批量添加
    batchAdd() {
      // if (!this.oneFormBatch[0].pic || !this.oneFormBatch[0].price || !this.oneFormBatch[0].cost || !this.oneFormBatch[0].ot_price ||
      //     !this.oneFormBatch[0].stock || !this.oneFormBatch[0].bar_code) return this.$Message.warning('请填写完整的批量设置内容！');
      for (const val of this.formValidate.attrValue) {
        this.$set(val, 'image', this.oneFormBatch[0].image);
        this.$set(val, 'price', this.oneFormBatch[0].price);
        this.$set(val, 'cost', this.oneFormBatch[0].cost);
        this.$set(val, 'otPrice', this.oneFormBatch[0].otPrice);
        this.$set(val, 'stock', this.oneFormBatch[0].stock);
        this.$set(val, 'barCode', this.oneFormBatch[0].barCode);
        this.$set(val, 'weight', this.oneFormBatch[0].weight);
        this.$set(val, 'volume', this.oneFormBatch[0].volume);
      }
    },
    watCh(val) {
      const tmp = {};
      const tmpTab = {};
      this.formValidate.attr.forEach((o, i) => {
        // tmp['value' + i] = {title: o.attrName}
        // tmpTab['value' + i] = ''
        tmp[o.attrName] = { title: o.attrName };
        tmpTab[o.attrName] = '';
      });
      this.formValidate.attrValue = this.attrFormat(val);
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
            data.forEach(function (vv) {
              arr[i + 1] &&
                arr[i + 1]['attrValue'] &&
                arr[i + 1]['attrValue'].forEach((g) => {
                  const rep2 = (i !== 0 ? '' : arr[i]['attrName'] + '_') + vv + '$&' + arr[i + 1]['attrName'] + '_' + g;
                  tmp.push(rep2);
                  if (i === arr.length - 2) {
                    const rep4 = {
                      image: '',
                      price: 0.01,
                      cost: 0.01,
                      otPrice: 0.01,
                      stock: 0,
                      barCode: '',
                      weight: 0,
                      volume: 0,
                      brokerage: 0,
                      brokerage_two: 0,
                    };
                    rep2.split('$&').forEach((h, k) => {
                      const rep3 = h.split('_');
                      if (!rep4['attrValue']) rep4['attrValue'] = {};
                      rep4['attrValue'][rep3[0]] = rep3.length > 1 ? rep3[1] : '';
                    });
                    // Object.values(rep4.attrValue).forEach((v, i) => {
                    //   rep4['value' + i] = v
                    // })
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
                price: 0.01,
                cost: 0.01,
                otPrice: 0.01,
                stock: 0,
                barCode: '',
                weight: 0,
                volume: 0,
                brokerage: 0,
                brokerage_two: 0,
                attrValue: { [v['attrName']]: vv },
              };
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
    // 删除图片
    handleRemove(i) {
      this.formValidate.sliderImages.splice(i, 1);
      this.$forceUpdate();
    },
    // 选择主图
    checked(item, index) {
      this.formValidate.image = item;
    },
    // 生成表单
    add() {
      if (this.url) {
        // var reg = /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/;
        // if (!reg.test(this.soure_link)) {
        //   return this.$message.warning('请输入以http开头的地址！');
        // }
        this.loading = true;
        importProductApi({ url: this.url, form: this.form })
          .then((res) => {
            this.formValidate = {
              image: this.$selfUtil.setDomain(res.image),
              sliderImage: res.sliderImage,
              storeName: res.storeName,
              storeInfo: res.storeInfo,
              keyword: res.keyword,
              cateIds: res.cateId ? res.cateId.split(',') : [], // 商品分类id
              cateId: res.cateId, // 商品分类id传值
              unitName: res.unitName,
              sort: 0,
              isShow: 0,
              tempId: res.tempId,
              attrValue: res.attrValue,
              attr: res.attr || [],
              selectRule: res.selectRule,
              isSub: false,
              content: this.$selfUtil.replaceImgSrcHttps(res.content),
              specType: res.attr.length ? true : false,
              id: 0,
              postage: res.postage ? res.postage : 1,
              brandId: '',
              categoryId: 0,
              guaranteeIds: '', //保障服务传值
              guaranteeIdsList: [], //保障服务
            };
            if (this.formValidate.categoryId > 0) this.getbrandList();
            let imgs = JSON.parse(res.sliderImage);
            let imgss = [];
            Object.keys(imgs).map((i) => {
              imgss.push(this.$selfUtil.setDomain(imgs[i]));
            });
            this.formValidate.sliderImages = [...imgss];
            if (this.formValidate.attr.length) {
              this.oneFormBatch[0].image = this.$selfUtil.setDomain(res.image);
              for (var i = 0; i < this.formValidate.attr.length; i++) {
                this.formValidate.attr[i].attrValue = JSON.parse(this.formValidate.attr[i].attrValues);
              }
            }
            this.loading = false;
          })
          .catch(() => {
            this.formValidate = null;
            this.loading = false;
          });
      } else {
        this.$message.warning('请输入链接地址！');
      }
    },
    // 提交
    handleSubmit: Debounce(function (name) {
      let pram = JSON.parse(JSON.stringify(this.formValidate));
      pram.attr.forEach((item) => {
        item.attrValues = item.attrValue.join(',');
      });
      pram.cateId = pram.cateIds.join(',');
      pram.sliderImage = JSON.stringify(pram.sliderImages);
      pram.guaranteeIds = this.formValidate.guaranteeIdsList.join(',');
      for (var i = 0; i < pram.attrValue.length; i++) {
        this.$set(pram.attrValue[i], 'id', 0);
        this.$set(pram.attrValue[i], 'productId', 0);
        this.$set(pram.attrValue[i], 'attrValue', JSON.stringify(pram.attrValue[i].attrValue)); //
        delete pram.attrValue[i].value0;
      }
      // pram.attrValue.forEach((itemData) => {
      //   itemData.attrValue = JSON.stringify(itemData.attrValue);
      // });
      this.$refs[name].validate((valid) => {
        if (valid) {
          this.modal_loading = true;
          productCreateApi(pram)
            .then(async (res) => {
              this.$message.success('新增成功');
              this.$emit('handleCloseMod', false);
              this.modal_loading = false;
            })
            .catch(() => {
              this.modal_loading = false;
            });
        } else {
          if (!pram.storeName || !pram.cateId || !pram.keyword || !pram.unitName || !pram.image) {
            this.$message.warning('请填写完整商品信息！');
          }
        }
      });
    }),
    // 点击商品图
    modalPicTap(tit, num, i) {
      const _this = this;
      this.$modalUpload(
        function (img) {
          if (tit === '1' && !num) {
            _this.formValidate.image = img[0].sattDir;
            _this.OneattrValue[0].image = img[0].sattDir;
          }
          if (tit === '2' && !num) {
            if (img.length > 10) return this.$message.warning('最多选择10张图片！');
            if (img.length + _this.formValidate.sliderImages.length > 10)
              return this.$message.warning('最多选择10张图片！');
            img.map((item) => {
              _this.formValidate.sliderImages.push(item.sattDir);
            });
          }
          if (tit === '1' && num === 'dan') {
            _this.OneattrValue[0].image = img[0].sattDir;
          }
          if (tit === '1' && num === 'duo') {
            _this.formValidate.attrValue[i].image = img[0].sattDir;
          }
          if (tit === '1' && num === 'pi') {
            _this.oneFormBatch[0].image = img[0].sattDir;
          }
        },
        tit,
        'store',
      );
    },
    handleDragStart(e, item) {
      this.dragging = item;
    },
    handleDragEnd(e, item) {
      this.dragging = null;
    },
    // 首先把div变成可以放置的元素，即重写dragenter/dragover
    handleDragOver(e) {
      // e.dataTransfer.dropEffect="move";//在dragenter中针对放置目标来设置!
      e.dataTransfer.dropEffect = 'move';
    },
    handleDragEnter(e, item) {
      // 为需要移动的元素设置dragstart事件
      e.dataTransfer.effectAllowed = 'move';
      if (item === this.dragging) {
        return;
      }
      const newItems = [...this.formValidate.slider_image];
      const src = newItems.indexOf(this.dragging);
      const dst = newItems.indexOf(item);
      newItems.splice(dst, 0, ...newItems.splice(src, 1));
      this.formValidate.slider_image = newItems;
    },
  },
};
</script>

<style scoped lang="scss">
.formValidate {
  ::v-deep .el-form-item__error {
    position: static !important;
  }
}
.selWidth {
  width: 100%;
}

.line-ht {
  line-height: 28px;
}

.lunBox {
  display: flex;
  flex-direction: column;
  border: 1px solid #0bb20c;
}

.pictrueBox {
  display: inline-block;
}

.pictrue {
  width: 111px;
  height: 111px;
  border: 1px dotted rgba(0, 0, 0, 0.1);
  display: inline-block;
  position: relative;
  cursor: pointer;
  img {
    width: 100%;
    height: 100%;
  }
}

.pictrueTab {
  width: 40px !important;
  height: 40px !important;
}

.upLoad {
  width: 86px;
  height: 86px;
  border: 1px dotted rgba(0, 0, 0, 0.1);
  border-radius: 4px;
  background: rgba(0, 0, 0, 0.02);
  cursor: pointer;
}

.ft {
  color: red;
}
</style>
