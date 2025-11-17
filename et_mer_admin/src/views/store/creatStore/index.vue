<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <el-steps :active="currentTab" align-center finish-status="success">
          <el-step title="商品信息" />
          <el-step title="商品详情" />
          <el-step title="其他设置" />
        </el-steps>
      </div>
      <el-form
        ref="formValidate"
        v-loading="fullscreenLoading"
        class="formValidate mt20"
        :rules="ruleValidate"
        :model="formValidate"
        label-width="120px"
        @submit.native.prevent
      >
        <el-row v-show="currentTab === 0" :gutter="24">
          <!-- 商品信息-->
          <el-col v-bind="grid2">
            <el-form-item label="商品名称：" prop="storeName">
              <el-input
                v-model="formValidate.storeName"
                maxlength="249"
                placeholder="请输入商品名称"
                :disabled="isDisabled"
              />
            </el-form-item>
          </el-col>
          <el-col v-bind="grid2">
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
          <el-col v-bind="grid2">
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
          <el-col v-bind="grid2">
            <el-form-item label="品牌：" prop="brandName">
              <el-input
                class="selWidth"
                v-model="formValidate.brandName"
                :disabled="isDisabled"
                placeholder="请输入品牌名称（非必填）"
                clearable
              />
            </el-form-item>
          </el-col>
          <el-col v-bind="grid2">
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
          <el-col v-bind="grid2">
            <el-form-item label="商品关键字：" prop="keyword">
              <el-input v-model="formValidate.keyword" placeholder="请输入商品关键字" :disabled="isDisabled" />
            </el-form-item>
          </el-col>
          <el-col v-bind="grid2">
            <el-form-item label="单位：" prop="unitName">
              <el-input v-model="formValidate.unitName" placeholder="请输入单位" :disabled="isDisabled" />
            </el-form-item>
          </el-col>
          <el-col v-bind="grid2">
            <el-form-item label="商品简介：" prop="storeInfo">
              <el-input
                v-model="formValidate.storeInfo"
                type="textarea"
                maxlength="250"
                :rows="3"
                placeholder="请输入商品简介"
                :disabled="isDisabled"
              />
            </el-form-item>
          </el-col>
          <el-col v-bind="grid2">
            <el-form-item label="商品封面图：" prop="image">
              <div class="upLoadPicBox acea-row" @click="modalPicTap('1')" :disabled="isDisabled">
                <div v-if="formValidate.image" class="pictrue"><img :src="$imageUrl(formValidate.image)" /></div>
                <div v-else class="upLoad">
                  <i class="el-icon-camera cameraIconfont" />
                </div>
                <span>请上传小于500kb的图片</span>
              </div>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="商品轮播图：" prop="sliderImages">
              <div class="acea-row">
                <div
                  v-for="(item, index) in formValidate.sliderImages"
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
                <div
                  v-if="formValidate.sliderImages.length < 10 && !isDisabled"
                  class="upLoadPicBox"
                  @click="modalPicTap('2')"
                >
                  <div class="upLoad">
                    <i class="el-icon-camera cameraIconfont" />
                  </div>
                </div>
              </div>
            </el-form-item>
          </el-col>
          <!-- 运费字段隐藏，但保留默认值1 -->
          <el-col :xs="18" :sm="18" :md="18" :lg="12" :xl="12" style="display: none;">
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
          <el-col :span="24">
            <el-form-item label="商品规格：" props="specType">
              <el-radio-group
                v-model="formValidate.specType"
                @change="onChangeSpec(formValidate.specType)"
                :disabled="isDisabled"
              >
                <el-radio :label="false" class="radio">单规格</el-radio>
                <el-radio :label="true">多规格</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <!-- 多规格添加-->
          <el-col v-if="formValidate.specType && !isDisabled" :span="24" class="noForm">
            <el-form-item label="选择规格：" prop="">
              <div class="acea-row">
                <el-select v-model="formValidate.selectRule">
                  <el-option v-for="item in ruleList" :key="item.id" :label="item.ruleName" :value="item.id" />
                </el-select>
                <el-button type="primary" class="mr20" @click="confirm">确认</el-button>
                <el-button class="mr15" @click="addRule">添加规格</el-button>
              </div>
            </el-form-item>
            <el-form-item>
              <div v-for="(item, index) in formValidate.attr" :key="index">
                <div class="acea-row row-middle">
                  <span class="mr5">{{ item.attrName }}</span
                  ><i class="el-icon-circle-close" @click="handleRemoveAttr(index)" />
                </div>
                <div class="rulesBox">
                  <el-tag
                    v-for="(j, indexn) in item.attrValue"
                    :key="indexn"
                    closable
                    size="medium"
                    :disable-transitions="false"
                    class="mb5 mr10"
                    @close="handleClose(item.attrValue, indexn)"
                  >
                    {{ j }}
                  </el-tag>
                  <el-input
                    v-if="item.inputVisible"
                    ref="saveTagInput"
                    v-model="item.attrValue.attrsVal"
                    class="input-new-tag"
                    size="small"
                    @keyup.enter.native="createAttr(item.attrValue.attrsVal, index)"
                    @blur="createAttr(item.attrValue.attrsVal, index)"
                  />
                  <el-button v-else class="button-new-tag" size="small" @click="showInput(item)">+ 添加</el-button>
                </div>
              </div>
            </el-form-item>
            <el-row>
              <el-col :xl="8" :lg="8" :md="12" :sm="24" :xs="24">
                <el-form-item label="规格：">
                  <el-input v-model="formDynamic.attrsName" placeholder="请输入规格" />
                </el-form-item>
              </el-col>
              <el-col :xl="8" :lg="8" :md="12" :sm="24" :xs="24">
                <el-form-item label="规格值：">
                  <el-input v-model="formDynamic.attrsVal" placeholder="请输入规格值" />
                </el-form-item>
              </el-col>
              <el-col :xl="8" :lg="8" :md="12" :sm="24" :xs="24">
                <el-form-item>
                  <el-button type="primary" @click="createAttrName">确定</el-button>
                  <el-button @click="offAttrName">取消</el-button>
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item v-if="!isBtn">
              <el-button type="primary" icon="md-add" class="mr15" @click="addBtn">添加新规格</el-button>
            </el-form-item>
          </el-col>
          <!-- 批量设置-->
          <el-col v-if="formValidate.attr.length > 0 && formValidate.specType && !isDisabled" :span="24" class="noForm">
            <el-form-item label="批量设置：">
              <el-table :data="oneFormBatch" border class="tabNumWidth" size="mini">
                <el-table-column align="center" label="图片" min-width="80">
                  <template slot-scope="scope">
                    <div class="upLoadPicBox" @click="modalPicTap('1', 'pi')">
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
                  min-width="120"
                >
                  <template slot-scope="scope">
                    <el-input
                      v-model="scope.row[iii]"
                      :type="['productName', 'material', 'capacity', 'origin', 'skuLadderPrice', 'size'].includes(iii) ? 'text' : 'number'"
                      :min="['productName', 'material', 'capacity', 'origin', 'skuLadderPrice', 'size'].includes(iii) ? null : (['stock', 'packQuantity'].includes(iii) ? '0' : '0.01')"
                      :maxlength="['productName'].includes(iii) ? '100' : (['material', 'skuLadderPrice'].includes(iii) ? '200' : (['capacity', 'origin', 'size'].includes(iii) ? '100' : '9'))"
                      class="priceBox"
                      @blur="keyupEvent(iii, scope.row[iii], scope.$index, 1)"
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
          <el-col :xl="24" :lg="24" :md="24" :sm="24" :xs="24">
            <!-- 单规格表格-->
            <el-form-item v-if="formValidate.specType === false">
              <el-table :data="OneattrValue" border class="tabNumWidth" size="mini">
                <el-table-column align="center" label="图片" min-width="80">
                  <template slot-scope="scope">
                    <div class="upLoadPicBox" @click="modalPicTap('1', 'dan', 'pi')">
                      <div v-if="formValidate.image" class="pictrue tabPic">
                        <img :src="$imageUrl(scope.row.image)" />
                      </div>
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
                  min-width="120"
                >
                  <template slot-scope="scope">
                    <el-input
                      :disabled="isDisabled"
                      v-model="scope.row[iii]"
                      :type="['productName', 'material', 'capacity', 'origin', 'skuLadderPrice', 'size'].includes(iii) ? 'text' : 'number'"
                      :min="['productName', 'material', 'capacity', 'origin', 'skuLadderPrice', 'size'].includes(iii) ? null : (['stock', 'packQuantity'].includes(iii) ? '0' : '0.01')"
                      :maxlength="['productName'].includes(iii) ? '100' : (['material', 'skuLadderPrice'].includes(iii) ? '200' : (['capacity', 'origin', 'size'].includes(iii) ? '100' : '9'))"
                      class="priceBox"
                      @blur="keyupEvent(iii, scope.row[iii], scope.$index, 2)"
                    />
                  </template>
                </el-table-column>
              </el-table>
            </el-form-item>
            <!-- <div>manyTabDate:{{manyTabDate}}</div> -->
            <el-form-item label="全部sku：" v-if="$route.params.id && showAll">
              <el-button type="default" @click="showAllSku()" :disabled="isDisabled">展示</el-button>
            </el-form-item>
            <!-- 多规格表格-->
            <el-form-item
              v-if="formValidate.attr.length > 0 && formValidate.specType"
              label="商品属性："
              class="labeltop"
              :class="isDisabled ? 'disLabel' : 'disLabelmoren'"
            >
              <el-table :data="ManyAttrValue" border class="tabNumWidth" size="mini">
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
                    <div class="upLoadPicBox" @click="modalPicTap('1', 'duo', scope.$index)">
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
                  min-width="120"
                >
                  <template slot-scope="scope">
                    <el-input
                      :disabled="isDisabled"
                      v-model="scope.row[iii]"
                      :type="['productName', 'material', 'capacity', 'origin', 'skuLadderPrice', 'size'].includes(iii) ? 'text' : 'number'"
                      :min="['productName', 'material', 'capacity', 'origin', 'skuLadderPrice', 'size'].includes(iii) ? null : (['stock', 'packQuantity'].includes(iii) ? '0' : '0.01')"
                      :maxlength="['productName'].includes(iii) ? '100' : (['material', 'skuLadderPrice'].includes(iii) ? '200' : (['capacity', 'origin', 'size'].includes(iii) ? '100' : '9'))"
                      class="priceBox"
                      @blur="keyupEvent(iii, scope.row[iii], scope.$index, 3)"
                    />
                  </template>
                </el-table-column>
                <el-table-column v-if="!isDisabled" key="3" align="center" label="操作" min-width="80">
                  <template slot-scope="scope">
                    <el-button type="text" class="submission" @click="delAttrTable(scope.$index)">删除</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </el-form-item>
          </el-col>
        </el-row>
        <!-- 商品详情-->
        <el-row v-show="currentTab === 1 && !isDisabled">
          <el-col :span="24">
            <el-form-item label="商品详情：">
              <Tinymce v-model="formValidate.content"></Tinymce>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row v-show="currentTab === 1 && isDisabled">
          <el-col :span="24">
            <el-form-item label="商品详情：">
              <span v-html="formValidate.content || '无'"></span>
            </el-form-item>
          </el-col>
        </el-row>
        <!-- 其他设置-->
        <el-row v-show="currentTab === 2">
          <el-col :span="24">
            <el-col v-bind="grid">
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
          </el-col>
          <el-col :span="24">
            <el-tooltip class="item" effect="dark" content="用户购买商品后赠送的优惠券" placement="top-start">
              <i class="el-icon-warning"></i>
            </el-tooltip>
            <el-form-item label="赠送优惠券：" class="proCoupon">
              <div class="acea-row">
                <el-tag
                  v-for="(tag, index) in formValidate.coupons"
                  :key="index"
                  class="mr10 mb10"
                  :closable="!isDisabled"
                  :disable-transitions="false"
                  @close="handleCloseCoupon(tag)"
                >
                  {{ tag.name }}
                </el-tag>
                <span class="mr15" v-if="formValidate.couponIds == null">无</span>
                <el-button v-if="!isDisabled" size="mini" class="mr15" @click="addCoupon">选择优惠券</el-button>
              </div>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item>
          <el-button 
            v-if="(currentTab === 0 || currentTab === 1) && !isDisabled" 
            type="success" 
            icon="el-icon-s-promotion" 
            class="submission mr15"
            @click="showTranslateDialog"
            >多语言翻译转换</el-button
          >
          <el-button v-show="currentTab > 0" class="submission priamry_border" @click="handleSubmitUp"
            >上一步</el-button
          >
          <el-button v-show="currentTab < 2" type="primary" class="submission" @click="handleSubmitNest('formValidate')"
            >下一步</el-button
          >
          <el-button
            v-show="(currentTab === 2 || $route.params.id) && !isDisabled"
            type="primary"
            class="submission"
            @click="handleSubmit('formValidate')"
            :loading="loadingBtn"
            >提交</el-button
          >
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 多语言翻译转换对话框 -->
    <el-dialog
      title="多语言翻译转换"
      :visible.sync="translateDialogVisible"
      width="800px"
      :close-on-click-modal="false"
    >
      <div style="margin-bottom: 20px">
        <el-alert
          title="翻译说明"
          type="info"
          :closable="false"
          show-icon
        >
          <div slot="title">
            <p>1. 系统会优先查询翻译缓存，只对未缓存的内容调用翻译API，节省字符消耗</p>
            <p>2. 翻译结果将保存到数据库，后续相同内容可直接使用缓存</p>
            <p>3. 翻译完成后，翻译结果会自动填充到对应字段</p>
          </div>
        </el-alert>
      </div>

      <el-form label-width="120px">
        <el-form-item label="选择目标语言：" required>
          <el-checkbox-group v-model="selectedLanguages">
            <el-checkbox label="en">英文</el-checkbox>
            <el-checkbox label="fr">法语</el-checkbox>
            <el-checkbox label="th">泰语</el-checkbox>
            <el-checkbox label="ru">俄语</el-checkbox>
            <el-checkbox label="jp">日语</el-checkbox>
            <el-checkbox label="kor">韩语</el-checkbox>
            <el-checkbox label="ara">阿拉伯语</el-checkbox>
          </el-checkbox-group>
        </el-form-item>

        <el-form-item label="需要翻译的字段：">
          <el-checkbox-group v-model="selectedFields">
            <el-checkbox label="storeName">商品名称</el-checkbox>
            <el-checkbox label="storeInfo">商品简介</el-checkbox>
            <el-checkbox label="keyword">商品关键字</el-checkbox>
            <el-checkbox label="unitName">单位</el-checkbox>
            <el-checkbox label="specs">规格信息（品名、材质、产地）</el-checkbox>
            <el-checkbox label="content" v-if="currentTab === 1">商品详情</el-checkbox>
          </el-checkbox-group>
        </el-form-item>

        <el-form-item label="预计字符数：">
          <span style="color: #409EFF; font-weight: bold">{{ estimatedChars }} 字符</span>
          <span style="color: #909399; margin-left: 10px">（仅计算未缓存的内容）</span>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button @click="translateDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="translating" @click="handleBatchTranslate">
          开始翻译
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import Tinymce from '@/components/Tinymce/index';
import {
  brandListApi,
  productGuaranteeApi,
  templateListApi,
  productCreateApi,
  categoryApi,
  productDetailApi,
  productUpdateApi,
  productCouponListApi,
} from '@/api/store';
import { marketingListApi } from '@/api/store';
import { Debounce } from '@/utils/validate';
import { mapGetters } from 'vuex';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
import { batchTranslateApi, getTranslationPointsApi } from '@/api/translation';
const defaultObj = {
  image: '',
  sliderImages: [],
  sliderImage: '',
  storeName: '',
  storeInfo: '',
  keyword: '',
  cateIds: [], // 商品分类id
  cateId: null, // 商品分类id传值
  unitName: '',
  sort: 0,
  isShow: false,
  attrValue: [
    {
      image: '',
      price: 0.01,
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
  content: '',
  specType: false,
  id: undefined,
  couponIds: [],
  coupons: [],
  postage: 1,
  categoryId: 0,
  guaranteeIds: '',
  guaranteeIdsList: [],
  brandName: '', // 品牌名称（自定义输入）
};

const objTitle = {
  price: {
    title: '售价',
  },
  cost: {
    title: '成本价（$）',
  },
  otPrice: {
    title: '原价（$）',
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
};
export default {
  name: 'ProductProductAdd',
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
      isDisabled: this.$route.params.isDisabled === '1' ? true : false,
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
        checkStrictly: true, // 允许选择任意级别的分类（一级、二级或三级）
        expandTrigger: 'hover', // 鼠标悬停展开，点击直接选中
      },
      tabs: [],
      fullscreenLoading: false,
      props: { multiple: true },
      active: 0,
      OneattrValue: [Object.assign({}, defaultObj.attrValue[0])], // 单规格
      ManyAttrValue: [Object.assign({}, defaultObj.attrValue[0])], // 多规格
      // 翻译相关
      translateDialogVisible: false,
      selectedLanguages: ['en', 'fr', 'th', 'ru', 'jp', 'kor', 'ara'], // 默认选择的语言（包括俄语）
      selectedFields: [], // 默认选择字段（根据当前步骤动态设置）
      translating: false,
      translationResults: {}, // 翻译结果存储：{fieldName: {language: translatedText}}
      ruleList: [],
      merCateList: [], // 商户分类筛选
      shippingList: [], // 运费模板
      formThead: Object.assign(
        {},
        {
          price: {
            title: '售价（' + this.GLOBAL.shopPayCurrency + '）',
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
        },
      ),
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
      currentTab: 0,
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
        categoryId: [{ required: true, message: '请选择平台商品分类', trigger: 'change' }],
        cateIds: [{ required: true, message: '请选择商户商品分类', trigger: 'change', type: 'array', min: '1' }],
        keyword: [{ required: true, message: '请输入商品关键字', trigger: 'blur' }],
        unitName: [{ required: true, message: '请输入单位', trigger: 'blur' }],
        storeInfo: [{ required: true, message: '请输入商品简介', trigger: 'blur' }],
        postage: [{ required: true, message: '请输入运费', trigger: 'change' }],
        image: [{ required: true, message: '请上传商品图', trigger: 'change' }],
        sliderImages: [{ required: true, message: '请上传商品轮播图', type: 'array', trigger: 'change' }],
        specType: [{ required: true, message: '请选择商品规格', trigger: 'change' }],
        // brandId: [{ required: true, message: '请选择商品品牌', trigger: 'change' }], // 品牌改为非必填
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
      productClassify: [], //平台商品分类
    };
  },
  computed: {
    ...mapGetters(['adminProductClassify', 'merProductClassify', 'productBrand']),
    visitedViews() {
      return this.$store.state.tagsView.visitedViews;
    },
    // 计算预计翻译字符数（仅计算需要翻译的字段）
    estimatedChars() {
      let totalChars = 0;
      
      // 收集需要翻译的字段
      const fieldsToTranslate = this.collectFieldsToTranslate();
      
      // 计算字符数（假设所有内容都需要翻译，实际会从缓存中查询）
      Object.values(fieldsToTranslate).forEach(text => {
        if (text && typeof text === 'string') {
          totalChars += text.length;
        }
      });
      
      // 乘以语言数量
      return totalChars * this.selectedLanguages.length;
    },

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
    this.tempRoute = Object.assign({}, this.$route);
    if (this.$route.params.id && this.formValidate.specType) {
      this.$watch('formValidate.attr', this.watCh);
    }
  },
  mounted() {
    this.formValidate.sliderImages = [];
    if (!this.adminProductClassify.length && checkPermi(['merchant:product:category:cache:tree']))
      this.$store.dispatch('product/getAdminProductClassify');
    if (!this.merProductClassify.length && checkPermi(['merchant:store:product:category:cache:tree']))
      this.$store.dispatch('product/getMerProductClassify');
    if (!this.productBrand.length && checkPermi(['merchant:product:brand:list']))
      this.$store.dispatch('product/getMerProductBrand');
    if (checkPermi(['merchant:product:guarantee:list'])) this.getProductGuarantee();
    if (this.$route.params.id) {
      this.setTagsViewTitle();
      if (checkPermi(['merchant:product:info'])) this.getInfo();
    }
    this.productClassify = this.addDisabled(this.adminProductClassify);
  },
  methods: {
    // 显示翻译对话框
    async showTranslateDialog() {
      // 先检查商户翻译积分是否足够
      try {
        const pointsRes = await getTranslationPointsApi();
        const remainingChars = pointsRes.remainingChars || 0;
        
        if (remainingChars <= 0) {
          this.$message.error('当前没有可用积分（字符），请联系平台管理员购买积分');
          return;
        }
      } catch (error) {
        // 如果获取积分信息失败，也提示用户
        console.error('获取翻译积分信息失败:', error);
        this.$message.warning('无法获取翻译积分信息，请联系平台管理员');
        return;
      }
      
      // 根据当前步骤设置默认选中的字段
      if (this.currentTab === 0) {
        // 商品信息步骤：默认选择商品信息相关字段
        if (this.selectedFields.length === 0) {
          this.selectedFields = ['storeName', 'storeInfo', 'keyword', 'unitName', 'specs'];
        }
      } else if (this.currentTab === 1) {
        // 商品详情步骤：默认选择商品详情字段
        if (this.selectedFields.length === 0) {
          this.selectedFields = ['content'];
        }
      }
      
      // 验证是否有需要翻译的内容
      const fieldsToTranslate = this.collectFieldsToTranslate();
      const hasContent = Object.values(fieldsToTranslate).some(text => text && text.trim().length > 0);
      
      if (!hasContent) {
        this.$message.warning('请先填写需要翻译的字段内容');
        return;
      }
      
      if (this.selectedFields.length === 0) {
        this.$message.warning('请至少选择一个需要翻译的字段');
        return;
      }
      
      if (this.selectedLanguages.length === 0) {
        this.$message.warning('请至少选择一种目标语言');
        return;
      }
      
      this.translateDialogVisible = true;
    },

    // 从HTML中提取纯文本（用于翻译）
    extractTextFromHTML(html) {
      if (!html) return '';
      // 创建一个临时div元素来解析HTML
      const tempDiv = document.createElement('div');
      tempDiv.innerHTML = html;
      // 提取纯文本，保留换行
      return tempDiv.textContent || tempDiv.innerText || '';
    },
    
    // 收集需要翻译的字段数据
    collectFieldsToTranslate() {
      const fields = {};
      
      // 商品名称
      if (this.selectedFields.includes('storeName') && this.formValidate.storeName) {
        fields.storeName = this.formValidate.storeName.trim();
      }
      
      // 商品简介
      if (this.selectedFields.includes('storeInfo') && this.formValidate.storeInfo) {
        fields.storeInfo = this.formValidate.storeInfo.trim();
      }
      
      // 商品关键字
      if (this.selectedFields.includes('keyword') && this.formValidate.keyword) {
        fields.keyword = this.formValidate.keyword.trim();
      }
      
      // 单位
      if (this.selectedFields.includes('unitName') && this.formValidate.unitName) {
        fields.unitName = this.formValidate.unitName.trim();
      }
      
      // 商品详情（从HTML中提取纯文本）
      if (this.selectedFields.includes('content') && this.formValidate.content) {
        const plainText = this.extractTextFromHTML(this.formValidate.content);
        if (plainText && plainText.trim().length > 0) {
          fields.content = plainText.trim();
        }
      }
      
      // 规格信息（仅翻译品名、材质、产地）
      if (this.selectedFields.includes('specs')) {
        const specFields = {
          productName: new Set(),
          material: new Set(),
          origin: new Set(),
        };
        
        // 收集单规格和多规格的数据
        const attrValueList = this.formValidate.specType ? this.ManyAttrValue : this.OneattrValue;
        
        attrValueList.forEach(item => {
          if (item.productName && item.productName.trim()) {
            specFields.productName.add(item.productName.trim());
          }
          if (item.material && item.material.trim()) {
            specFields.material.add(item.material.trim());
          }
          if (item.origin && item.origin.trim()) {
            specFields.origin.add(item.origin.trim());
          }
        });
        
        // 将Set转换为数组，取第一个值（去重后）
        // 只翻译品名、材质、产地三个字段
        if (specFields.productName.size > 0) {
          fields['product_name'] = Array.from(specFields.productName)[0];
        }
        if (specFields.material.size > 0) {
          fields['material'] = Array.from(specFields.material)[0];
        }
        if (specFields.origin.size > 0) {
          fields['origin'] = Array.from(specFields.origin)[0];
        }
      }
      
      return fields;
    },

    // 执行批量翻译
    handleBatchTranslate() {
      if (this.selectedLanguages.length === 0) {
        this.$message.warning('请至少选择一种目标语言');
        return;
      }
      
      if (this.selectedFields.length === 0) {
        this.$message.warning('请至少选择一个需要翻译的字段');
        return;
      }
      
      // 收集需要翻译的字段
      const fieldsToTranslate = this.collectFieldsToTranslate();
      
      if (Object.keys(fieldsToTranslate).length === 0) {
        this.$message.warning('请先填写需要翻译的字段内容');
        return;
      }
      
      this.translating = true;
      
      // 构建请求参数
      const requestData = {
        fields: fieldsToTranslate,
        targetLanguages: this.selectedLanguages,
        entityType: 'product',
        entityId: this.$route.params.id ? parseInt(this.$route.params.id) : null,
      };
      
      // 调用批量翻译API
      batchTranslateApi(requestData)
        .then((res) => {
          // request.js 的响应拦截器已经返回了 res.data，所以这里直接使用 res
          this.translationResults = res || {};
          
          // 保存翻译结果到数据库（如果商品已保存）
          // 注意：翻译结果已经由后端保存到Translation表和缓存表
          
          // 处理商品详情字段的翻译结果（将纯文本转换为HTML格式）
          if (this.translationResults.content) {
            // 商品详情翻译：将每种语言的翻译结果用HTML包裹
            // 注意：这里只是简单处理，实际使用时可能需要更复杂的HTML结构处理
            // 用户可以选择是否使用翻译结果替换当前的content
            // 由于content是富文本，我们暂时不自动替换，而是提示用户翻译已完成
            // 翻译结果已保存到数据库，可以在商品详情页面根据语言显示
          }
          
          // 显示翻译完成提示
          const totalFields = Object.keys(this.translationResults).length;
          const totalLanguages = this.selectedLanguages.length;
          this.$message.success(`翻译完成！共翻译 ${totalFields} 个字段，${totalLanguages} 种语言`);
          
          // 关闭对话框
          this.translateDialogVisible = false;
          
          // 提示用户：翻译结果已保存到数据库，可在商品详情中查看
          this.$message.info('翻译结果已保存到数据库，后续相同内容可直接使用缓存。商品详情翻译结果会在前台根据用户选择的语言自动显示');
          
          // 如果当前在翻译积分页面，刷新积分信息
          if (this.$route.path === '/translation/points') {
            // 触发父组件刷新（如果使用事件总线）
            this.$bus && this.$bus.$emit('refresh-translation-points');
          }
          
          // 触发刷新翻译积分事件
          this.$bus && this.$bus.$emit('refresh-translation-points');
        })
               .catch((err) => {
                 // 检查是否是积分不足的错误
                 const errorMsg =
                   (err && err.response && err.response.data && err.response.data.msg) ||
                   (err && err.message) ||
                   (err && err.msg) ||
                   '翻译失败';
                 
                 // 如果错误信息包含"积分不足"或"remainingChars"，给出更友好的提示
                 if (errorMsg.includes('积分不足') || errorMsg.includes('remainingChars') || errorMsg.includes('字符数')) {
                   this.$message.error('翻译积分不足，请联系平台管理员购买积分');
                 } else {
                   this.$message.error(errorMsg);
                 }
               })
               .finally(() => {
                 this.translating = false;
               });
           },

    //处理平台商品分类数据（允许选择任意级别的分类）
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
          // 删除了 disabled 限制，允许选择任意级别的分类（包括没有子分类的一级和二级分类）
          if (e.childList && e.childList.length > 0) {
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
      // 分类改变时的处理（品牌已改为手动输入，无需清空）
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
        //this.brandList = res.list
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
      // 字符串字段不需要数字验证
      const stringFields = ['productName', 'material', 'capacity', 'origin', 'skuLadderPrice', 'size'];
      const integerFields = ['stock', 'packQuantity'];
      
      switch (num) {
        case 1:
          if (stringFields.includes(key)) {
            this.oneFormBatch[index][key] = val;
          } else if (val == 0) {
            this.oneFormBatch[index][key] = integerFields.includes(key) ? 0 : 0.01;
          } else {
            this.oneFormBatch[index][key] =
              integerFields.includes(key)
                ? parseInt(val)
                : this.$set(this.oneFormBatch[index], key, val.toString().replace(re, '$1'));
          }
          break;
        case 2:
          if (stringFields.includes(key)) {
            this.OneattrValue[index][key] = val;
          } else if (val == 0) {
            this.OneattrValue[index][key] = integerFields.includes(key) ? 0 : 0.01;
          } else {
            this.OneattrValue[index][key] =
              integerFields.includes(key)
                ? parseInt(val)
                : this.$set(this.OneattrValue[index], key, val.toString().replace(re, '$1'));
          }
          break;
        default:
          if (stringFields.includes(key)) {
            this.ManyAttrValue[index][key] = val;
          } else if (val == 0) {
            this.ManyAttrValue[index][key] = integerFields.includes(key) ? 0 : 0.01;
          } else {
            this.ManyAttrValue[index][key] =
              integerFields.includes(key)
                ? parseInt(val)
                : this.$set(this.ManyAttrValue[index], key, val.toString().replace(re, '$1'));
          }
      }
    },
    proving1(e) {
      this.formValidate.sort = e.target.value.replace(/[^\.\d]/g, '');
      this.formValidate.sort = e.target.value.replace('.', '');
    },
    handleCloseCoupon(tag) {
      this.isAttr = true;
      this.formValidate.coupons.splice(this.formValidate.coupons.indexOf(tag), 1);
      this.formValidate.couponIds.splice(this.formValidate.couponIds.indexOf(tag.id), 1);
    },
    addCoupon() {
      const _this = this;
      this.$modalCoupon(
        'wu',
        (this.keyNum += 1),
        this.formValidate.coupons,
        function (row) {
          _this.formValidate.couponIds = [];
          _this.formValidate.coupons = row;
          row.map((item) => {
            _this.formValidate.couponIds.push(item.id);
          });
        },
        '',
      );
    },
    setTagsViewTitle() {
      const title = this.isDisabled ? '商品详情' : '编辑商品';
      const route = Object.assign({}, this.tempRoute, { title: `${title}-${this.$route.params.id}` });
      this.$store.dispatch('tagsView/updateVisitedView', route);
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
                      price: 0.01,
                      cost: 0.01,
                      otPrice: 0.01,
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
                      brokerage: 0,
                      brokerage_two: 0,
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
                price: 0.01,
                cost: 0.01,
                otPrice: 0.01,
                stock: 0,
                weight: 0,
                volume: 0,
                productName: '',
                material: '',
                packQuantity: 0,
                brokerage: 0,
                brokerage_two: 0,
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
    // 添加规则；
    addRule() {
      const _this = this;
      this.$modalAttr(this.formDynamics, function () {
        _this.productGetRule();
      });
    },
    // 选择规格
    onChangeSpec(num) {
      this.isAttr = true;
      if (num) this.productGetRule();
    },
    // 选择属性确认
    confirm() {
      this.isAttr = true;
      if (!this.formValidate.selectRule) {
        return this.$message.warning('请选择属性');
      }
      const data = [];
      this.ruleList.forEach((item) => {
        if (item.id === this.formValidate.selectRule) {
          item.ruleValue.forEach((i) => {
            data.push({
              attrName: i.value,
              attrValue: i.detail,
            });
          });
        }
        this.formValidate.attr = data;
      });
    },
    // 获取商品属性模板；
    productGetRule() {
      templateListApi(this.tableFrom).then((res) => {
        const list = res.list;
        for (var i = 0; i < list.length; i++) {
          list[i].ruleValue = JSON.parse(list[i].ruleValue);
        }
        this.ruleList = list;
      });
    },
    showInput(item) {
      this.$set(item, 'inputVisible', true);
    },
    onChangetype(item) {
      if (item === 1) {
        this.OneattrValue.map((item) => {
          this.$set(item, 'brokerage', null);
          this.$set(item, 'brokerageTwo', null);
        });
        this.ManyAttrValue.map((item) => {
          this.$set(item, 'brokerage', null);
          this.$set(item, 'brokerageTwo', null);
        });
      } else {
        this.OneattrValue.map((item) => {
          delete item.brokerage;
          delete item.brokerageTwo;
          this.$set(item, 'brokerage', null);
          this.$set(item, 'brokerageTwo', null);
        });
        this.ManyAttrValue.map((item) => {
          delete item.brokerage;
          delete item.brokerageTwo;
        });
      }
    },
    // 删除表格中的属性
    delAttrTable(index) {
      this.ManyAttrValue.splice(index, 1);
    },
    // 批量添加
    batchAdd() {
      // if (!this.oneFormBatch[0].pic || !this.oneFormBatch[0].price || !this.oneFormBatch[0].cost || !this.oneFormBatch[0].ot_price ||
      //     !this.oneFormBatch[0].stock || !this.oneFormBatch[0].bar_code) return this.$Message.warning('请填写完整的批量设置内容！');
      for (const val of this.ManyAttrValue) {
        this.$set(val, 'image', this.oneFormBatch[0].image);
        this.$set(val, 'price', this.oneFormBatch[0].price);
        this.$set(val, 'cost', this.oneFormBatch[0].cost);
        this.$set(val, 'otPrice', this.oneFormBatch[0].otPrice);
        this.$set(val, 'stock', this.oneFormBatch[0].stock);
        this.$set(val, 'weight', this.oneFormBatch[0].weight);
        this.$set(val, 'volume', this.oneFormBatch[0].volume);
        this.$set(val, 'productName', this.oneFormBatch[0].productName);
        this.$set(val, 'material', this.oneFormBatch[0].material);
        this.$set(val, 'packQuantity', this.oneFormBatch[0].packQuantity);
        this.$set(val, 'brokerage', this.oneFormBatch[0].brokerage);
        this.$set(val, 'brokerageTwo', this.oneFormBatch[0].brokerageTwo);
      }
    },
    // 添加按钮
    addBtn() {
      this.clearAttr();
      this.isBtn = true;
    },
    // 取消
    offAttrName() {
      this.isBtn = false;
    },
    clearAttr() {
      this.isAttr = true;
      this.formDynamic.attrsName = '';
      this.formDynamic.attrsVal = '';
    },
    // 删除规格
    handleRemoveAttr(index) {
      this.isAttr = true;
      this.formValidate.attr.splice(index, 1);
      this.manyFormValidate.splice(index, 1);
    },
    // 删除属性
    handleClose(item, index) {
      item.splice(index, 1);
    },
    // 添加规则名称
    createAttrName() {
      this.isAttr = true;
      if (this.formDynamic.attrsName && this.formDynamic.attrsVal) {
        const data = {
          attrName: this.formDynamic.attrsName,
          attrValue: [this.formDynamic.attrsVal],
        };
        this.formValidate.attr.push(data);
        var hash = {};
        this.formValidate.attr = this.formValidate.attr.reduce(function (item, next) {
          /* eslint-disable */
          hash[next.attrName] ? '' : (hash[next.attrName] = true && item.push(next));
          return item;
        }, []);
        this.clearAttr();
        this.isBtn = false;
      } else {
        this.$message.warning('请添加完整的规格！');
      }
    },
    // 添加属性
    createAttr(num, idx) {
      this.isAttr = true;
      if (num) {
        this.formValidate.attr[idx].attrValue.push(num);
        var hash = {};
        this.formValidate.attr[idx].attrValue = this.formValidate.attr[idx].attrValue.reduce(function (item, next) {
          /* eslint-disable */
          hash[next] ? '' : (hash[next] = true && item.push(next));
          return item;
        }, []);
        this.formValidate.attr[idx].inputVisible = false;
      } else {
        this.$message.warning('请添加属性');
      }
    },
    //点击展示所有多规格属性
    showAllSku() {
      if (this.isAttr == false) {
        this.isAttr = true;
        if (this.formValidate.specType && this.isAttr) this.watCh(this.formValidate.attr); //重要！！！
      } else if (this.isAttr == true) {
        this.isAttr = false;
        this.getInfo();
      }
    },
    // 详情
    getInfo() {
      this.fullscreenLoading = true;
      productDetailApi(this.$route.params.id)
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
            content: this.$selfUtil.replaceImgSrcHttps(info.content),
            specType: info.specType,
            id: info.id,
            coupons: info.coupons,
            couponIds: info.couponIds,
            postage: info.postage,
            brandName: info.brandName || '', // 品牌名称（自定义输入）
            categoryId: info.categoryId,
            guaranteeIds: info.guaranteeIds, //保障服务传值
            guaranteeIdsList: info.guaranteeIds ? info.guaranteeIds.split(',').map(Number) : [], //保障服务
          };
          // 品牌已改为手动输入，无需调用 getbrandList()
          productCouponListApi().then((res) => {
            if (this.formValidate.couponIds !== null) {
              let ids = this.formValidate.couponIds.toString();
              let arr = res;
              let obj = {};
              for (let i in arr) {
                obj[arr[i].id] = arr[i];
              }
              let strArr = ids.split(',');
              let newArr = [];
              for (let item of strArr) {
                if (obj[item]) {
                  newArr.push(obj[item]);
                }
              }
              this.$set(this.formValidate, 'coupons', newArr); //在编辑回显时，让返回数据中的优惠券id，通过接口匹配显示,
            }
          });
          let imgs = JSON.parse(info.sliderImage);
          let imgss = [];
          Object.keys(imgs).map((i) => {
            imgss.push(this.$selfUtil.setDomain(imgs[i]));
          });
          this.formValidate.sliderImages = [...imgss];
          if (info.specType) {
            this.productGetRule(); //加载商品规格选项
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
            // this.formValidate.attr = [] //单规格商品规格设置为空
          }
          this.fullscreenLoading = false;
        })
        .catch((res) => {
          this.fullscreenLoading = false;
          this.$message.error(res.message);
        });
    },
    handleRemove(i) {
      this.formValidate.sliderImages.splice(i, 1);
    },
    // 点击商品图
    modalPicTap(tit, num, i, status) {
      const _this = this;
      if (_this.isDisabled) return;
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
            _this.ManyAttrValue[i].image = img[0].sattDir;
          }
          if (tit === '1' && num === 'pi') {
            _this.oneFormBatch[0].image = img[0].sattDir;
          }
        },
        tit,
        'content',
      );
    },
    handleSubmitUp() {
      // this.currentTab --
      if (this.currentTab-- < 0) this.currentTab = 0;
    },
    handleSubmitNest(name) {
      this.$refs[name].validate((valid) => {
        if (valid) {
          if (this.currentTab++ > 2) this.currentTab = 0;
        } else {
          if (
            !this.formValidate.store_name ||
            !this.formValidate.cate_id ||
            !this.formValidate.keyword ||
            !this.formValidate.unit_name ||
            !this.formValidate.store_info ||
            !this.formValidate.image ||
            !this.formValidate.slider_image
          ) {
            this.$message.warning('请填写完整商品信息！');
          }
        }
      });
    },
    // 提交
    handleSubmit(name) {
      if (this.formValidate.specType && this.formValidate.attr.length < 1)
        return this.$message.warning('请填写多规格属性！');
      this.formValidate.cateId = this.formValidate.cateIds.join(',');
      this.formValidate.guaranteeIds = this.formValidate.guaranteeIdsList.join(',');
      this.formValidate.sliderImage = JSON.stringify(this.formValidate.sliderImages);
      if (this.formValidate.specType) {
        this.formValidate.attrValue = this.ManyAttrValue;
        this.formValidate.attr = this.formValidate.attr.map((item) => {
          return {
            attrName: item.attrName,
            id: item.id,
            attrValues: item.attrValue.join(','),
          };
        });
        for (var i = 0; i < this.formValidate.attrValue.length; i++) {
          this.$set(this.formValidate.attrValue[i], 'id', 0);
          this.$set(this.formValidate.attrValue[i], 'productId', 0);
          this.$set(
            this.formValidate.attrValue[i],
            'attrValue',
            JSON.stringify(this.formValidate.attrValue[i].attrValue),
          ); //
          delete this.formValidate.attrValue[i].value0;
        }
      } else {
        this.formValidate.attr = [
          { attrName: '规格', attrValues: '默认', id: this.$route.params.id ? this.formValidate.attr[0].id : 0 },
        ];
        this.OneattrValue.map((item) => {
          this.$set(item, 'attrValue', JSON.stringify({ 规格: '默认' }));
          this.$set(item, 'productId', 0);
        });
        this.formValidate.attrValue = this.OneattrValue;
      }
      // 验证商品规格中的必填字段
      let specValidationError = false;
      let errorMessage = '';
      
      const attrValueToCheck = this.formValidate.specType ? this.ManyAttrValue : this.OneattrValue;
      
      for (let i = 0; i < attrValueToCheck.length; i++) {
        const item = attrValueToCheck[i];
        
        // 检查产地是否填写（必填）
        if (!item.origin || item.origin.trim() === '') {
          specValidationError = true;
          errorMessage = `第${i + 1}个规格的产地不能为空`;
          break;
        }
        
        // 检查品名是否填写（必填）
        if (!item.productName || item.productName.trim() === '') {
          specValidationError = true;
          errorMessage = `第${i + 1}个规格的品名不能为空`;
          break;
        }
      }
      
      if (specValidationError) {
        this.$message.warning(errorMessage);
        return;
      }
      
      this.$refs[name].validate((valid) => {
        if (valid) {
          this.loadingBtn = true;
          this.$route.params.id
            ? productUpdateApi(this.formValidate)
                .then(async (res) => {
                  this.$message.success('编辑成功');
                  setTimeout(() => {
                    this.$router.push({ path: '/product/list' });
                  }, 500);
                  this.closeSelectedTag();
                  this.loadingBtn = false;
                })
                .catch((res) => {
                  this.loadingBtn = false;
                })
            : productCreateApi(this.formValidate)
                .then(async (res) => {
                  this.$message.success('新增成功');
                  setTimeout(() => {
                    this.$router.push({ path: '/product/list' });
                  }, 500);
                  this.closeSelectedTag();
                  this.loadingBtn = false;
                })
                .catch((res) => {
                  this.loadingBtn = false;
                });
        } else {
          if (
            !this.formValidate.storeName ||
            !this.formValidate.cateId ||
            !this.formValidate.keyword ||
            !this.formValidate.unitName ||
            !this.formValidate.storeInfo ||
            !this.formValidate.image ||
            !this.formValidate.sliderImages
          ) {
            this.$message.warning('请填写完整商品信息！');
          }
        }
      });
    },
    isActive(route) {
      return route.path === this.$route.path;
    },
    closeSelectedTag() {
      let that = this;
      that.$store.dispatch('tagsView/delView', that.$route).then(({ visitedViews }) => {
        if (that.isActive(that.$route)) {
          that.toLastView(visitedViews, that.$route);
        }
      });
    },
    toLastView(visitedViews, view) {
      const latestView = visitedViews.slice(-1)[0];
      if (latestView) {
        this.$router.push(latestView.fullPath);
      } else {
        // now the default is to redirect to the home page if there is no tags-view,
        // you can adjust it according to your needs.
        if (view.name === 'Dashboard') {
          // to reload home page
          this.$router.replace({ path: '/redirect' + view.fullPath });
        } else {
          this.$router.push('/');
        }
      }
    },
    // 表单验证
    validate(prop, status, error) {
      if (status === false) {
        this.$message.warning(error);
      }
    },
    // 移动
    handleDragStart(e, item) {
      if (!this.isDisabled) this.dragging = item;
    },
    handleDragEnd(e, item) {
      if (!this.isDisabled) this.dragging = null;
    },
    handleDragOver(e) {
      if (!this.isDisabled) e.dataTransfer.dropEffect = 'move';
    },
    handleDragEnter(e, item) {
      if (!this.isDisabled) {
        e.dataTransfer.effectAllowed = 'move';
        if (item === this.dragging) {
          return;
        }
        const newItems = [...this.formValidate.sliderImages];
        const src = newItems.indexOf(this.dragging);
        const dst = newItems.indexOf(item);
        newItems.splice(dst, 0, ...newItems.splice(src, 1));
        this.formValidate.sliderImages = newItems;
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
.el-icon-warning {
  position: relative;
  top: 26px;
  left: 9px;
}
.disLabel {
  ::v-deepel-form-item__label {
    margin-left: 36px !important;
  }
}
.disLabelmoren {
  ::v-deepel-form-item__label {
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
.tabNumWidth {
  ::v-deepel-input-number--medium {
    width: 121px !important;
  }
  ::v-deepel-input-number__increase {
    width: 20px !important;
    font-size: 12px !important;
  }
  ::v-deepel-input-number__decrease {
    width: 20px !important;
    font-size: 12px !important;
  }
  ::v-deepel-input-number--medium .el-input__inner {
    padding-left: 25px !important;
    padding-right: 25px !important;
  }
  ::v-deep thead {
    line-height: normal !important;
  }
  ::v-deep .el-table .cell {
    line-height: normal !important;
  }
}
.selWidth {
  width: 100%;
}
.selWidthd {
  width: 300px;
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
.btndel {
  position: absolute;
  z-index: 1;
  width: 20px !important;
  height: 20px !important;
  left: 46px;
  top: -4px;
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