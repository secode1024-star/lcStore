<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <h3>翻译统计</h3>
        </div>
      </div>
      <div class="filter-bar" style="margin-bottom: 20px">
        <el-form size="small" inline label-width="100px">
          <el-form-item label="选择商户">
            <el-select
              v-model="selectedMerId"
              placeholder="请选择商户（留空查看所有）"
              clearable
              filterable
              style="width: 300px"
              @change="handleMerchantChange"
            >
              <el-option
                v-for="merchant in merchantList"
                :key="merchant.id"
                :label="merchant.name"
                :value="merchant.id"
              />
            </el-select>
          </el-form-item>
          <el-button size="small" type="primary" icon="el-icon-search" @click="getStatistics">查询</el-button>
        </el-form>
      </div>
      <div v-loading="loading" class="statistics-content">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">总翻译数</div>
                <div class="stat-value">{{ statistics.totalCount || 0 }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="hover">
              <div class="stat-item">
                <div class="stat-label">总字符数</div>
                <div class="stat-value">{{ statistics.totalChars || 0 }}</div>
              </div>
            </el-card>
          </el-col>
        </el-row>

        <el-row :gutter="20" style="margin-top: 20px">
          <el-col :span="12">
            <el-card shadow="hover">
              <div slot="header">
                <span>按语言统计</span>
              </div>
              <el-table :data="langStatisticsData" style="width: 100%" size="mini">
                <el-table-column prop="language" label="语言" min-width="120" />
                <el-table-column prop="count" label="数量" min-width="100" />
              </el-table>
            </el-card>
          </el-col>
          <el-col :span="12">
            <el-card shadow="hover">
              <div slot="header">
                <span>按实体类型统计</span>
              </div>
              <el-table :data="entityStatisticsData" style="width: 100%" size="mini">
                <el-table-column prop="entityType" label="实体类型" min-width="120" />
                <el-table-column prop="count" label="数量" min-width="100" />
              </el-table>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-card>
  </div>
</template>

<script>
import { getTranslationStatisticsApi } from '@/api/translation';
import { merchantListApi } from '@/api/merchant';

export default {
  name: 'TranslationStatistics',
  data() {
    return {
      loading: false,
      selectedMerId: null,
      merchantList: [],
      statistics: {
        totalCount: 0,
        totalChars: 0,
        langStatistics: {},
        entityStatistics: {},
      },
    };
  },
  computed: {
    langStatisticsData() {
      const langMap = {
        en: '英文',
        fr: '法语',
        th: '泰语',
        lo: '老挝语',
        jp: '日语',
        kor: '韩语',
        ara: '阿拉伯语',
      };
      return Object.keys(this.statistics.langStatistics || {}).map((key) => ({
        language: langMap[key] || key,
        count: this.statistics.langStatistics[key],
      }));
    },
    entityStatisticsData() {
      const entityMap = {
        product: '商品',
        category: '分类',
        brand: '品牌',
      };
      return Object.keys(this.statistics.entityStatistics || {}).map((key) => ({
        entityType: entityMap[key] || key,
        count: this.statistics.entityStatistics[key],
      }));
    },
  },
  mounted() {
    this.loadMerchantList();
    this.getStatistics();
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
    handleMerchantChange() {
      this.getStatistics();
    },
    getStatistics() {
      this.loading = true;
      getTranslationStatisticsApi(this.selectedMerId ? { merId: this.selectedMerId } : {})
        .then((res) => {
          // 根据平台管理端的响应格式调整
          this.statistics = (res && res.data) || res || {};
          this.loading = false;
        })
        .catch((err) => {
          const errorMsg =
            (err && err.response && err.response.data && err.response.data.msg) ||
            (err && err.message) ||
            (err && err.msg) ||
            '获取统计信息失败';
          this.$message.error(errorMsg);
          this.loading = false;
        });
    },
  },
};
</script>

<style lang="scss" scoped>
.statistics-content {
  padding: 20px;
}

.stat-item {
  text-align: center;
  .stat-label {
    font-size: 14px;
    color: #606266;
    margin-bottom: 10px;
  }
  .stat-value {
    font-size: 32px;
    font-weight: bold;
    color: #303133;
  }
}
</style>















