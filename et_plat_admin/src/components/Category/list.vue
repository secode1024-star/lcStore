<template>
  <div>
    <template v-if="selectModel">
      <el-tree
        ref="tree"
        :data="treeList"
        show-checkbox
        node-key="id"
        @check="getCurrentNode"
        :default-checked-keys="selectModelKeysNew"
        :props="treeProps"
      >
      </el-tree>
    </template>
    <template v-else>
      <div class="divBox">
        <el-card class="box-card">
          <div slot="header" class="clearfix acea-row">
            <el-button
              size="mini"
              type="primary"
              v-if="checkPermi(['platform:product:category:add'])"
              @click="handleAddMenu({ id: 0, name: '顶层目录' })"
              >新增{{ biztype.name }}</el-button
            >
            <el-button
              size="mini"
              type="success"
              @click="handleBatchTranslate"
              :loading="batchTranslating"
              v-if="checkPermi(['platform:product:category:update'])"
              style="margin-left: 10px;"
              >{{ batchTranslating ? '翻译中...' : '批量翻译' }}</el-button
            >
            <el-alert
              v-show="biztype.value === 1"
              class="alert_title"
              title="商户上传商品可选择一级、二级或三级分类"
              type="info"
              effect="dark"
            >
            </el-alert>
          </div>
          <el-table
            :data="dataList"
            size="mini"
            v-loading="listLoading"
            class="table"
            highlight-current-row
            row-key="id"
            :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
          >
            <el-table-column prop="name" label="名称" min-width="200">
              <template slot-scope="scope"> {{ scope.row.name }} | {{ scope.row.id }} </template>
            </el-table-column>
            <template v-if="!selectModel">
              <el-table-column label="级别" min-width="150">
                <template slot-scope="scope">
                  <span>{{ scope.row.level }}</span>
                  <!--<span>{{ scope.row.type | filterCategroyType | filterEmpty }}</span>-->
                </template>
              </el-table-column>
              <el-table-column label="分类图标" min-width="80">
                <template slot-scope="scope">
                  <div class="demo-image__preview">
                    <el-image
                      style="width: 36px; height: 36px"
                      :src="scope.row.icon"
                      :preview-src-list="[scope.row.icon]"
                      v-if="scope.row.icon"
                    />
                    <img style="width: 36px; height: 36px" v-else :src="defaultImg" alt="" />
                  </div>
                </template>
              </el-table-column>
              <el-table-column label="排序" prop="sort" min-width="150" />
              <el-table-column label="状态" min-width="150">
                <!--  -->
                <template slot-scope="scope">
                  <el-switch
                    v-if="checkPermi(['platform:product:category:show:status'])"
                    v-model="scope.row.isShow"
                    :active-value="true"
                    :inactive-value="false"
                    active-text="显示"
                    inactive-text="隐藏"
                    @change="onchangeIsShow(scope.row)"
                  />
                  <span v-else>{{ scope.row.isShow ? '显示' : '隐藏' }}</span>
                </template>
              </el-table-column>

              <el-table-column label="操作" min-width="200" fixed="right">
                <template slot-scope="scope">
                  <el-button
                    type="text"
                    size="small"
                    v-if="checkPermi(['platform:product:category:add']) && scope.row.level < 3"
                    @click="handleAddMenu(scope.row)"
                    >添加子目录</el-button
                  >
                  <el-button
                    type="text"
                    v-if="checkPermi(['platform:product:category:update'])"
                    size="small"
                    @click="handleEditMenu(scope.row)"
                    >编辑</el-button
                  >
                  <el-button
                    type="text"
                    v-if="checkPermi(['platform:product:category:delete'])"
                    size="small"
                    @click="handleDelMenu(scope.row)"
                    >删除</el-button
                  >
                </template>
              </el-table-column>
            </template>
          </el-table>
        </el-card>
      </div>
    </template>
    <el-dialog
      :title="editDialogConfig.isCreate === 0 ? `创建${biztype.name}` : `编辑${biztype.name}`"
      :visible.sync="editDialogConfig.visible"
      destroy-on-close
      :close-on-click-modal="false"
    >
      <edit
        v-if="editDialogConfig.visible"
        :prent="editDialogConfig.prent"
        :is-create="editDialogConfig.isCreate"
        :edit-data="editDialogConfig.data"
        :biztype="editDialogConfig.biztype"
        :all-tree-list="dataList"
        @hideEditDialog="hideEditDialog"
      />
    </el-dialog>
  </div>
