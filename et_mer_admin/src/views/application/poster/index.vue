<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <el-form ref="form" inline :model="tableFrom">
            <el-form-item label="海报名称：">
              <el-input v-model="tableFrom.title" placeholder="请输入海报名称" class="selWidth" size="small" clearable>
                <el-button slot="append" size="small" icon="el-icon-search" @click="getList(1)" />
              </el-input>
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
        <el-table-column label="操作" min-width="200" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="downloadPoster(scope.row)" v-if="scope.row.posterImage">
              下载
            </el-button>
            <el-button type="text" size="small" @click="handleEdit(scope.row)">
              编辑
            </el-button>
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
import { posterListApi, deletePosterApi, updatePosterApi } from '@/api/poster'

export default {
  name: 'PosterIndex',
  data() {
    return {
      listLoading: false,
      tableFrom: {
        page: 1,
        limit: 20,
        title: ''
      },
      tableData: {
        list: [],
        total: 0,
        page: 1,
        limit: 20
      }
    }
  },
  
  created() {
    this.getList()
  },
  
  methods: {
    // 获取列表
    getList(page = this.tableFrom.page) {
      this.tableFrom.page = page
      this.listLoading = true
      posterListApi(this.tableFrom)
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
            // 如果是直接的分页数据
            this.tableData.list = res.list || []
            this.tableData.total = res.total || 0
            this.tableData.page = res.page || 1
            this.tableData.limit = res.limit || 20
          } else {
            // 如果直接就是列表数据
            this.tableData.list = Array.isArray(res) ? res : []
            this.tableData.total = Array.isArray(res) ? res.length : 0
          }
          console.log('处理后的海报列表数据:', this.tableData);
          this.listLoading = false
        })
        .catch(err => {
          console.error('获取海报列表失败:', err)
          this.listLoading = false
          this.$message.error('获取海报列表失败')
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
      this.tableFrom.title = ''
      this.getList(1)
    },
    
    // 新建海报
    handleCreate() {
      this.$router.push('/application/poster/create')
    },
    
    // 编辑海报
    handleEdit(row) {
      this.$router.push(`/application/poster/edit/${row.id}`)
    },
    
    // 删除海报
    handleDelete(row) {
      this.$confirm(`确定删除海报"${row.title}"吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        deletePosterApi(row.id).then(() => {
          this.$message.success('删除成功')
          this.getList()
        }).catch(err => {
          console.error('删除失败:', err)
          this.$message.error('删除失败')
        })
      })
    },
    
    // 下载海报
        // 处理图片URL，避免路径重复
        getImageUrl(url) {
          if (!url) return '';
          // 如果是完整的URL（包含http），直接返回
          if (url.startsWith('http://') || url.startsWith('https://')) {
            return url;
          }
          // 如果是相对路径，通过代理访问
          return url;
        },

        downloadPoster(row) {
      if (row.posterImage) {
        const link = document.createElement('a')
        link.href = this.getImageUrl(row.posterImage)
        link.download = `${row.title || '海报'}.png`
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
      }
    }
  }
}
</script>

<style scoped>
.poster-preview {
  display: flex;
  justify-content: center;
  align-items: center;
}

.no-image {
  color: #999;
  font-size: 12px;
  text-align: center;
}

.mb20 {
  margin-bottom: 20px;
}
</style>