<template>
  <div class="divBox">
    <el-card class="box-card">
      <el-tabs
        v-model="activeNamel1"
        @tab-click="handleTabClick"
        v-loading="loading"
        v-if="checkPermi(['platform:config:info'])"
      >
        <el-tab-pane v-for="(tab, index) in treeList" :key="index" :label="tab.name" :name="tab.id.toString()">
          <template>
            <el-tabs
              v-if="tab.child.length > 0"
              v-model="activeNamel2"
              type="border-card"
              @tab-click="handleItemTabClick"
            >
              <el-tab-pane
                v-for="(tabItem, itemIndex) in tab.child"
                :key="itemIndex"
                :label="tabItem.name"
                :name="tabItem.extra"
              >
                <parser
                  v-if="formConfChild.render"
                  :is-edit="formConfChild.isEdit"
                  :form-conf="formConfChild.content"
                  :form-edit-data="currentEditData"
                  @submit="handlerSubmit"
                />
              </el-tab-pane>
            </el-tabs>
            <span v-else>
              <parser
                v-if="formConf.render"
                :is-edit="formConf.isEdit"
                :form-conf="formConf.content"
                :form-edit-data="currentEditData"
                @submit="handlerSubmit"
              />

              <!--币种配置-->
              <el-alert
                :closable="false"
                title="货币设置为系统初始化时设置，不得随意更改，需要配合支付产品所开通的币种来设置。配置商品价格单位，点击行选中内容"
                type="warning"
                effect="dark"
              >
              </el-alert>
              <el-divider></el-divider>
              <div>
                <span>已选币种：{{ country }} , {{ currency }} , {{ symbol }}</span>
                <el-divider></el-divider>
              </div>
              <el-table
                ref="singleTable"
                :data="tableData.filter((data) => !search || data.country.toLowerCase().includes(search.toLowerCase()))"
                highlight-current-row
                @current-change="handleCurrentChange"
                style="width: 100%"
              >
                <el-table-column property="ID" label="ID"></el-table-column>
                <el-table-column property="country" label="国家"></el-table-column>
                <el-table-column property="currency" label="货币"></el-table-column>
                <el-table-column property="symbol" label="符号"></el-table-column>
                <el-table-column align="right">
                  <template slot="header" slot-scope="scope">
                    <el-input v-model="search" size="mini" placeholder="输入国家搜索" />
                  </template>
                  <template slot-scope="scope">
                    <el-button size="mini" @click="handleChecked(scope.$index, scope.row)">确定</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </span>
          </template>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