</template>

<script>
import * as storeApi from '@/api/store.js';
import info from './info';
import edit from './edit';
import * as selfUtil from '@/utils/ZBKJIutil.js';
import { checkPermi, checkRole } from '@/utils/permission';
export default {
  // name: "list"
  components: { info, edit },
  props: {
    biztype: {
      // 类型，1 产品分类，2 附件分类，3 文章分类， 4 设置分类， 5 菜单分类
      type: Object,
      default: { value: -1 },
      validator: (obj) => {
        return obj.value > 0;
      },
    },
    pid: {
      type: Number,
      default: 0,
      validator: (value) => {
        return value >= 0;
      },
    },
    selectModel: {
      // 是否选择模式
      type: Boolean,
      default: false,
    },
    selectModelKeys: {
      type: Array,
    },
    rowSelect: {},
  },
  data() {
    return {
      listLoading: false,
      selectModelKeysNew: this.selectModelKeys,
      loading: false,
      constants: this.$constants,
      batchTranslating: false, // 批量翻译状态
      treeProps: {
        label: 'name',
        children: 'child',
      },
      multipleSelection: [],
      editDialogConfig: {
        visible: false,
        isCreate: 0, // 0=创建，1=编辑
        prent: {}, // 父级对象
        data: {},
        biztype: this.biztype, // 统一主业务中的目录类型
      },
      dataList: [],
      treeList: [],
      listPram: {
        pid: this.pid,
        type: this.biztype.value,
        isShow: -1,
        name: '',
        page: this.$constants.page.page,
        limit: this.$constants.page.limit[0],
      },
      viewInfoConfig: {
        data: null,
        visible: false,
      },
      defaultImg: require('@/assets/imgs/moren.jpg'),
    };
  },
  mounted() {
    this.handlerGetTreeList();
  },
  methods: {
    checkPermi, //权限控制
    onchangeIsShow(row) {
      storeApi
        .productCategoryShowApi(row.id)
        .then(() => {
          this.$message.success('修改成功');
          this.$store.commit('product/SET_AdminProductClassify', []);
          this.handlerGetTreeList();
        })
        .catch(() => {
          row.isShow = !row.isShow;
        });
    },
    handleEditMenu(rowData) {
      this.editDialogConfig.isCreate = 1;
      this.editDialogConfig.data = rowData;
      this.editDialogConfig.prent = rowData;
      this.editDialogConfig.visible = true;
    },
    handleAddMenu(rowData) {
      this.editDialogConfig.isCreate = 0;
      this.editDialogConfig.prent = rowData;
      this.editDialogConfig.data = {};
      this.editDialogConfig.biztype = this.biztype;
      this.editDialogConfig.visible = true;
    },
    getCurrentNode(data) {
      let node = this.$refs.tree.getNode(data);
      this.childNodes(node);
      // this.parentNodes(node);
      //是否编辑的表示
      // this.ruleForm.isEditorFlag = true;
      //编辑时候使用
      this.$emit('rulesSelect', this.$refs.tree.getCheckedKeys());
      // this.selectModelKeys = this.$refs.tree.getCheckedKeys();
      //无论编辑和新增点击了就传到后台这个值
      // this.$emit('rulesSelect', this.$refs.tree.getCheckedKeys().concat(this.$refs.tree.getHalfCheckedKeys()));
      // this.ruleForm.menuIdsisEditor = this.$refs.tree.getCheckedKeys().concat(this.$refs.tree.getHalfCheckedKeys());
    },
    //具体方法可以看element官网api
    childNodes(node) {
      let len = node.childNodes.length;
      for (let i = 0; i < len; i++) {
        node.childNodes[i].checked = node.checked;
        this.childNodes(node.childNodes[i]);
      }
    },
    parentNodes(node) {
      if (node.parent) {
        for (let key in node) {
          if (key == 'parent') {
            node[key].checked = true;
            this.parentNodes(node[key]);
          }
        }
      }
    },
    handleDelMenu(rowData) {
      this.$modalSure('删除当前数据?').then(() => {
        storeApi.productCategoryDeleteApi(rowData.id).then((res) => {
          this.handlerGetTreeList();
          this.$store.commit('product/SET_AdminProductClassify', []);
          this.$message.success('删除成功');
        });
      });
    },
    handlerGetList() {
      this.handlerGetTreeList();
    },
    getTree() {
      storeApi.productCategoryApi().then((res) => {
        this.treeList = this.changeNodes(res);
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
    handlerGetTreeList() {
      storeApi
        .productCategoryListApi()
        .then((res) => {
          let obj = {},
            dataList = [];
          res.forEach((item) => {
            obj = item;
            obj.parentId = item.pid;
            obj.children = [];
            dataList.push(obj);
          });
          this.dataList = this.handleTree(dataList, 'menuId');
          this.treeList = this.handleAddArrt(res);
          this.loading = false;
        })
        .catch(() => {
          this.loading = false;
        });
    },
    handlerGetInfo(id) {
      this.viewInfoConfig.data = id;
      this.viewInfoConfig.visible = true;
    },
    handleNodeClick(data) {
      console.log('data:', data);
    },
    handleAddArrt(treeData) {
      const _result = selfUtil.addTreeListLabel(treeData);
      return _result;
    },
    hideEditDialog(eventData) {
      setTimeout(() => {
        this.editDialogConfig.prent = {};
        this.editDialogConfig.type = 0;
        this.editDialogConfig.visible = false;
        this.handlerGetTreeList();
        
        // 如果是新增分类，自动触发翻译
        if (eventData && eventData.action === 'create' && eventData.category) {
          this.autoTranslateCategory(eventData.category);
        }
      }, 200);
    },
    
    // 批量翻译所有分类
    async handleBatchTranslate() {
      this.$modalSure('确定要翻译所有分类吗？这可能需要一些时间。').then(async () => {
        this.batchTranslating = true;
        try {
          const allCategories = this.getAllCategories(this.dataList);
          if (allCategories.length === 0) {
            this.$message.warning('没有找到需要翻译的分类');
            return;
          }
          
          const response = await this.$http.post('/admin/translation/category/batch', {
            categories: allCategories.map(cat => ({ id: cat.id, name: cat.name })),
            sourceLang: 'zh-CN',
            targetLangs: ['en', 'fr', 'th', 'ko', 'ja', 'ar'],
            provider: 'baidu'
          });
          
          // 检查响应数据结构
          console.log('批量翻译响应:', response);
          
          if (response && (response.code === 200 || response.successCount !== undefined)) {
            const successCount = response.successCount || (response.data && response.data.successCount) || allCategories.length;
            this.$message.success(`批量翻译完成！共翻译 ${successCount} 个分类`);
          } else {
            this.$message.error('批量翻译失败: ' + (response.message || response.msg || '未知错误'));
          }
        } catch (error) {
          console.error('批量翻译失败:', error);
          this.$message.error('批量翻译失败: ' + (error.message || '网络错误'));
        } finally {
          this.batchTranslating = false;
        }
      }).catch(() => {});
    },
    
    // 递归获取所有分类
    getAllCategories(categories) {
      let result = [];
      categories.forEach(category => {
        result.push(category);
        if (category.children && category.children.length > 0) {
          result = result.concat(this.getAllCategories(category.children));
        }
      });
      return result;
    },
    
    // 自动翻译新增的分类
    async autoTranslateCategory(category) {
      try {
        console.log(`自动翻译新增分类: ${category.name} (ID: ${category.id})`);
        const response = await this.$http.post('/admin/translation/category/single', {
          categoryId: category.id,
          categoryName: category.name,
          sourceLang: 'zh-CN',
          targetLangs: ['en', 'fr', 'th', 'ko', 'ja', 'ar'],
          provider: 'baidu'
        });
        
        console.log('单个分类翻译响应:', response);
        
        if (response && (response.code === 200 || response.categoryId !== undefined)) {
          this.$message.success(`分类"${category.name}"翻译完成`);
        } else {
          console.warn(`分类"${category.name}"翻译失败:`, response.message || response.msg);
        }
      } catch (error) {
        console.error('自动翻译失败:', error);
      }
    },
    handleSelectionChange(d1, { checkedNodes, checkedKeys, halfCheckedNodes, halfCheckedKeys }) {
      this.multipleSelection = checkedKeys;
      this.$emit('rulesSelect', this.multipleSelection);
    },
  },
};
</script>

<style scoped>
.alert_title {
  margin-left: 20px;
  width: 240px;
}
.custom-tree-node {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
  padding-right: 8px;
}
</style>
