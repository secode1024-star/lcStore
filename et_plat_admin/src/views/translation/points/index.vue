<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <h3>翻译积分管理</h3>
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
          <el-button size="small" type="primary" icon="el-icon-search" @click="getPointsInfo">查询</el-button>
          <el-button 
            size="small" 
            type="success" 
            icon="el-icon-plus" 
            :disabled="!selectedMerId"
            @click="showAddPointsDialog"
            style="margin-left: 10px"
          >添加积分</el-button>
          <el-button 
            size="small" 
            type="info" 
            icon="el-icon-refresh" 
            @click="getPointsInfo"
            style="margin-left: 10px"
          >刷新</el-button>
        </el-form>
      </div>
      <div v-loading="loading" class="points-info">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-card shadow="hover" class="info-card">
              <div class="info-item">
                <div class="info-label">总字符数</div>
                <div class="info-value">{{ pointsInfo.totalChars || 0 }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover" class="info-card">
              <div class="info-item">
                <div class="info-label">已使用</div>
                <div class="info-value">{{ pointsInfo.usedChars || 0 }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover" class="info-card">
              <div class="info-item">
                <div class="info-label">剩余可用</div>
                <div class="info-value">{{ pointsInfo.remainingChars || 0 }}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="hover" class="info-card">
              <div class="info-item">
                <div class="info-label">使用率</div>
                <div class="info-value">{{ pointsInfo.usageRate || 0 }}%</div>
              </div>
            </el-card>
          </el-col>
        </el-row>
        <el-row :gutter="20" style="margin-top: 20px">
          <el-col :span="12">
            <el-card shadow="hover">
              <div class="info-item">
                <div class="info-label">累计翻译次数</div>
                <div class="info-value">{{ pointsInfo.totalTranslations || 0 }}</div>
              </div>
            </el-card>
          </el-col>
        </el-row>
        <el-progress
          :percentage="pointsInfo.usageRate || 0"
          :color="progressColor"
          :stroke-width="20"
          style="margin-top: 30px"
        />
      </div>
    </el-card>

    <!-- 添加积分对话框 -->
    <el-dialog
      title="添加翻译积分"
      :visible.sync="addPointsDialogVisible"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form label-width="120px" :model="addPointsForm" :rules="addPointsRules" ref="addPointsForm">
        <el-form-item label="商户名称：">
          <el-input :value="selectedMerchantName" disabled />
        </el-form-item>
        <el-form-item label="积分数量：" prop="points">
          <el-input-number
            v-model="addPointsForm.points"
            :min="1"
            :max="10000"
            :precision="0"
            style="width: 100%"
            placeholder="请输入积分数量"
          />
          <div style="margin-top: 5px; color: #909399; font-size: 12px">
            <p>• 积分规则：1积分 = 10,000字符</p>
            <p>• 添加 {{ addPointsForm.points || 0 }} 积分 = {{ (addPointsForm.points || 0) * 10000 }} 字符</p>
          </div>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addPointsDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="addingPoints" @click="handleAddPoints">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getTranslationPointsApi, addMerchantTranslationPointsApi } from '@/api/translation';
import { merchantListApi } from '@/api/merchant';

export default {
  name: 'TranslationPoints',
  data() {
    return {
      loading: false,
      selectedMerId: null,
      merchantList: [],
      pointsInfo: {
        totalChars: 0,
        usedChars: 0,
        remainingChars: 0,
        usageRate: 0,
        totalTranslations: 0,
      },
      // 添加积分相关
      addPointsDialogVisible: false,
      addingPoints: false,
      addPointsForm: {
        points: 100, // 默认100积分
      },
      addPointsRules: {
        points: [
          { required: true, message: '请输入积分数量', trigger: 'blur' },
          { type: 'number', min: 1, max: 10000, message: '积分数量必须在1-10000之间', trigger: 'blur' },
        ],
      },
    };
  },
  computed: {
    selectedMerchantName() {
      if (!this.selectedMerId) return '';
      const merchant = this.merchantList.find(m => m.id === this.selectedMerId);
      return merchant ? merchant.name : '';
    },
    progressColor() {
      const rate = this.pointsInfo.usageRate || 0;
      if (rate < 50) return '#67C23A';
      if (rate < 80) return '#E6A23C';
      return '#F56C6C';
    },
  },
  mounted() {
    this.loadMerchantList();
    // 不自动调用 getPointsInfo，避免显示错误提示
    // this.getPointsInfo();
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
      this.getPointsInfo();
    },
    getPointsInfo() {
      // 如果没有选择商户，不显示错误，只显示空数据
      if (!this.selectedMerId) {
        this.pointsInfo = {
          totalChars: 0,
          usedChars: 0,
          remainingChars: 0,
          usageRate: 0,
          totalTranslations: 0,
        };
        return;
      }
      
      this.loading = true;
      getTranslationPointsApi(this.selectedMerId)
        .then((res) => {
          // 根据平台管理端的响应格式调整
          this.pointsInfo = (res && res.data) || res || {};
          this.loading = false;
        })
        .catch((err) => {
          // 如果没有选择商户，不显示错误提示
          const errorMsg =
            (err && err.response && err.response.data && err.response.data.msg) ||
            (err && err.message) ||
            (err && err.msg);
          
          // 只有在非"请指定商户ID"错误时才显示错误提示
          if (errorMsg && !errorMsg.includes('请指定商户ID')) {
            this.$message.error(errorMsg || '获取积分信息失败');
          }
          
          // 即使出错也重置为空数据
          this.pointsInfo = {
            totalChars: 0,
            usedChars: 0,
            remainingChars: 0,
            usageRate: 0,
            totalTranslations: 0,
          };
          this.loading = false;
        });
    },
    showAddPointsDialog() {
      if (!this.selectedMerId) {
        this.$message.warning('请先选择商户');
        return;
      }
      this.addPointsForm.points = 100; // 重置为默认值
      this.addPointsDialogVisible = true;
    },
    handleAddPoints() {
      this.$refs.addPointsForm.validate((valid) => {
        if (!valid) {
          return false;
        }
        
        if (!this.selectedMerId) {
          this.$message.warning('请先选择商户');
          return;
        }
        
        this.addingPoints = true;
        
        addMerchantTranslationPointsApi({
          merId: this.selectedMerId,
          points: this.addPointsForm.points,
        })
          .then((res) => {
            this.$message.success(res.msg || '添加积分成功');
            this.addPointsDialogVisible = false;
            // 刷新积分信息
            this.getPointsInfo();
          })
          .catch((err) => {
            const errorMsg =
              (err && err.response && err.response.data && err.response.data.msg) ||
              (err && err.message) ||
              (err && err.msg) ||
              '添加积分失败';
            this.$message.error(errorMsg);
          })
          .finally(() => {
            this.addingPoints = false;
          });
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.points-info {
  padding: 20px;
}

.info-card {
  text-align: center;
}

.info-item {
  .info-label {
    font-size: 14px;
    color: #606266;
    margin-bottom: 10px;
  }
  .info-value {
    font-size: 28px;
    font-weight: bold;
    color: #303133;
  }
}
</style>


