import parser from '@/components/FormGenerator/components/parser/Parser';
import * as categoryApi from '@/api/categoryApi.js';
import * as selfUtil from '@/utils/ZBKJIutil.js';
import * as systemFormConfigApi from '@/api/systemFormConfig.js';
import * as systemSettingApi from '@/api/systemSetting.js';
import * as systemConfigApi from '@/api/systemConfig.js';
// import { configSaveUniq, configGetUniq } from '@/api/systemConfig';
import currency from '@/assets/json/currency.json';
import { beautifierConf } from '@/components/FormGenerator/utils';
import { checkPermi } from '@/utils/permission'; // 权限判断函数
import { Debounce } from '@/utils/validate';
export default {
  // name: "index",
  components: { parser },
  data() {
    return {
      loading: false,
      formConf: { content: { fields: [] }, id: null, render: false, isEdit: false },
      formConfChild: { content: { fields: [] }, id: null, render: false, isEdit: false },
      activeNamel1: null,
      activeNamel2: '', //针对文件特殊处理
      treeList: [],
      editDataChild: {},
      isCreate: 0,
      currentEditId: null,
      currentEditData: null,
      currentSelectedUploadFlag: null,
      tableData: currency, //币种列表值
      search: '', //币种列表搜索字段
      country: '', //国家
      currency: '', //币种
      symbol: '', //符号
    };
  },
  mounted() {
    if (checkPermi(['platform:config:info'])) this.handlerGetTreeList();
    this.getCurrentUploadSelectedFlag();
    this.getCurrency();
  },
  methods: {
    checkPermi,
    handleCurrentChange(val) {
      this.currentRow = val;
    },
    //获取币种
    getCurrency() {
      systemConfigApi.configGetUniq({ key: 'shop_pay_currency' }).then((res) => {
        let data = JSON.parse(res);
        this.country = data.country; //国家
        this.currency = data.currency; //币种
        this.symbol = data.symbol; //符号
        localStorage.setItem('shopPayCurrencyPlat', JSON.stringify(data.symbol));
      });
    },
    //选中货币提交
    handleChecked(i, item) {
      this.$modalSure(
        '修改币种设置吗？货币设置为系统初始化时设置，不得随意更改，需要配合支付产品所开通的币种来设置。',
      ).then(() => {
        systemConfigApi.configSaveUniq({ key: 'shop_pay_currency', value: JSON.stringify(item) }).then((data) => {
          this.country = item.country; //国家
          this.currency = item.currency; //币种
          this.symbol = item.symbol; //符号
          this.$message.success('提交成功');
        });
      });
    },
    //点击tab导航栏
    handleTabClick(tab) {
      if (!tab.$children[0].panes) return;
      this.activeNamel2 = tab.$children[0].panes[0].name;
      this.handlerGetLevel2FormConfig(this.activeNamel2);
    },
    handlerGetLevel1FormConfig(id) {
      const formPram = { id: id };
      this.currentEditId = id;
      this.formConf.content = { fields: [] };
      this.formConf.render = false;
      this.loading = true;
      systemFormConfigApi
        .getFormConfigInfo(formPram)
        .then((data) => {
          const { id, name, info, content } = data;
          this.formConf.content = JSON.parse(content);
          this.formConf.id = id;
          this.handlerGetSettingInfo(id, 1);
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    handleItemTabClick(tab, event) {
      //这里对tabs=tab.name和radio=id做了兼容
      let _id = tab.name ? tab.name : tab;
      if (!_id) return this.$message.error('表单配置不正确，请关联正确表单后使用');
      this.handlerGetLevel2FormConfig(_id);
    },
    handlerGetLevel2FormConfig(id) {
      const formPram = { id: id };
      this.currentEditId = id;
      this.formConfChild.content = { fields: [] };
      this.formConfChild.render = false;
      this.loading = true;
      systemFormConfigApi
        .getFormConfigInfo(formPram)
        .then((data) => {
          const { id, name, info, content } = data;
          this.formConfChild.content = JSON.parse(content);
          this.formConfChild.id = id;
          this.handlerGetSettingInfo(id, 2);
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    handlerGetSettingInfo(id, level) {
      systemSettingApi.systemConfigInfo({ id: id }).then((data) => {
        this.currentEditData = data;
        if (level === 1) {
          this.formConf.isEdit = this.currentEditData !== null;
          this.formConf.render = true;
        } else {
          this.formConfChild.isEdit = this.currentEditData !== null;
          this.formConfChild.render = true;
        }
      });
    },
    //表单提交
    handlerSubmit: Debounce(function (formValue) {
      if (checkPermi(['platform:config:save:form'])) {
        this.handlerSave(formValue);
      } else {
        this.$message.warning('暂无操作权限');
      }
    }),
    //保存方法
    handlerSave(formValue) {
      console.log('=== 开始保存 ===');
      console.log('formValue:', formValue);
      console.log('currentEditId:', this.currentEditId);
      
      // 检查必要的参数
      if (!this.currentEditId) {
        console.log('错误: currentEditId为空');
        this.$message.error('请先选择要配置的模块');
        return;
      }
      
      const _pram = this.buildFormPram(formValue);
      console.log('构建的参数:', _pram);
      let _formId = 0;
      systemSettingApi.systemConfigSave(_pram).then((data) => {
        console.log('保存成功:', data);
        this.$message.success('保存成功');
      }).catch((error) => {
        console.error('保存失败:', error);
        console.error('错误详情:', error.response);
        this.$message.error('保存失败，请重试');
      });
    },
    //获取配置数据
    handlerGetTreeList() {
      const _pram = { type: this.$constants.categoryType[5].value, status: 1 };
      this.loading = true;
      categoryApi
        .treeCategroy(_pram)
        .then((data) => {
          this.treeList = this.handleAddArrt(data);
          if (this.treeList.length > 0) this.activeNamel1 = this.treeList[0].id.toString();
          if (this.treeList.length > 0 && this.treeList[0].child.length > 0) {
            this.activeNamel2 = this.treeList[0].child[0].extra;
          }
          if (this.activeNamel2) {
            this.handlerGetLevel2FormConfig(this.treeList[0].child[0].extra);
          }
          this.treeList.push({
            extra: null,
            id: 600,
            name: '币种配置',
            path: '/0/',
            pid: 0,
            sort: 1,
            status: true,
            type: 6,
            url: 'short_letter_switch',
            child: [],
          });
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    handleAddArrt(treeData) {
      // let _result = this.addTreeListLabel(treeData)
      const _result = selfUtil.addTreeListLabel(treeData);
      return _result;
    },
    buildFormPram(formValue) {
      const _pram = {
        fields: [],
        id: this.currentEditId,
        sort: 0, // 参数暂时无用
        status: true, // 参数暂时无用
      };
      const _fields = [];
      Object.keys(formValue).forEach((key) => {
        if (key !== 'id') {
          _fields.push({
            name: key,
            title: key,
            value: formValue[key],
          });
        }
      });
      _pram.fields = _fields;
      return _pram;
    },
    getCurrentUploadSelectedFlag() {
      systemConfigApi.configGetUniq({ key: 'uploadType' }).then((data) => {
        this.currentSelectedUploadFlag = parseInt(data);
      });
    },
  },
};
</script>

<style scoped></style>
