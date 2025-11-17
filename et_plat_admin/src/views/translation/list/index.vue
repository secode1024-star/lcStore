<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <el-form size="small" inline label-width="100px">
            <el-form-item label="选择商户">
              <el-select
                v-model="tableFrom.merId"
                placeholder="请选择商户（留空查看所有）"
                clearable
                filterable
                style="width: 200px"
              >
                <el-option
                  v-for="merchant in merchantList"
                  :key="merchant.id"
                  :label="merchant.name"
                  :value="merchant.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="实体类型">
              <el-select v-model="tableFrom.entityType" placeholder="请选择" clearable style="width: 150px">
                <el-option label="商品" value="product" />
                <el-option label="分类" value="category" />
                <el-option label="品牌" value="brand" />
              </el-select>
            </el-form-item>
            <el-form-item label="目标语言">
              <el-select v-model="tableFrom.targetLanguage" placeholder="请选择" clearable style="width: 150px">
                <el-option label="英文" value="en" />
                <el-option label="法语" value="fr" />
                <el-option label="泰语" value="th" />
                <el-option label="老挝语" value="lo" />
                <el-option label="日语" value="jp" />
                <el-option label="韩语" value="kor" />
                <el-option label="阿拉伯语" value="ara" />
              </el-select>
            </el-form-item>
            <el-button size="small" type="primary" icon="el-icon-search" @click="getList">查询</el-button>
          </el-form>
        </div>
      </div>
      <el-table v-loading="listLoading" :data="tableData.data" style="width: 100%" size="mini">
        <el-table-column prop="id" label="ID" min-width="60" />
        <el-table-column prop="merId" label="商户ID" min-width="80" />
        <el-table-column prop="entityType" label="实体类型" min-width="100">
          <template slot-scope="scope">
            <span>{{ getEntityTypeName(scope.row.entityType) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="entityId" label="实体ID" min-width="80" />
        <el-table-column prop="fieldName" label="字段名称" min-width="120" />
        <el-table-column prop="targetLanguage" label="目标语言" min-width="100" />
        <el-table-column prop="sourceText" label="源文本" min-width="200" :show-overflow-tooltip="true" />
        <el-table-column prop="translatedText" label="翻译文本" min-width="200" :show-overflow-tooltip="true" />
        <el-table-column prop="charCount" label="字符数" min-width="80" />
        <el-table-column prop="createTime" label="创建时间" min-width="160" />
      </el-table>
      <div class="block">
        <el-pagination
          :page-sizes="[20, 40, 60, 80]"
          :page-size="tableFrom.limit"
          :current-page="tableFrom.page"
          layout="total, sizes, prev, pager, next, jumper"
          :total="tableData.total"
          @size-change="handleSizeChange"
          @current-change="pageChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script>
import { getTranslationListApi } from '@/api/translation';
import { merchantListApi } from '@/api/merchant';

export default {
  name: 'TranslationList',
  data() {
    return {
      listLoading: false,
      merchantList: [],
      tableData: {
        data: [],
        total: 0,
      },
      tableFrom: {
        page: 1,
        limit: 20,
        merId: null,
        entityType: '',
        targetLanguage: '',
      },
    };
  },
  mounted() {
    this.loadMerchantList();
    this.getList();
  },
  methods: {
    loadMerchantList() {
      merchantListApi({ page: 1, limit: 1000 })
        .then((res) => {
          // 根据平台管理端的响应格式调整
          this.merchantList = (res && res.list) || [];
        })
        .catch((err) => {
          console.error('加载商户列表失败', err);
        });
    },
    getList() {
      this.listLoading = true;
      getTranslationListApi(this.tableFrom)
        .then((res) => {
          console.log('翻译列表API响应:', res);
          
          // 根据平台管理端的响应格式调整
          // request.js 返回的是 res.data，如果 res.data 是 CommonPage，则包含 list 和 total
          if (res && res.list !== undefined) {
            // CommonPage 格式：{list: [], total: 0}
            this.tableData = {
              data: res.list || [],
              total: res.total || 0,
            };
          } else if (res && res.data && res.data.list !== undefined) {
            // 嵌套的 CommonPage 格式
            this.tableData = {
              data: res.data.list || [],
              total: res.data.total || 0,
            };
          } else if (res && Array.isArray(res)) {
            // 直接是数组
            this.tableData = {
              data: res,
              total: res.length,
            };
          } else {
            // 空数据
            this.tableData = {
              data: [],
              total: 0,
            };
          }
          
          console.log('解析后的翻译列表数据:', this.tableData);
          this.listLoading = false;
        })
        .catch((err) => {
          const errorMsg =
            (err && err.response && err.response.data && err.response.data.msg) ||
            (err && err.message) ||
            (err && err.msg) ||
            '获取翻译列表失败';
          this.$message.error(errorMsg);
          this.listLoading = false;
        });
    },
    pageChange(page) {
      this.tableFrom.page = page;
      this.getList();
    },
    handleSizeChange(limit) {
      this.tableFrom.limit = limit;
      this.getList();
    },
    getEntityTypeName(type) {
      const typeMap = {
        product: '商品',
        category: '分类',
        brand: '品牌',
      };
      return typeMap[type] || type;
    },
  },
};
</script>

<style lang="scss" scoped>
.divBox {
  padding: 20px;
}
</style>



































