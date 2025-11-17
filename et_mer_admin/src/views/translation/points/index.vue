<template>
  <div class="divBox">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <h3>翻译积分管理</h3>
          <el-button
            size="small"
            type="primary"
            icon="el-icon-refresh"
            style="float: right"
            @click="getPointsInfo"
            :loading="loading"
          >
            刷新
          </el-button>
        </div>
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
  </div>
</template>

<script>
import { getTranslationPointsApi } from '@/api/translation';

export default {
  name: 'TranslationPoints',
  data() {
    return {
      loading: false,
      pointsInfo: {
        totalChars: 0,
        usedChars: 0,
        remainingChars: 0,
        usageRate: 0,
        totalTranslations: 0,
      },
    };
  },
  computed: {
    progressColor() {
      const rate = this.pointsInfo.usageRate || 0;
      if (rate < 50) return '#67C23A';
      if (rate < 80) return '#E6A23C';
      return '#F56C6C';
    },
  },
  mounted() {
    this.getPointsInfo();
    
    // 监听翻译完成事件，自动刷新积分信息
    if (this.$bus) {
      this.$bus.$on('refresh-translation-points', () => {
        console.log('收到翻译完成事件，刷新积分信息');
        this.getPointsInfo();
      });
    }
    
    // 页面可见时自动刷新（防止用户切换标签页后回来数据过期）
    document.addEventListener('visibilitychange', () => {
      if (!document.hidden) {
        this.getPointsInfo();
      }
    });
  },
  beforeDestroy() {
    // 移除事件监听
    if (this.$bus) {
      this.$bus.$off('refresh-translation-points');
    }
  },
  methods: {
    getPointsInfo() {
      this.loading = true;
      getTranslationPointsApi()
        .then((res) => {
          // request.js 的响应拦截器已经返回了 res.data，所以这里直接使用 res
          // 添加调试日志
          console.log('获取积分信息响应:', res);
          
          // 处理不同的响应格式
          if (res && typeof res === 'object') {
            // 如果 res 直接就是数据对象
            this.pointsInfo = {
              totalChars: res.totalChars || 0,
              usedChars: res.usedChars || 0,
              remainingChars: res.remainingChars || 0,
              usageRate: res.usageRate || 0,
              totalTranslations: res.totalTranslations || 0,
            };
            console.log('解析后的积分信息:', this.pointsInfo);
          } else {
            // 如果格式不对，使用默认值
            this.pointsInfo = {
              totalChars: 0,
              usedChars: 0,
              remainingChars: 0,
              usageRate: 0,
              totalTranslations: 0,
            };
            console.warn('积分信息格式异常:', res);
          }
          this.loading = false;
        })
        .catch((err) => {
          const errorMsg =
            (err && err.response && err.response.data && err.response.data.msg) ||
            (err && err.message) ||
            (err && err.msg) ||
            '获取积分信息失败';
          console.error('获取积分信息失败:', err);
          this.$message.error(errorMsg);
          this.loading = false;
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


    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <h3>翻译积分管理</h3>
          <el-button
            size="small"
            type="primary"
            icon="el-icon-refresh"
            style="float: right"
            @click="getPointsInfo"
            :loading="loading"
          >
            刷新
          </el-button>
        </div>
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
  </div>
</template>

<script>
import { getTranslationPointsApi } from '@/api/translation';

export default {
  name: 'TranslationPoints',
  data() {
    return {
      loading: false,
      pointsInfo: {
        totalChars: 0,
        usedChars: 0,
        remainingChars: 0,
        usageRate: 0,
        totalTranslations: 0,
      },
    };
  },
  computed: {
    progressColor() {
      const rate = this.pointsInfo.usageRate || 0;
      if (rate < 50) return '#67C23A';
      if (rate < 80) return '#E6A23C';
      return '#F56C6C';
    },
  },
  mounted() {
    this.getPointsInfo();
    
    // 监听翻译完成事件，自动刷新积分信息
    if (this.$bus) {
      this.$bus.$on('refresh-translation-points', () => {
        console.log('收到翻译完成事件，刷新积分信息');
        this.getPointsInfo();
      });
    }
    
    // 页面可见时自动刷新（防止用户切换标签页后回来数据过期）
    document.addEventListener('visibilitychange', () => {
      if (!document.hidden) {
        this.getPointsInfo();
      }
    });
  },
  beforeDestroy() {
    // 移除事件监听
    if (this.$bus) {
      this.$bus.$off('refresh-translation-points');
    }
  },
  methods: {
    getPointsInfo() {
      this.loading = true;
      getTranslationPointsApi()
        .then((res) => {
          // request.js 的响应拦截器已经返回了 res.data，所以这里直接使用 res
          // 添加调试日志
          console.log('获取积分信息响应:', res);
          
          // 处理不同的响应格式
          if (res && typeof res === 'object') {
            // 如果 res 直接就是数据对象
            this.pointsInfo = {
              totalChars: res.totalChars || 0,
              usedChars: res.usedChars || 0,
              remainingChars: res.remainingChars || 0,
              usageRate: res.usageRate || 0,
              totalTranslations: res.totalTranslations || 0,
            };
            console.log('解析后的积分信息:', this.pointsInfo);
          } else {
            // 如果格式不对，使用默认值
            this.pointsInfo = {
              totalChars: 0,
              usedChars: 0,
              remainingChars: 0,
              usageRate: 0,
              totalTranslations: 0,
            };
            console.warn('积分信息格式异常:', res);
          }
          this.loading = false;
        })
        .catch((err) => {
          const errorMsg =
            (err && err.response && err.response.data && err.response.data.msg) ||
            (err && err.message) ||
            (err && err.msg) ||
            '获取积分信息失败';
          console.error('获取积分信息失败:', err);
          this.$message.error(errorMsg);
          this.loading = false;
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


















    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <h3>翻译积分管理</h3>
          <el-button
            size="small"
            type="primary"
            icon="el-icon-refresh"
            style="float: right"
            @click="getPointsInfo"
            :loading="loading"
          >
            刷新
          </el-button>
        </div>
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
  </div>
</template>

<script>
import { getTranslationPointsApi } from '@/api/translation';

export default {
  name: 'TranslationPoints',
  data() {
    return {
      loading: false,
      pointsInfo: {
        totalChars: 0,
        usedChars: 0,
        remainingChars: 0,
        usageRate: 0,
        totalTranslations: 0,
      },
    };
  },
  computed: {
    progressColor() {
      const rate = this.pointsInfo.usageRate || 0;
      if (rate < 50) return '#67C23A';
      if (rate < 80) return '#E6A23C';
      return '#F56C6C';
    },
  },
  mounted() {
    this.getPointsInfo();
    
    // 监听翻译完成事件，自动刷新积分信息
    if (this.$bus) {
      this.$bus.$on('refresh-translation-points', () => {
        console.log('收到翻译完成事件，刷新积分信息');
        this.getPointsInfo();
      });
    }
    
    // 页面可见时自动刷新（防止用户切换标签页后回来数据过期）
    document.addEventListener('visibilitychange', () => {
      if (!document.hidden) {
        this.getPointsInfo();
      }
    });
  },
  beforeDestroy() {
    // 移除事件监听
    if (this.$bus) {
      this.$bus.$off('refresh-translation-points');
    }
  },
  methods: {
    getPointsInfo() {
      this.loading = true;
      getTranslationPointsApi()
        .then((res) => {
          // request.js 的响应拦截器已经返回了 res.data，所以这里直接使用 res
          // 添加调试日志
          console.log('获取积分信息响应:', res);
          
          // 处理不同的响应格式
          if (res && typeof res === 'object') {
            // 如果 res 直接就是数据对象
            this.pointsInfo = {
              totalChars: res.totalChars || 0,
              usedChars: res.usedChars || 0,
              remainingChars: res.remainingChars || 0,
              usageRate: res.usageRate || 0,
              totalTranslations: res.totalTranslations || 0,
            };
            console.log('解析后的积分信息:', this.pointsInfo);
          } else {
            // 如果格式不对，使用默认值
            this.pointsInfo = {
              totalChars: 0,
              usedChars: 0,
              remainingChars: 0,
              usageRate: 0,
              totalTranslations: 0,
            };
            console.warn('积分信息格式异常:', res);
          }
          this.loading = false;
        })
        .catch((err) => {
          const errorMsg =
            (err && err.response && err.response.data && err.response.data.msg) ||
            (err && err.message) ||
            (err && err.msg) ||
            '获取积分信息失败';
          console.error('获取积分信息失败:', err);
          this.$message.error(errorMsg);
          this.loading = false;
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


    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div class="container">
          <h3>翻译积分管理</h3>
          <el-button
            size="small"
            type="primary"
            icon="el-icon-refresh"
            style="float: right"
            @click="getPointsInfo"
            :loading="loading"
          >
            刷新
          </el-button>
        </div>
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
  </div>
</template>

<script>
import { getTranslationPointsApi } from '@/api/translation';

export default {
  name: 'TranslationPoints',
  data() {
    return {
      loading: false,
      pointsInfo: {
        totalChars: 0,
        usedChars: 0,
        remainingChars: 0,
        usageRate: 0,
        totalTranslations: 0,
      },
    };
  },
  computed: {
    progressColor() {
      const rate = this.pointsInfo.usageRate || 0;
      if (rate < 50) return '#67C23A';
      if (rate < 80) return '#E6A23C';
      return '#F56C6C';
    },
  },
  mounted() {
    this.getPointsInfo();
    
    // 监听翻译完成事件，自动刷新积分信息
    if (this.$bus) {
      this.$bus.$on('refresh-translation-points', () => {
        console.log('收到翻译完成事件，刷新积分信息');
        this.getPointsInfo();
      });
    }
    
    // 页面可见时自动刷新（防止用户切换标签页后回来数据过期）
    document.addEventListener('visibilitychange', () => {
      if (!document.hidden) {
        this.getPointsInfo();
      }
    });
  },
  beforeDestroy() {
    // 移除事件监听
    if (this.$bus) {
      this.$bus.$off('refresh-translation-points');
    }
  },
  methods: {
    getPointsInfo() {
      this.loading = true;
      getTranslationPointsApi()
        .then((res) => {
          // request.js 的响应拦截器已经返回了 res.data，所以这里直接使用 res
          // 添加调试日志
          console.log('获取积分信息响应:', res);
          
          // 处理不同的响应格式
          if (res && typeof res === 'object') {
            // 如果 res 直接就是数据对象
            this.pointsInfo = {
              totalChars: res.totalChars || 0,
              usedChars: res.usedChars || 0,
              remainingChars: res.remainingChars || 0,
              usageRate: res.usageRate || 0,
              totalTranslations: res.totalTranslations || 0,
            };
            console.log('解析后的积分信息:', this.pointsInfo);
          } else {
            // 如果格式不对，使用默认值
            this.pointsInfo = {
              totalChars: 0,
              usedChars: 0,
              remainingChars: 0,
              usageRate: 0,
              totalTranslations: 0,
            };
            console.warn('积分信息格式异常:', res);
          }
          this.loading = false;
        })
        .catch((err) => {
          const errorMsg =
            (err && err.response && err.response.data && err.response.data.msg) ||
            (err && err.message) ||
            (err && err.msg) ||
            '获取积分信息失败';
          console.error('获取积分信息失败:', err);
          this.$message.error(errorMsg);
          this.loading = false;
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

























