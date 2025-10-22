<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <el-form ref="form" inline :model="tableFrom">
            <el-form-item label="海报名称：">
              <el-input v-model="tableFrom.keywords" placeholder="请输入海报名称" class="selWidth" size="small" clearable>
                <el-button slot="append" size="small" icon="el-icon-search" @click="getList(1)" />
              </el-input>
            </el-form-item>
            <el-form-item label="商户：">
              <el-select v-model="tableFrom.merId" placeholder="请选择商户" class="selWidth" size="small" clearable>
                <el-option
                  v-for="merchant in merchantList"
                  :key="merchant.id"
                  :label="merchant.merchantName || merchant.merName || merchant.name || `商户${merchant.id}`"
                  :value="merchant.id">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button size="small" @click="resetForm">重置</el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
      <el-button type="primary" size="small" @click="handleCreate" class="mb20">
        <i class="el-icon-plus"></i> 生成海报
      </el-button>
      <el-table v-loading="listLoading" :data="tableData.list" :header-cell-style="{ fontWeight: 'bold' }">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column label="海报标题" min-width="150" prop="title" />
        <el-table-column label="类型" min-width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.type === 'product' ? 'success' : 'info'">
              {{ scope.row.type === 'product' ? '商品海报' : '基础海报' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" min-width="160" prop="createTime" />
        <el-table-column label="操作" min-width="100" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleDelete(scope.row)" style="color: #f56c6c;">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="block-pagination">
        <el-pagination
          :page-sizes="[10, 20, 50, 100]"
          :page-size="tableData.limit"
          :current-page="tableData.page"
          layout="total, sizes, prev, pager, next, jumper"
          :total="tableData.total"
          @current-change="pageChange"
          @size-change="handleSizeChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script>
import { platformPosterListApi, deletePlatformPosterApi } from '@/api/poster'
import { merchantListApi } from '@/api/merchant'

export default {
  name: 'PlatformPosterIndex',
  data() {
    return {
      listLoading: false,
      tableFrom: {
        page: 1,
        limit: 20,
        keywords: '',
        merId: ''
      },
      tableData: {
        list: [],
        total: 0,
        page: 1,
        limit: 20
      },
      merchantList: []
    }
  },
  
  created() {
    this.loadMerchants()
    this.getList()
  },
  
  methods: {
    // 加载商户列表
    async loadMerchants() {
      try {
        console.log('开始调用商户API...');
        const res = await merchantListApi({ page: 1, limit: 1000 })
        console.log('商户API响应:', res);
        console.log('响应类型:', typeof res);
        console.log('res.data:', res && res.data);
        console.log('res.data.list:', res && res.data && res.data.list);
        
        // 尝试不同的响应格式
        if (res && res.data && Array.isArray(res.data.list)) {
          this.merchantList = res.data.list;
          console.log('使用格式: res.data.list');
        } else if (res && res.data && Array.isArray(res.data)) {
          this.merchantList = res.data;
          console.log('使用格式: res.data');
        } else if (res && Array.isArray(res)) {
          this.merchantList = res;
          console.log('使用格式: res');
        } else {
          console.error('无法解析商户数据:', res);
          this.merchantList = [];
        }
        console.log('最终商户列表:', this.merchantList);
        console.log('商户数量:', this.merchantList.length);
      } catch (error) {
        console.error('加载商户列表失败:', error)
        console.error('错误详情:', error.response || error.message || error);
        this.$message.error('加载商户列表失败: ' + (error.message || '网络错误'))
      }
    },

    // 获取列表
    getList(page = this.tableFrom.page) {
      this.tableFrom.page = page
      this.listLoading = true
      platformPosterListApi(this.tableFrom)
        .then(res => {
          console.log('海报列表API响应:', res);
          // 处理PageInfo格式的响应
          if (res && res.data) {
            // 如果是CommonResult包装的PageInfo
            const pageInfo = res.data;
            this.tableData.list = pageInfo.list || []
            this.tableData.total = pageInfo.total || 0
            this.tableData.page = pageInfo.pageNum || 1
            this.tableData.limit = pageInfo.pageSize || 20
          } else if (res && res.list) {
            // 直接是PageInfo格式
            this.tableData.list = res.list || []
            this.tableData.total = res.total || 0
            this.tableData.page = res.pageNum || 1
            this.tableData.limit = res.pageSize || 20
          } else {
            console.error('无法解析海报列表数据:', res)
            this.tableData.list = []
            this.tableData.total = 0
          }
          console.log('最终海报列表:', this.tableData.list);
        })
        .catch(err => {
          console.error('获取海报列表失败:', err)
          this.$message.error('获取海报列表失败')
        })
        .finally(() => {
          this.listLoading = false
        })
    },
    
    // 分页
    pageChange(page) {
      this.getList(page)
    },
    
    handleSizeChange(size) {
      this.tableFrom.limit = size
      this.getList(1)
    },
    
    // 重置搜索
    resetForm() {
      this.tableFrom.keywords = ''
      this.tableFrom.merId = ''
      this.getList(1)
    },
    
    // 新建海报
    handleCreate() {
      this.$router.push('/poster/create')
    },
    
    // 删除海报
    handleDelete(row) {
      this.$confirm('确定要删除这个海报吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        deletePlatformPosterApi(row.id).then(() => {
          this.$message.success('删除成功')
          this.getList()
        }).catch(err => {
          console.error('删除失败:', err)
          this.$message.error('删除失败')
        })
      })
    },
    
    // 处理图片URL，避免路径重复
    getImageUrl(url) {
      if (!url) return '';
      // 如果已经是完整URL，直接返回
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return url;
      }
      // 如果已经包含baseURL，避免重复
      if (url.includes(process.env.VUE_APP_API_URL)) {
        return url;
      }
      return `${process.env.VUE_APP_API_URL}/${url}`;
    }
  }
}
</script>

<style scoped>
.divBox {
  padding: 20px;
}

.container {
  margin-bottom: 20px;
}

.selWidth {
  width: 200px;
}

.mb20 {
  margin-bottom: 20px;
}

.block-pagination {
  margin-top: 20px;
  text-align: right;
}
</style>

