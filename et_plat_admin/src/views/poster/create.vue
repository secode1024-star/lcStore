<template>
  <div class="app-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #e4e7ed;">
      <div>
        <h3 style="margin: 0 0 5px 0; font-size: 18px; font-weight: 600;">创建海报</h3>
        <p style="margin: 0; color: #909399; font-size: 14px;">选择商户和商品并配置海报样式，生成专属推广海报</p>
      </div>
      <div>
        <el-button @click="$router.push('/poster')">返回列表</el-button>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div style="display: flex; gap: 20px; align-items: flex-start;">
      <!-- 左侧配置面板 -->
      <div style="flex: 1; min-width: 0;">
        <el-form ref="posterForm" :model="posterConfig" :rules="rules" label-width="120px">
      <el-card class="box-card" shadow="never">
        <div slot="header">
          <span>基础信息</span>
        </div>

        <el-form-item label="选择商户" prop="merId">
          <el-select v-model="posterConfig.merId" placeholder="请选择商户" style="width: 100%;" @change="handleMerchantChange">
            <el-option
              v-for="merchant in merchantList"
              :key="merchant.id"
              :label="merchant.merchantName || merchant.merName || merchant.name || `商户${merchant.id}`"
              :value="merchant.id">
            </el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="海报标题" prop="title">
          <el-input v-model="posterConfig.title" placeholder="请输入海报标题" />
        </el-form-item>

        <el-form-item label="选择商品">
          <el-button @click="showProductDialog = true" :disabled="!posterConfig.merId">选择商品</el-button>
          <div v-if="selectedProducts.length > 0" style="margin-top: 10px;">
            <el-tag v-if="selectedProducts.length === 1" type="success">
              已选择：{{ selectedProducts[0].storeName }}
            </el-tag>
            <el-tag v-else type="success">
              已选择 {{ selectedProducts.length }} 个商品（批量生成模式）
            </el-tag>
          </div>
          <div v-if="!posterConfig.merId" style="color: #909399; font-size: 12px; margin-top: 5px;">
            请先选择商户
          </div>
          <div v-if="posterConfig.merId && selectedProducts.length === 0" style="color: #909399; font-size: 12px; margin-top: 5px;">
            请点击按钮选择商品，支持单选或多选
          </div>
        </el-form-item>
      </el-card>

      <el-card class="box-card" shadow="never" style="margin-top: 20px">
        <div slot="header">
          <span>海报设置</span>
        </div>

        <el-form-item label="海报尺寸">
          <el-tag>750 × 1334 px (固定尺寸)</el-tag>
        </el-form-item>

        <el-form-item label="背景颜色">
          <el-color-picker v-model="posterConfig.backgroundColor" />
        </el-form-item>

      </el-card>

      <div style="margin-top: 20px; text-align: center;">
        <el-button type="primary" @click="submitForm" :loading="submitting" :disabled="!canGenerate">
          {{ getGenerateButtonText() }}
        </el-button>
        <el-button @click="generatePreview" v-if="selectedProducts.length === 1">预览海报</el-button>
          </div>
        </el-form>
      </div>

      <!-- 右侧预览区域 -->
      <div style="width: 400px; flex-shrink: 0;">
        <el-card class="box-card" shadow="never">
          <div slot="header">
            <span>海报预览</span>
          </div>
          <div style="text-align: center; background: #f5f5f5; padding: 20px; border-radius: 8px;">
            <canvas
              ref="posterCanvas"
              :width="posterConfig.width"
              :height="posterConfig.height"
              style="max-width: 100%; height: auto; border: 1px solid #ddd; background: white;">
            </canvas>
          </div>
        </el-card>
      </div>
    </div>

    <!-- 商品选择对话框 -->
    <el-dialog title="选择商品" :visible.sync="showProductDialog" width="80%" :close-on-click-modal="false">
      <div style="margin-bottom: 20px;">
        <el-input
          v-model="productSearch"
          placeholder="搜索商品名称..."
          prefix-icon="el-icon-search"
          style="width: 300px;"
          @input="handleProductSearch"
        />
      </div>

      <el-table
        :data="productList"
        v-loading="productLoading"
        @selection-change="handleProductSelection"
        style="width: 100%"
        max-height="400px"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column label="商品图片" width="100">
          <template slot-scope="scope">
            <img :src="getImageUrl(scope.row.image)" style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px;" 
                 @error="handleImageError($event, scope.row.image)"
                 @load="handleImageLoad($event, scope.row.image)"
                 alt="商品图片" />
          </template>
        </el-table-column>
        <el-table-column prop="storeName" label="商品名称" show-overflow-tooltip />
        <el-table-column prop="price" label="价格" width="100">
          <template slot-scope="scope">
            <span style="color: #f56c6c; font-weight: bold;">¥{{ scope.row.price }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="stock" label="库存" width="80" />
        <el-table-column prop="sales" label="销量" width="80" />
      </el-table>

      <div style="margin-top: 20px; text-align: center;">
        <el-pagination
          :current-page="pagination.page"
          :page-size="pagination.limit"
          :total="pagination.total"
          @current-change="handleProductPageChange"
          layout="prev, pager, next"
          small
        />
      </div>

      <div slot="footer" class="dialog-footer">
        <el-button @click="showProductDialog = false">取消</el-button>
        <el-button type="primary" @click="confirmProductSelection" :disabled="selectedProducts.length === 0">
          确定选择 ({{ selectedProducts.length }}个商品)
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { createPlatformPosterApi } from '@/api/poster'
import { merchantListApi } from '@/api/merchant'
import { productLstApi } from '@/api/store'
import request from '@/utils/request'

export default {
  name: 'CreatePlatformPoster',
  data() {
    return {
      submitting: false,
      batchProgress: {
        current: 0,
        total: 0,
        processing: false
      },
      posterConfig: {
        merId: null,
        title: '',
        type: 'product',
        productId: null,
        width: 750,
        height: 1334,
        backgroundColor: '#ffffff',
        qrCodeContent: '',
        qrCodeSize: 120
      },
      selectedProduct: null,
      selectedProducts: [],
      showProductDialog: false,
      productList: [],
      productLoading: false,
      productSearch: '',
      searchTimer: null,
      pagination: {
        page: 1,
        limit: 20,
        total: 0
      },
      merchantList: [],
      previewTimer: null,
      rules: {
        merId: [{ required: true, message: '请选择商户', trigger: 'change' }],
        title: [
          { 
            required: true, 
            message: '请输入海报标题', 
            trigger: 'blur',
            validator: (rule, value, callback) => {
              if (this.selectedProducts.length > 1) {
                // 批量模式下不需要验证标题，因为会自动使用商品名称
                callback();
              } else if (!value) {
                callback(new Error('请输入海报标题'));
              } else {
                callback();
              }
            }
          }
        ]
      },
    };
  },
  mounted() {
    this.loadMerchants();
    this.generatePreview();
  },
  computed: {
    canGenerate() {
      return this.posterConfig.merId && this.selectedProducts.length > 0;
    }
  },
  watch: {
    posterConfig: {
      handler() {
        this.generatePreview();
      },
      deep: true
    },
    selectedProduct: {
      handler() {
        this.generatePreview();
      },
      deep: true
    }
  },
  methods: {
    // 加载商户列表
    async loadMerchants() {
      try {
        console.log('开始调用商户API...');
        const res = await merchantListApi()
        console.log('商户API响应:', res);
        console.log('响应类型:', typeof res);
        console.log('res.data:', res && res.data);
        console.log('res.data.list:', res && res.data && res.data.list);
        
        // 尝试不同的响应格式
        if (res && res.data && Array.isArray(res.data.list)) {
          this.merchantList = res.data.list
          console.log('使用格式: res.data.list');
        } else if (res && res.data && Array.isArray(res.data)) {
          this.merchantList = res.data
          console.log('使用格式: res.data');
        } else if (res && Array.isArray(res.list)) {
          this.merchantList = res.list
          console.log('使用格式: res.list');
        } else if (Array.isArray(res)) {
          this.merchantList = res
          console.log('使用格式: res');
        } else {
          this.merchantList = []
          console.log('无法解析，设置空数组');
        }
        console.log('处理后的商户列表:', this.merchantList);
        console.log('商户数量:', this.merchantList.length);
      } catch (error) {
        console.error('加载商户列表失败:', error)
        console.error('错误详情:', error.response || error.message || error);
        this.$message.error('加载商户列表失败: ' + (error.message || '网络错误'))
      }
    },

    // 商户变更处理
    handleMerchantChange(merId) {
      this.selectedProduct = null;
      this.selectedProducts = [];
      this.posterConfig.productId = null;
      if (merId) {
        this.loadProducts();
      }
    },


    // 获取生成按钮文本
    getGenerateButtonText() {
      if (this.submitting) {
        if (this.selectedProducts.length > 1 && this.batchProgress.processing) {
          return `批量生成中... (${this.batchProgress.current}/${this.batchProgress.total})`;
        }
        return '生成中...';
      }
      
      if (this.selectedProducts.length === 1) {
        return '生成海报';
      } else if (this.selectedProducts.length > 1) {
        return `批量生成海报 (${this.selectedProducts.length}个商品)`;
      } else {
        return '生成海报';
      }
    },

    async submitForm() {
      try {
        const valid = await this.$refs.posterForm.validate();
        if (!valid) return;

        if (this.selectedProducts.length === 1) {
          await this.generateSinglePoster();
        } else if (this.selectedProducts.length > 1) {
          await this.generateBatchPosters();
        } else {
          this.$message.warning('请先选择商品');
        }
        
      } catch (error) {
        console.error('生成海报失败:', error);
        const errorMessage = error && error.message ? error.message : '未知错误';
        this.$message.error('生成海报失败: ' + errorMessage);
        this.submitting = false;
        this.batchProgress.processing = false;
      }
    },

    // 生成单个海报
    async generateSinglePoster() {
      if (this.selectedProducts.length !== 1) {
        this.$message.warning('请先选择一个商品');
        return;
      }

      // 设置当前选中的商品
      this.selectedProduct = this.selectedProducts[0];
      this.posterConfig.productId = this.selectedProduct.id;

      let loading = null;
      try {
        this.submitting = true;
        loading = this.$loading({
          lock: true,
          text: '正在生成海报...',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)'
        });

        console.log('开始生成单个海报，配置:', this.posterConfig);
        console.log('选中的商品:', this.selectedProduct);

        const imageUrl = await this.generatePosterImage();
        console.log('海报生成完成，图片URL:', imageUrl);

        if (imageUrl) {
          // 保存海报记录到数据库
          await this.savePosterRecord(imageUrl);
          this.$message.success('海报生成成功！');
          this.$router.push('/poster');
        } else {
          throw new Error('图片生成失败');
        }
        
      } finally {
        this.submitting = false;
        if (loading) {
          loading.close();
        }
      }
    },

    // 批量生成海报
    async generateBatchPosters() {
      if (this.selectedProducts.length <= 1) {
        this.$message.warning('批量生成需要选择多个商品');
        return;
      }

      let loading = null;
      try {
        this.submitting = true;
        this.batchProgress.processing = true;
        this.batchProgress.current = 0;
        this.batchProgress.total = this.selectedProducts.length;

        loading = this.$loading({
          lock: true,
          text: `正在批量生成海报... (0/${this.selectedProducts.length})`,
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)'
        });

        console.log('开始批量生成海报，商品数量:', this.selectedProducts.length);

        let successCount = 0;
        let failCount = 0;

        for (let i = 0; i < this.selectedProducts.length; i++) {
          const product = this.selectedProducts[i];
          this.batchProgress.current = i + 1;
          
          // 更新loading文本
          loading.setText(`正在批量生成海报... (${this.batchProgress.current}/${this.batchProgress.total})`);
          
          try {
            console.log(`正在生成第${i + 1}个商品的海报:`, product.storeName);
            
            // 设置当前商品为选中商品
            this.selectedProduct = product;
            this.posterConfig.productId = product.id;
            this.posterConfig.title = product.storeName; // 使用商品名称作为海报标题
            
            // 生成海报图片
            const imageUrl = await this.generatePosterImage();
            
            if (imageUrl) {
              // 保存海报记录到数据库
              await this.savePosterRecord(imageUrl);
              successCount++;
              console.log(`第${i + 1}个商品海报生成成功:`, product.storeName);
            } else {
              throw new Error('图片生成失败');
            }
            
            // 添加短暂延迟，避免请求过于频繁
            if (i < this.selectedProducts.length - 1) {
              await new Promise(resolve => setTimeout(resolve, 300));
            }
            
          } catch (error) {
            console.error(`第${i + 1}个商品海报生成失败:`, product.storeName, error);
            failCount++;
          }
        }

        // 显示批量生成结果
        if (failCount === 0) {
          this.$message.success(`批量生成完成！成功生成 ${successCount} 个商品海报`);
        } else {
          this.$message.warning(`批量生成完成！成功 ${successCount} 个，失败 ${failCount} 个`);
        }
        
        console.log('批量生成海报流程完成，成功:', successCount, '失败:', failCount);
        
        // 批量生成完成后跳转到列表页
        this.$router.push('/poster');
        
      } finally {
        this.submitting = false;
        this.batchProgress.processing = false;
        this.batchProgress.current = 0;
        this.batchProgress.total = 0;
        if (loading) {
          loading.close();
        }
      }
    },

    async generatePosterImage() {
      console.log('🚀 开始生成海报图片...');
      
      // 使用多种策略尝试生成海报
      const strategies = [
        { name: '主要策略', method: () => this.generatePosterFromPreview() },
        { name: '干净Canvas策略', method: () => this.generateCleanPoster() },
        { name: '占位符策略', method: () => this.generateFallbackPoster() }
      ];
      
      for (let i = 0; i < strategies.length; i++) {
        const strategy = strategies[i];
        try {
          console.log(`🔄 尝试${strategy.name}...`);
          const posterImageUrl = await strategy.method();
          if (posterImageUrl) {
            console.log(`✅ ${strategy.name}成功生成海报:`, posterImageUrl);
            return posterImageUrl;
          }
        } catch (error) {
          console.error(`❌ ${strategy.name}失败:`, error);
          if (i === strategies.length - 1) {
            // 所有策略都失败了
            throw new Error(`海报生成失败: 所有策略都失败了。最后错误: ${error.message}`);
          }
          // 继续尝试下一个策略
          continue;
        }
      }
      
      throw new Error('海报生成失败: 所有策略都未能生成有效的海报');
    },

    // 使用和预览相同的逻辑生成海报
    async generatePosterFromPreview() {
      // 创建一个新的Canvas，使用和预览相同的尺寸
      const saveCanvas = document.createElement('canvas');
      saveCanvas.width = 750;
      saveCanvas.height = 1334;
      const saveCtx = saveCanvas.getContext('2d');
      
      try {
        // 使用和预览完全相同的绘制逻辑
        if (this.posterConfig.type === 'product') {
          await this.drawProductPosterForSave(saveCtx, saveCanvas);
        } else {
          this.drawBasicPosterForSave(saveCtx, saveCanvas);
        }

        // 导出海报
        return new Promise((resolve, reject) => {
          saveCanvas.toBlob(async (blob) => {
            try {
              if (!blob) {
                throw new Error('海报转换为Blob失败');
              }
              const imageUrl = await this.uploadPosterBlob(blob);
              resolve(imageUrl);
            } catch (error) {
              reject(error);
            }
          }, 'image/png', 0.9);
        });

      } catch (error) {
        throw error;
      }
    },

    // 🔥 为保存绘制商品海报（不使用跨域图片，避免Canvas污染）
    async drawProductPosterForSave(ctx, canvas) {
      console.log('开始绘制保存用商品海报（无污染版本）...');
      console.log('当前选中的商品:', this.selectedProduct);
      
      if (!this.selectedProduct) {
        // 绘制空状态提示
        ctx.fillStyle = '#999999';
        ctx.font = 'bold 24px Arial';
        ctx.textAlign = 'center';
        ctx.fillText('请先选择商品', canvas.width / 2, canvas.height / 2);
        return;
      }
      
      // 🔥 使用和预览相同的布局
      const layout = {
        // 顶部文字区域
        headerText: { x: 0, y: 0, width: 750, height: 60 },
        // 商品图片区域（占满宽度）
        productImage: { x: 0, y: 60, width: 750, height: 740 },
        // 下半部分 - 商品信息区域
        infoArea: { x: 0, y: 800, width: 750, height: 534 }
      };

      try {
        // 设置背景色
        ctx.fillStyle = this.posterConfig.backgroundColor;
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        // 1. 绘制顶部文字
        this.drawHeaderText(ctx, layout.headerText);

        // 2. 🔥 绘制商品图片（使用完全隔离的临时Canvas策略）
        console.log('🔍 检查商品数据:', {
          hasSelectedProduct: !!this.selectedProduct,
          selectedProduct: this.selectedProduct,
          hasImage: this.selectedProduct ? !!this.selectedProduct.image : false,
          imageValue: this.selectedProduct ? this.selectedProduct.image : null
        });
        
        if (this.selectedProduct && this.selectedProduct.image) {
          console.log('🖼️ 保存Canvas绘制真实商品图片（完全隔离策略）:', this.selectedProduct.image);
          await this.drawImageWithCompleteIsolation(ctx, this.selectedProduct.image, 
            layout.productImage.x, layout.productImage.y, 
            layout.productImage.width, layout.productImage.height);
        } else {
          console.log('❌ 商品图片不存在，绘制信息区域');
          console.log('❌ 原因分析:', {
            noSelectedProduct: !this.selectedProduct,
            noImage: this.selectedProduct && !this.selectedProduct.image,
            imageValue: this.selectedProduct ? this.selectedProduct.image : 'no product'
          });
          this.drawProductInfoArea(ctx, layout.productImage);
        }

        // 3. 绘制下半部分商品信息和二维码
        await this.drawInfoSection(ctx, layout.infoArea);

      } catch (error) {
        console.error('绘制保存用商品海报失败:', error);
      }
      
      console.log('保存用商品海报绘制完成（无污染版本）');
    },

    // 🔥 使用CORS配置直接加载跨域图片（服务器已配置CORS头）
    async drawImageWithCompleteIsolation(ctx, imageUrl, x, y, width, height) {
      return new Promise((resolve) => {
        // 处理图片URL
        let processedUrl = imageUrl;
        if (imageUrl && !imageUrl.startsWith('http')) {
          const apiBaseUrl = process.env.NODE_ENV === 'production' 
            ? 'https://api1.hqlccn.com'
            : 'http://localhost:20008';
          
          if (imageUrl.startsWith('/')) {
            processedUrl = `${apiBaseUrl}${imageUrl}`;
          } else if (imageUrl.startsWith('crmebimage/')) {
            processedUrl = `${apiBaseUrl}/${imageUrl}`;
          }
        }
        
        // 创建图片对象
        const img = new Image();
        
        img.onload = () => {
          try {
            // 计算如何填满指定区域（保持比例）
            const aspectRatio = img.width / img.height;
            const targetAspectRatio = width / height;
            
            let sourceX = 0, sourceY = 0, sourceWidth = img.width, sourceHeight = img.height;
            
            if (aspectRatio > targetAspectRatio) {
              sourceWidth = img.height * targetAspectRatio;
              sourceX = (img.width - sourceWidth) / 2;
            } else if (aspectRatio < targetAspectRatio) {
              sourceHeight = img.width / targetAspectRatio;
              sourceY = (img.height - sourceHeight) / 2;
            }
            
            // 直接绘制CORS图片到主Canvas
            ctx.drawImage(
              img,
              sourceX, sourceY, sourceWidth, sourceHeight,
              x, y, width, height
            );
            
            resolve();
            
          } catch (error) {
            console.error('图片绘制失败:', error);
            this.drawProductInfoArea(ctx, { x, y, width, height });
            resolve();
          }
        };
        
        img.onerror = (error) => {
          // 尝试转换为Base64避免污染
          this.convertImageToBase64ViaProxy(processedUrl)
            .then(base64ImageSrc => {
              if (base64ImageSrc) {
                const base64Img = new Image();
                base64Img.onload = function() {
                  try {
                    // 计算如何填满指定区域（保持比例）
                    const aspectRatio = base64Img.width / base64Img.height;
                    const targetAspectRatio = width / height;
                    
                    let sourceX = 0, sourceY = 0, sourceWidth = base64Img.width, sourceHeight = base64Img.height;
                    
                    if (aspectRatio > targetAspectRatio) {
                      sourceWidth = base64Img.height * targetAspectRatio;
                      sourceX = (base64Img.width - sourceWidth) / 2;
                    } else if (aspectRatio < targetAspectRatio) {
                      sourceHeight = base64Img.width / targetAspectRatio;
                      sourceY = (base64Img.height - sourceHeight) / 2;
                    }
                    
                    // 绘制Base64图片到主Canvas
                    ctx.drawImage(
                      base64Img,
                      sourceX, sourceY, sourceWidth, sourceHeight,
                      x, y, width, height
                    );
                    
                    resolve();
                  } catch (error) {
                    this.drawProductInfoArea(ctx, { x, y, width, height });
                    resolve();
                  }
                }.bind(this);
                base64Img.onerror = function() {
                  this.drawProductInfoArea(ctx, { x, y, width, height });
                  resolve();
                }.bind(this);
                base64Img.src = base64ImageSrc;
              } else {
                this.drawProductInfoArea(ctx, { x, y, width, height });
                resolve();
              }
            })
            .catch(base64Error => {
              this.drawProductInfoArea(ctx, { x, y, width, height });
              resolve();
            });
        };
        
        // 🔥 设置crossOrigin以启用CORS（服务器必须支持）
        img.crossOrigin = 'anonymous';
        
        // 重要：延迟设置src确保crossOrigin已设置
        setTimeout(() => {
          img.src = processedUrl + '?v=' + Math.random();
        }, 0);
      });
    },

    // 🔥 使用和二维码相同的临时Canvas策略绘制图片
    async drawImageViaBackend(ctx, imageUrl, x, y, width, height) {
      try {
        console.log('🔄 使用临时Canvas策略绘制商品图片:', imageUrl);
        
        // 处理图片URL
        let processedUrl = imageUrl;
        if (imageUrl && !imageUrl.startsWith('http')) {
          const apiBaseUrl = process.env.NODE_ENV === 'production' 
            ? 'https://api1.hqlccn.com'
            : 'http://localhost:20008';
          
          if (imageUrl.startsWith('/')) {
            processedUrl = `${apiBaseUrl}${imageUrl}`;
          } else if (imageUrl.startsWith('crmebimage/')) {
            processedUrl = `${apiBaseUrl}/${imageUrl}`;
          }
        }
        
        // 🔥 使用和qrcodejs2相同的策略：临时Canvas
        await this.drawImageViaTemporaryCanvas(ctx, processedUrl, x, y, width, height);
        
      } catch (error) {
        console.error('❌ 临时Canvas图片绘制失败:', error);
        this.drawProductInfoArea(ctx, { x, y, width, height });
      }
    },

    // 🔥 使用临时Canvas绘制图片（和qrcodejs2相同策略）
    async drawImageViaTemporaryCanvas(ctx, imageUrl, x, y, width, height) {
      return new Promise((resolve) => {
        // 创建临时Canvas绘制图片
        
        // 创建临时Canvas（和qrcodejs2相同策略）
        const tempCanvas = document.createElement('canvas');
        tempCanvas.width = width;
        tempCanvas.height = height;
        const tempCtx = tempCanvas.getContext('2d');
        
        // 创建图片对象
        const img = new Image();
        
        img.onload = () => {
          try {
            // 计算如何填满指定区域（保持比例）
            const aspectRatio = img.width / img.height;
            const targetAspectRatio = width / height;
            
            let sourceX = 0, sourceY = 0, sourceWidth = img.width, sourceHeight = img.height;
            
            if (aspectRatio > targetAspectRatio) {
              sourceWidth = img.height * targetAspectRatio;
              sourceX = (img.width - sourceWidth) / 2;
            } else if (aspectRatio < targetAspectRatio) {
              sourceHeight = img.width / targetAspectRatio;
              sourceY = (img.height - sourceHeight) / 2;
            }
            
            // 绘制到临时Canvas
            tempCtx.drawImage(
              img,
              sourceX, sourceY, sourceWidth, sourceHeight,
              0, 0, width, height
            );
            
            // 从临时Canvas复制到目标Canvas
            ctx.drawImage(tempCanvas, x, y, width, height);
            
            resolve();
            
          } catch (error) {
            this.drawProductInfoArea(ctx, { x, y, width, height });
            resolve();
          }
        };
        
        img.onerror = (error) => {
          this.drawProductInfoArea(ctx, { x, y, width, height });
          resolve();
        };
        
        // 🔥 关键：不设置crossOrigin，让图片在临时Canvas中处理
        img.src = imageUrl + '?v=' + Math.random();
      });
    },

    // 🔥 绘制图片适应区域（保持比例）
    drawImageFitToArea(ctx, img, x, y, width, height) {
      try {
        // 计算如何填满指定区域（保持比例）
        const aspectRatio = img.width / img.height;
        const targetAspectRatio = width / height;
        
        let sourceX = 0, sourceY = 0, sourceWidth = img.width, sourceHeight = img.height;
        
        if (aspectRatio > targetAspectRatio) {
          sourceWidth = img.height * targetAspectRatio;
          sourceX = (img.width - sourceWidth) / 2;
        } else if (aspectRatio < targetAspectRatio) {
          sourceHeight = img.width / targetAspectRatio;
          sourceY = (img.height - sourceHeight) / 2;
        }
        
        // 绘制图片
        ctx.drawImage(
          img,
          sourceX, sourceY, sourceWidth, sourceHeight,
          x, y, width, height
        );
        
        console.log('🎨 图片适应区域绘制完成');
      } catch (error) {
        console.error('❌ 图片适应区域绘制失败:', error);
      }
    },

    // 🔥 绘制图片为Base64（避免Canvas跨域污染）
    async drawImageAsBase64(ctx, imageUrl, x, y, width, height) {
      try {
        console.log('🔄 开始将图片转换为Base64并绘制:', imageUrl);
        
        // 处理图片URL
        let processedUrl = imageUrl;
        if (imageUrl && !imageUrl.startsWith('http')) {
          const apiBaseUrl = process.env.NODE_ENV === 'production' 
            ? 'https://api1.hqlccn.com'
            : 'http://localhost:20008';
          
          if (imageUrl.startsWith('/')) {
            processedUrl = `${apiBaseUrl}${imageUrl}`;
          } else if (imageUrl.startsWith('crmebimage/')) {
            processedUrl = `${apiBaseUrl}/${imageUrl}`;
          }
        }
        
        // 🔥 方案1：使用fetch获取图片数据，转换为Base64
        try {
          console.log('🌐 使用fetch获取图片:', processedUrl);
          const response = await fetch(processedUrl, {
            mode: 'cors',
            credentials: 'omit'
          });
          
          if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
          }
          
          const blob = await response.blob();
          const base64 = await this.blobToBase64(blob);
          
          console.log('✅ 图片转Base64成功，开始绘制');
          await this.drawBase64ImageToCanvas(ctx, base64, x, y, width, height);
          return;
          
        } catch (fetchError) {
          console.warn('⚠️ fetch方式失败:', fetchError);
        }
        
        // 🔥 方案2：使用Image + canvas转Base64（备用方案）
        try {
          console.log('🔄 使用Image方式转Base64');
          const base64 = await this.imageToBase64(processedUrl);
          await this.drawBase64ImageToCanvas(ctx, base64, x, y, width, height);
          return;
          
        } catch (imageError) {
          console.warn('⚠️ Image方式也失败:', imageError);
        }
        
        // 🔥 方案3：如果都失败，绘制信息区域
        console.log('⚠️ 所有方案都失败，使用信息区域');
        this.drawProductInfoArea(ctx, { x, y, width, height });
        
      } catch (error) {
        console.error('❌ 绘制Base64图片失败:', error);
        this.drawProductInfoArea(ctx, { x, y, width, height });
      }
    },

    // 🔥 将Blob转换为Base64
    blobToBase64(blob) {
      return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result);
        reader.onerror = reject;
        reader.readAsDataURL(blob);
      });
    },

    // 🔥 将图片URL转换为Base64
    imageToBase64(imageUrl) {
      return new Promise((resolve, reject) => {
        const img = new Image();
        
        img.onload = () => {
          try {
            const tempCanvas = document.createElement('canvas');
            tempCanvas.width = img.width;
            tempCanvas.height = img.height;
            const tempCtx = tempCanvas.getContext('2d');
            
            tempCtx.drawImage(img, 0, 0);
            const base64 = tempCanvas.toDataURL('image/png');
            resolve(base64);
          } catch (error) {
            reject(error);
          }
        };
        
        img.onerror = reject;
        
        // 🔥 关键：不设置crossOrigin，避免CORS检查
        img.src = imageUrl + '?v=' + Math.random();
      });
    },

    // 🔥 使用临时Canvas策略绘制Base64二维码（避免污染）
    async drawBase64QRCodeViaTemporaryCanvas(ctx, base64Data, x, y, width, height) {
      return new Promise((resolve) => {
        console.log('🔄 使用临时Canvas绘制Base64二维码');
        
        // 创建临时Canvas（和qrcodejs2相同策略）
        const tempCanvas = document.createElement('canvas');
        tempCanvas.width = width;
        tempCanvas.height = height;
        const tempCtx = tempCanvas.getContext('2d');
        
        // 创建图片对象
        const img = new Image();
        
        img.onload = () => {
          try {
            console.log('✅ Base64二维码加载成功，绘制到临时Canvas');
            
            // 绘制到临时Canvas
            tempCtx.drawImage(img, 0, 0, width, height);
            
            console.log('✅ 临时Canvas绘制完成，复制到目标Canvas');
            
            // 🔥 关键：从临时Canvas复制到目标Canvas（和qrcodejs2相同）
            ctx.drawImage(tempCanvas, x, y, width, height);
            
            console.log('✅ Base64二维码复制到目标Canvas完成');
            resolve();
            
          } catch (error) {
            console.error('❌ 临时Canvas绘制Base64二维码失败:', error);
            this.drawQRCodePlaceholder(ctx, x, y, width, '二维码绘制失败');
            resolve();
          }
        };
        
        img.onerror = (error) => {
          console.error('❌ Base64二维码加载失败:', error);
          this.drawQRCodePlaceholder(ctx, x, y, width, '二维码加载失败');
          resolve();
        };
        
        // 🔥 关键：不设置crossOrigin，让图片在临时Canvas中处理
        img.src = base64Data;
      });
    },

    // 🔥 绘制Base64图片到Canvas
    async drawBase64ImageToCanvas(ctx, base64, x, y, width, height) {
      return new Promise((resolve, reject) => {
        const img = new Image();
        
        img.onload = () => {
          try {
            // 计算如何填满指定区域（保持比例）
            const aspectRatio = img.width / img.height;
            const targetAspectRatio = width / height;
            
            let sourceX = 0, sourceY = 0, sourceWidth = img.width, sourceHeight = img.height;
            
            if (aspectRatio > targetAspectRatio) {
              sourceWidth = img.height * targetAspectRatio;
              sourceX = (img.width - sourceWidth) / 2;
            } else if (aspectRatio < targetAspectRatio) {
              sourceHeight = img.width / targetAspectRatio;
              sourceY = (img.height - sourceHeight) / 2;
            }
            
            // 绘制图片
            ctx.drawImage(
              img,
              sourceX, sourceY, sourceWidth, sourceHeight,
              x, y, width, height
            );
            
            console.log('🎨 Base64图片绘制完成');
            resolve();
          } catch (error) {
            console.error('❌ Base64图片绘制失败:', error);
            reject(error);
          }
        };
        
        img.onerror = reject;
        img.src = base64;
      });
    },

    // 🔥 绘制商品信息区域（不使用跨域图片，避免Canvas污染）
    drawProductInfoArea(ctx, layout) {
      console.log('🎨 开始绘制商品信息区域...');
      
      // 绘制背景渐变
      const gradient = ctx.createLinearGradient(layout.x, layout.y, layout.x, layout.y + layout.height);
      gradient.addColorStop(0, '#f8f9fa');
      gradient.addColorStop(1, '#e9ecef');
      ctx.fillStyle = gradient;
      ctx.fillRect(layout.x, layout.y, layout.width, layout.height);
      
      // 绘制边框
      ctx.strokeStyle = '#dee2e6';
      ctx.lineWidth = 2;
      ctx.strokeRect(layout.x, layout.y, layout.width, layout.height);
      
      const centerX = layout.x + layout.width / 2;
      let currentY = layout.y + 100;
      
      // 绘制商品图片图标
      const iconSize = 120;
      const iconX = centerX - iconSize / 2;
      const iconY = currentY;
      
      // 绘制图片图标背景
      ctx.fillStyle = '#6c757d';
      ctx.fillRect(iconX, iconY, iconSize, iconSize);
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(iconX + 20, iconY + 20, iconSize - 40, iconSize - 40);
      
      // 添加图标中的"图"字
      ctx.fillStyle = '#6c757d';
      ctx.font = 'bold 36px Arial, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('图', iconX + iconSize / 2, iconY + iconSize / 2 + 12);
      
      currentY += iconSize + 60;
      
      // 绘制商品名称
      if (this.selectedProduct && this.selectedProduct.storeName) {
        ctx.fillStyle = '#212529';
        ctx.font = 'bold 48px Arial, sans-serif';
        ctx.textAlign = 'center';
        
        const productName = this.selectedProduct.storeName;
        const maxWidth = layout.width - 40;
        const lineHeight = 60;
        
        this.drawWrappedText(ctx, productName, centerX, currentY, maxWidth, lineHeight);
        currentY += lineHeight * 2 + 40;
      }
      
      // 绘制商品描述
      if (this.selectedProduct && this.selectedProduct.storeInfo) {
        ctx.fillStyle = '#6c757d';
        ctx.font = '28px Arial, sans-serif';
        const descLines = this.wrapText(ctx, this.selectedProduct.storeInfo, layout.width - 40);
        for (let i = 0; i < Math.min(descLines.length, 3); i++) {
          ctx.fillText(descLines[i], centerX, currentY);
          currentY += 35;
        }
        currentY += 40;
      }
      
      // 绘制价格
      if (this.selectedProduct && this.selectedProduct.price) {
        ctx.fillStyle = '#dc3545';
        ctx.font = 'bold 64px Arial, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText(`¥${this.selectedProduct.price}`, centerX, layout.y + layout.height - 50);
      }
      
      console.log('✅ 商品信息区域绘制完成');
    },

    // 🔥 为保存绘制基础海报
    drawBasicPosterForSave(ctx, canvas) {
      // 绘制标题
      ctx.fillStyle = '#333';
      ctx.font = 'bold 24px Arial';
      ctx.textAlign = 'center';
      ctx.fillText(this.posterConfig.title || '海报标题', canvas.width / 2, 50);
    },

    // 🔥 生成包含商品信息的海报（不使用跨域图片）
    async generateProductInfoPoster() {
      console.log('🎨 开始生成商品信息海报...');
      
      const infoCanvas = document.createElement('canvas');
      infoCanvas.width = 750;
      infoCanvas.height = 1334;
      const infoCtx = infoCanvas.getContext('2d');
      
      try {
        const layout = {
          headerText: { x: 0, y: 0, width: 750, height: 60 },
          productInfo: { x: 0, y: 60, width: 750, height: 740 },
          infoArea: { x: 0, y: 800, width: 750, height: 534 }
        };

        // 设置背景色
        infoCtx.fillStyle = this.posterConfig.backgroundColor;
        infoCtx.fillRect(0, 0, infoCanvas.width, infoCanvas.height);

        // 1. 绘制顶部文字
        this.drawHeaderText(infoCtx, layout.headerText);

        // 2. 绘制商品信息区域（包含商品详细信息）
        this.drawDetailedProductInfo(infoCtx, layout.productInfo);

        // 3. 绘制下半部分商品信息和二维码
        await this.drawInfoSection(infoCtx, layout.infoArea);

        console.log('🎨 商品信息海报绘制完成，开始导出...');

        // 导出海报
        return new Promise((resolve, reject) => {
          infoCanvas.toBlob(async (blob) => {
              try {
                if (!blob) {
                throw new Error('商品信息海报转换为Blob失败');
                }
              console.log('✅ 商品信息海报导出成功，大小:', blob.size, 'bytes');
                const imageUrl = await this.uploadPosterBlob(blob);
                resolve(imageUrl);
              } catch (error) {
              console.error('商品信息海报上传失败:', error);
                reject(error);
              }
            }, 'image/png', 0.9);
        });

          } catch (error) {
        console.error('生成商品信息海报失败:', error);
        throw error;
      }
    },

    // 🔥 绘制详细的商品信息
    drawDetailedProductInfo(ctx, layout) {
      if (!this.selectedProduct) {
        this.drawImagePlaceholder(ctx, layout.x, layout.y, layout.width, layout.height, '请选择商品');
        return;
      }

      // 绘制背景渐变
      const gradient = ctx.createLinearGradient(layout.x, layout.y, layout.x, layout.y + layout.height);
      gradient.addColorStop(0, '#f8f9fa');
      gradient.addColorStop(1, '#e9ecef');
      ctx.fillStyle = gradient;
      ctx.fillRect(layout.x, layout.y, layout.width, layout.height);
      
      // 绘制边框
      ctx.strokeStyle = '#dee2e6';
      ctx.lineWidth = 2;
      ctx.strokeRect(layout.x, layout.y, layout.width, layout.height);
      
      const centerX = layout.x + layout.width / 2;
      let currentY = layout.y + 100;
      
      // 绘制商品图片提示
      ctx.fillStyle = '#6c757d';
      ctx.font = '32px Arial, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('商品图片', centerX, currentY);
      currentY += 80;
      
      // 绘制商品名称
      ctx.fillStyle = '#212529';
      ctx.font = 'bold 48px Arial, sans-serif';
      ctx.textAlign = 'center';
      
      const productName = this.selectedProduct.storeName || '商品名称';
      const maxWidth = layout.width - 40;
      const lineHeight = 60;
      
      this.drawWrappedText(ctx, productName, centerX, currentY, maxWidth, lineHeight);
      currentY += lineHeight * 2 + 40;
      
      // 绘制商品描述
      if (this.selectedProduct.storeInfo) {
        ctx.fillStyle = '#6c757d';
        ctx.font = '28px Arial, sans-serif';
        const descLines = this.wrapText(ctx, this.selectedProduct.storeInfo, maxWidth);
        for (let i = 0; i < Math.min(descLines.length, 3); i++) {
          ctx.fillText(descLines[i], centerX, currentY);
          currentY += 35;
        }
        currentY += 40;
      }
      
      // 绘制价格
      if (this.selectedProduct.price) {
        ctx.fillStyle = '#dc3545';
        ctx.font = 'bold 64px Arial, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText(`¥${this.selectedProduct.price}`, centerX, layout.y + layout.height - 50);
      }
    },

    // 🔥 直接导出预览Canvas
    async exportPreviewCanvas(canvas) {
      return new Promise((resolve, reject) => {
        try {
          canvas.toBlob(async (blob) => {
            try {
              if (!blob) {
                throw new Error('预览Canvas转换为Blob失败');
              }
              console.log('✅ 预览Canvas转Blob成功，大小:', blob.size, 'bytes');
                  const imageUrl = await this.uploadPosterBlob(blob);
                  resolve(imageUrl);
            } catch (error) {
              console.error('预览Canvas上传失败:', error);
              reject(error);
            }
          }, 'image/png', 0.9);
        } catch (error) {
          console.error('预览Canvas toBlob失败:', error);
          reject(error);
        }
      });
    },

    // 🔥 复制Canvas内容到新Canvas并导出
    async copyAndExportCanvas(sourceCanvas) {
      console.log('🔄 开始复制Canvas内容...');
      
      const copyCanvas = document.createElement('canvas');
      copyCanvas.width = sourceCanvas.width;
      copyCanvas.height = sourceCanvas.height;
      const copyCtx = copyCanvas.getContext('2d');
      
      try {
        // 复制源Canvas的内容
        copyCtx.drawImage(sourceCanvas, 0, 0);
        console.log('✅ Canvas内容复制完成');
        
        // 导出复制的Canvas
        return new Promise((resolve, reject) => {
          copyCanvas.toBlob(async (blob) => {
            try {
              if (!blob) {
                throw new Error('复制Canvas转换为Blob失败');
              }
              console.log('✅ 复制Canvas转Blob成功，大小:', blob.size, 'bytes');
              const imageUrl = await this.uploadPosterBlob(blob);
                  resolve(imageUrl);
            } catch (error) {
              console.error('复制Canvas上传失败:', error);
              reject(error);
            }
          }, 'image/png', 0.9);
        });
      } catch (error) {
        console.error('复制Canvas失败:', error);
        throw error;
      }
    },

    // 🔥 生成占位符版本的海报（确保能导出）
    async generateFallbackPoster() {
      console.log('🔄 开始生成占位符海报...');
      
      const fallbackCanvas = document.createElement('canvas');
      fallbackCanvas.width = 750;
      fallbackCanvas.height = 1334;
      const fallbackCtx = fallbackCanvas.getContext('2d');
      
      try {
        const layout = {
          headerText: { x: 0, y: 0, width: 750, height: 60 },
          productImage: { x: 0, y: 60, width: 750, height: 740 },
          infoArea: { x: 0, y: 800, width: 750, height: 534 }
        };

        // 设置背景色
        fallbackCtx.fillStyle = this.posterConfig.backgroundColor;
        fallbackCtx.fillRect(0, 0, fallbackCanvas.width, fallbackCanvas.height);

        // 1. 绘制顶部文字
        this.drawHeaderText(fallbackCtx, layout.headerText);

        // 2. 绘制商品占位符（包含商品信息）
        this.drawEnhancedProductPlaceholder(fallbackCtx, layout.productImage);

        // 3. 绘制下半部分商品信息和二维码
        await this.drawInfoSection(fallbackCtx, layout.infoArea);

        console.log('🔄 占位符海报绘制完成，开始导出...');

        // 导出占位符Canvas
        return new Promise((resolve, reject) => {
          fallbackCanvas.toBlob(async (blob) => {
            try {
              if (!blob) {
                throw new Error('占位符Canvas转换为Blob失败');
              }
              console.log('✅ 占位符Canvas导出成功，大小:', blob.size, 'bytes');
              const imageUrl = await this.uploadPosterBlob(blob);
              resolve(imageUrl);
            } catch (error) {
              console.error('占位符Canvas上传失败:', error);
              reject(error);
            }
          }, 'image/png', 0.9);
        });

      } catch (error) {
        console.error('生成占位符海报失败:', error);
        throw error;
      }
    },

    // 🔥 生成干净的海报（不使用跨域图片）
    async generateCleanPoster() {
      console.log('🧹 开始生成干净的海报...');
      
      // 创建一个新的Canvas元素
      const cleanCanvas = document.createElement('canvas');
      cleanCanvas.width = 750;
      cleanCanvas.height = 1334;
      const cleanCtx = cleanCanvas.getContext('2d');
      
      try {
        // 定义海报布局
        const layout = {
          headerText: { x: 0, y: 0, width: 750, height: 60 },
          productImage: { x: 0, y: 60, width: 750, height: 740 },
          infoArea: { x: 0, y: 800, width: 750, height: 534 }
        };

        // 设置背景色
        cleanCtx.fillStyle = this.posterConfig.backgroundColor;
        cleanCtx.fillRect(0, 0, cleanCanvas.width, cleanCanvas.height);

        // 1. 绘制顶部文字
        this.drawHeaderText(cleanCtx, layout.headerText);

        // 2. 绘制商品图片（使用代理服务器避免跨域）
        if (this.selectedProduct && this.selectedProduct.image) {
          console.log('🖼️ 在干净Canvas中绘制商品图片:', this.selectedProduct.image);
          await this.drawImageToCanvasClean(cleanCtx, this.selectedProduct.image, 
            layout.productImage.x, layout.productImage.y, 
            layout.productImage.width, layout.productImage.height);
        } else {
          console.log('🔲 商品图片不存在，绘制占位符');
        this.drawProductPlaceholder(cleanCtx, layout.productImage);
        }

        // 3. 绘制下半部分商品信息和二维码
        await this.drawInfoSection(cleanCtx, layout.infoArea);

        console.log('🧹 干净海报绘制完成，开始导出...');

        // 导出干净的Canvas
        return new Promise((resolve, reject) => {
          cleanCanvas.toBlob(async (blob) => {
            try {
              if (!blob) {
                throw new Error('干净Canvas转换为Blob失败');
              }
              console.log('✅ 干净Canvas导出成功，大小:', blob.size, 'bytes');
              const imageUrl = await this.uploadPosterBlob(blob);
              resolve(imageUrl);
            } catch (error) {
              console.error('干净Canvas上传失败:', error);
              reject(error);
            }
          }, 'image/png', 0.9);
        });

      } catch (error) {
        console.error('生成干净海报失败:', error);
        throw error;
      }
    },

    // 🔥 在干净Canvas中绘制图片（完全避免跨域污染）
    async drawImageToCanvasClean(ctx, imageUrl, x, y, width, height) {
      try {
        console.log('🧹 开始干净Canvas图片绘制:', imageUrl);
        
        // 🔥 方案1：尝试直接加载图片（不设置crossOrigin）
        const success = await this.drawImageDirectly(ctx, imageUrl, x, y, width, height);
        if (success) {
          console.log('✅ 直接图片绘制成功');
          return;
        }
        
        // 🔥 方案2：尝试通过Base64
        console.log('🔄 直接加载失败，尝试Base64方案...');
        const base64Image = await this.getImageAsBase64(imageUrl);
        if (base64Image) {
          console.log('✅ 使用Base64图片绘制');
          return this.drawBase64ImageToCanvas(ctx, base64Image, x, y, width, height);
        }
        
        // 🔥 方案3：如果都失败，绘制占位符
        console.log('⚠️ 所有方案都失败，使用占位符');
        this.drawImagePlaceholder(ctx, x, y, width, height, '商品图片');
        
      } catch (error) {
        console.error('❌ 干净Canvas绘制失败:', error);
        this.drawImagePlaceholder(ctx, x, y, width, height, '图片加载失败');
      }
    },

    // 🔥 将图片转换为Base64（解决跨域问题）
    async convertImageToBase64(imageUrl) {
      return new Promise((resolve, reject) => {
        // 处理图片URL
        let processedUrl = imageUrl;
        if (imageUrl && !imageUrl.startsWith('http')) {
          const apiBaseUrl = process.env.NODE_ENV === 'production' 
            ? 'https://api1.hqlccn.com'
            : 'http://localhost:20008';
          
          if (imageUrl.startsWith('/')) {
            processedUrl = `${apiBaseUrl}${imageUrl}`;
          } else if (imageUrl.startsWith('crmebimage/')) {
            processedUrl = `${apiBaseUrl}/${imageUrl}`;
          }
        }
        
        console.log('🔄 转换图片为Base64:', processedUrl);
        
        const img = new Image();
        // 🔥 添加随机参数避免缓存问题
        img.src = processedUrl + '?v=' + Math.random();
        // 🔥 不设置crossOrigin，避免CORS检查
        // img.crossOrigin = 'Anonymous'; // 注释掉，避免CORS错误
        
        img.onload = () => {
          console.log('✅ 图片加载成功，开始转换Base64');
          try {
            // 创建临时Canvas
            const tempCanvas = document.createElement('canvas');
            tempCanvas.width = img.width;
            tempCanvas.height = img.height;
            const tempCtx = tempCanvas.getContext('2d');
            
            // 绘制图片到临时Canvas
            tempCtx.drawImage(img, 0, 0, img.width, img.height);
            
            // 转换为Base64
            const base64 = tempCanvas.toDataURL('image/png');
            console.log('✅ Base64转换成功');
            resolve(base64);
          } catch (error) {
            console.error('❌ Base64转换失败:', error);
            reject(error);
          }
        };
        
        img.onerror = (error) => {
          console.error('❌ 图片加载失败:', processedUrl, error);
          reject(error);
        };
      });
    },

    // 🔥 直接绘制图片（不使用crossOrigin，接受Canvas污染）- 带重试机制
    async drawImageDirectly(ctx, imageUrl, x, y, width, height, retryCount = 3) {
      for (let attempt = 1; attempt <= retryCount; attempt++) {
        try {
          console.log(`🖼️ 尝试绘制图片 (第${attempt}次):`, imageUrl);
          
          const success = await this.drawImageDirectlyOnce(ctx, imageUrl, x, y, width, height, attempt);
          if (success) {
            console.log(`✅ 图片绘制成功 (第${attempt}次尝试)`);
            return true;
          }
          
          if (attempt < retryCount) {
            console.log(`⏳ 第${attempt}次尝试失败，等待后重试...`);
            await new Promise(resolve => setTimeout(resolve, 1000 * attempt)); // 递增延迟
          }
        } catch (error) {
          console.error(`❌ 第${attempt}次尝试出错:`, error);
          if (attempt === retryCount) {
            return false;
          }
        }
      }
      
      console.error(`❌ 所有${retryCount}次尝试都失败了`);
      return false;
    },

    // 单次图片绘制尝试
    async drawImageDirectlyOnce(ctx, imageUrl, x, y, width, height, attempt = 1) {
      return new Promise((resolve) => {
        // 处理图片URL
        let processedUrl = imageUrl;
        if (imageUrl && !imageUrl.startsWith('http')) {
          const apiBaseUrl = process.env.NODE_ENV === 'production' 
            ? 'https://api1.hqlccn.com'
            : 'http://localhost:20008';
          
          if (imageUrl.startsWith('/')) {
            processedUrl = `${apiBaseUrl}${imageUrl}`;
          } else if (imageUrl.startsWith('crmebimage/')) {
            processedUrl = `${apiBaseUrl}/${imageUrl}`;
          }
        }
        
        const img = new Image();
        // 🔥 不设置crossOrigin，避免CORS检查，但接受Canvas污染
        // 添加时间戳和尝试次数避免缓存问题
        img.src = processedUrl + '?v=' + Date.now() + '_' + attempt;
        
        // 设置超时
        const timeout = setTimeout(() => {
          console.error('⏰ 图片加载超时:', processedUrl);
          resolve(false);
        }, 10000); // 10秒超时
        
        img.onload = () => {
          clearTimeout(timeout);
          console.log('✅ 图片加载成功，开始绘制');
          try {
            // 计算如何填满指定区域
            const aspectRatio = img.width / img.height;
            const targetAspectRatio = width / height;
            
            let sourceX = 0, sourceY = 0, sourceWidth = img.width, sourceHeight = img.height;
            
            if (aspectRatio > targetAspectRatio) {
              sourceWidth = img.height * targetAspectRatio;
              sourceX = (img.width - sourceWidth) / 2;
            } else if (aspectRatio < targetAspectRatio) {
              sourceHeight = img.width / targetAspectRatio;
              sourceY = (img.height - sourceHeight) / 2;
            }
            
            // 绘制图片
            ctx.drawImage(
              img,
              sourceX, sourceY, sourceWidth, sourceHeight,
              x, y, width, height
            );
            
            console.log('🎨 图片绘制完成');
            resolve(true);
          } catch (error) {
            console.error('❌ 图片绘制失败:', error);
            resolve(false);
          }
        };
        
        img.onerror = (error) => {
          clearTimeout(timeout);
          console.error('❌ 图片加载失败:', processedUrl, error);
          resolve(false);
        };
      });
    },

    // 🔥 通过fetch获取图片并转换为Base64（避免Canvas跨域污染）
    async getImageAsBase64(imageUrl) {
      try {
        // 处理图片URL
        let processedUrl = imageUrl;
        if (imageUrl && !imageUrl.startsWith('http')) {
          const apiBaseUrl = process.env.NODE_ENV === 'production' 
            ? 'https://api1.hqlccn.com'
            : 'http://localhost:20008';
          
          if (imageUrl.startsWith('/')) {
            processedUrl = `${apiBaseUrl}${imageUrl}`;
          } else if (imageUrl.startsWith('crmebimage/')) {
            processedUrl = `${apiBaseUrl}/${imageUrl}`;
          }
        }

        console.log('🔄 Fetch图片并转Base64:', processedUrl);
        
        // 🔥 使用fetch获取图片数据（尝试不同的模式）
        let response;
        try {
          // 首先尝试no-cors模式
          response = await fetch(processedUrl, {
            mode: 'no-cors',
            credentials: 'omit'
          });
        } catch (noCorsError) {
          console.warn('⚠️ no-cors模式失败，尝试cors模式:', noCorsError);
          // 如果no-cors失败，尝试cors模式
          response = await fetch(processedUrl, {
            mode: 'cors',
            credentials: 'omit'
          });
        }
        
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        // 转换为Blob
        const blob = await response.blob();
        console.log('✅ 图片Blob获取成功，大小:', blob.size);
        
        // 转换为Base64
        return new Promise((resolve, reject) => {
          const reader = new FileReader();
          reader.onload = () => {
            console.log('✅ Base64转换成功');
            resolve(reader.result);
          };
          reader.onerror = (error) => {
            console.error('❌ Base64转换失败:', error);
            reject(error);
          };
          reader.readAsDataURL(blob);
        });
        
      } catch (error) {
        console.error('❌ Fetch图片失败:', error);
        return null;
      }
    },

    // 🔥 绘制Base64图片到Canvas
    async drawBase64ImageToCanvas(ctx, base64Data, x, y, width, height) {
      return new Promise((resolve, reject) => {
        const img = new Image();
        
        img.onload = () => {
          console.log('✅ Base64图片加载成功');
          try {
            // 计算如何填满指定区域，可能会裁剪图片
            const aspectRatio = img.width / img.height;
            const targetAspectRatio = width / height;
            
            let sourceX = 0, sourceY = 0, sourceWidth = img.width, sourceHeight = img.height;
            
            if (aspectRatio > targetAspectRatio) {
              sourceWidth = img.height * targetAspectRatio;
              sourceX = (img.width - sourceWidth) / 2;
            } else if (aspectRatio < targetAspectRatio) {
              sourceHeight = img.width / targetAspectRatio;
              sourceY = (img.height - sourceHeight) / 2;
            }
            
            // 绘制裁剪后的图片
            ctx.drawImage(
              img,
              sourceX, sourceY, sourceWidth, sourceHeight,
              x, y, width, height
            );
            
            console.log('🎨 Base64图片绘制完成');
            resolve();
          } catch (error) {
            console.error('❌ Base64图片绘制失败:', error);
            this.drawImagePlaceholder(ctx, x, y, width, height, '图片绘制失败');
            resolve();
          }
        };
        
        img.onerror = (error) => {
          console.error('❌ Base64图片加载失败:', error);
          this.drawImagePlaceholder(ctx, x, y, width, height, 'Base64加载失败');
          resolve();
        };
        
        // 设置Base64数据源
        img.src = base64Data.startsWith('data:') ? base64Data : `data:image/jpeg;base64,${base64Data}`;
      });
    },

    // 🔥 绘制增强的商品占位符（包含更多商品信息）
    drawEnhancedProductPlaceholder(ctx, layout) {
      // 绘制背景渐变
      const gradient = ctx.createLinearGradient(layout.x, layout.y, layout.x, layout.y + layout.height);
      gradient.addColorStop(0, '#f8f9fa');
      gradient.addColorStop(1, '#e9ecef');
      ctx.fillStyle = gradient;
      ctx.fillRect(layout.x, layout.y, layout.width, layout.height);
      
      // 绘制边框
      ctx.strokeStyle = '#dee2e6';
      ctx.lineWidth = 2;
      ctx.strokeRect(layout.x, layout.y, layout.width, layout.height);
      
      if (this.selectedProduct) {
        // 绘制商品名称（大标题）
        ctx.fillStyle = '#212529';
        ctx.font = 'bold 48px Arial, sans-serif';
        ctx.textAlign = 'center';
        
        const productName = this.selectedProduct.storeName || '商品名称';
        const maxWidth = layout.width - 40;
        const lineHeight = 60;
        const startY = layout.y + 150;
        
        this.drawWrappedText(ctx, productName, layout.x + layout.width / 2, startY, maxWidth, lineHeight);
        
        // 绘制商品描述
        if (this.selectedProduct.storeInfo) {
          ctx.fillStyle = '#6c757d';
          ctx.font = '32px Arial, sans-serif';
          const descStartY = startY + lineHeight * 2 + 40;
          this.drawWrappedText(ctx, this.selectedProduct.storeInfo, layout.x + layout.width / 2, descStartY, maxWidth, 45);
        }
        
        // 绘制价格
        if (this.selectedProduct.price) {
          ctx.fillStyle = '#dc3545';
          ctx.font = 'bold 56px Arial, sans-serif';
          ctx.textAlign = 'center';
          ctx.fillText(`¥${this.selectedProduct.price}`, layout.x + layout.width / 2, layout.y + layout.height - 100);
        }
        
        // 绘制"商品图片"标识
        ctx.fillStyle = '#6c757d';
        ctx.font = '24px Arial, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('商品图片', layout.x + layout.width / 2, layout.y + 50);
        
      } else {
        // 如果没有商品信息，显示默认占位符
        this.drawProductPlaceholder(ctx, layout);
      }
    },

    // 🔥 绘制商品占位符
    drawProductPlaceholder(ctx, layout) {
      // 绘制背景渐变
      const gradient = ctx.createLinearGradient(layout.x, layout.y, layout.x, layout.y + layout.height);
      gradient.addColorStop(0, '#f8f9fa');
      gradient.addColorStop(1, '#e9ecef');
      ctx.fillStyle = gradient;
      ctx.fillRect(layout.x, layout.y, layout.width, layout.height);
      
      // 绘制边框
      ctx.strokeStyle = '#dee2e6';
      ctx.lineWidth = 2;
      ctx.strokeRect(layout.x, layout.y, layout.width, layout.height);
      
      // 绘制产品图标
      const iconSize = 120;
      const iconX = layout.x + (layout.width - iconSize) / 2;
      const iconY = layout.y + layout.height / 2 - iconSize - 50;
      
      // 简单的商品图标
      ctx.fillStyle = '#6c757d';
      ctx.fillRect(iconX, iconY, iconSize, iconSize);
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(iconX + 20, iconY + 20, iconSize - 40, iconSize - 40);
      
      // 添加图标中的"商品"文字
      ctx.fillStyle = '#6c757d';
      ctx.font = 'bold 24px Arial, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('商品', iconX + iconSize / 2, iconY + iconSize / 2 + 8);
      
      // 绘制商品名称
      if (this.selectedProduct && this.selectedProduct.storeName) {
        ctx.fillStyle = '#212529';
        ctx.font = 'bold 36px Arial, sans-serif';
        ctx.textAlign = 'center';
        
        // 处理长文本换行
        const productName = this.selectedProduct.storeName;
        const maxWidth = layout.width - 40;
        const lineHeight = 50;
        const startY = iconY + iconSize + 60;
        
        this.drawWrappedText(ctx, productName, layout.x + layout.width / 2, startY, maxWidth, lineHeight);
      }
      
      // 添加说明文字
      ctx.fillStyle = '#6c757d';
      ctx.font = '20px Arial, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('商品图片预览', layout.x + layout.width / 2, layout.y + layout.height - 40);
    },

    // 绘制自动换行文字
    drawWrappedText(ctx, text, x, y, maxWidth, lineHeight) {
      const words = text.split('');
      let line = '';
      let currentY = y;
      
      for (let i = 0; i < words.length; i++) {
        const testLine = line + words[i];
        const metrics = ctx.measureText(testLine);
        const testWidth = metrics.width;
        
        if (testWidth > maxWidth && i > 0) {
          ctx.fillText(line, x, currentY);
          line = words[i];
          currentY += lineHeight;
        } else {
          line = testLine;
        }
      }
      ctx.fillText(line, x, currentY);
    },

    async uploadPosterBlob(blob) {
      try {
              const formData = new FormData();
        const filename = 'poster_' + Date.now() + '.png';
              formData.append('multipart', blob, filename);
              
              console.log('准备上传图片，文件名:', filename);
              
              const { fileImageApi } = await import('@/api/systemSetting');
              
              // 获取商品海报分类ID
              const categoryId = await this.getProductPosterCategoryId();
        console.log('使用分类ID:', categoryId);
              
              const uploadParams = {
                model: 'application',
          pid: categoryId,
              };
              
        console.log('上传参数:', uploadParams);
              
              const uploadResponse = await fileImageApi(formData, uploadParams);
              console.log('上传API响应:', uploadResponse);
              
              if (uploadResponse && uploadResponse.url) {
                console.log('海报图片上传成功:', uploadResponse.url);
                return uploadResponse.url;
              } else {
                console.error('上传响应无效:', uploadResponse);
                throw new Error('图片上传失败：服务器返回无效响应');
              }
            } catch (error) {
              console.error('上传海报图片失败:', error);
        throw new Error('图片上传失败：' + (error.message || '网络错误'));
      }
    },

    // 获取PC商品海报分类ID
    async getProductPosterCategoryId() {
      try {
        // 动态导入分类API
        const { treeCategroy } = await import('@/api/categoryApi');
        
        // 获取附件分类列表（type=2）
        const response = await treeCategroy({ status: -1, type: 2 });
        console.log('附件分类列表:', response);
        
        if (response && Array.isArray(response)) {
          // 查找"PC商品海报"分类
          const posterCategory = response.find(item => 
            item.name === 'PC商品海报' || item.name.includes('PC') && item.name.includes('海报')
          );
          
          if (posterCategory) {
            console.log('找到PC商品海报分类:', posterCategory);
            return posterCategory.id;
          }
          
          // 如果没找到PC商品海报，查找普通商品海报作为备选
          const fallbackCategory = response.find(item => 
            item.name === '商品海报' || item.name.includes('海报')
          );
          
          if (fallbackCategory) {
            console.log('使用备选海报分类:', fallbackCategory);
            return fallbackCategory.id;
          }
        }
        
        // 如果没找到任何海报分类，使用默认分类ID
        console.log('未找到任何海报分类，使用默认ID: 859');
        return 859;
        
      } catch (error) {
        console.error('获取分类失败:', error);
        // 出错时使用默认分类ID
        return 859;
      }
    },

    async savePosterRecord(imageUrl) {
      try {
        console.log('开始保存海报记录到数据库...');
        
        const posterData = {
          title: this.posterConfig.title || (this.selectedProduct ? this.selectedProduct.storeName : '商品海报'),
          type: 'product', // 商品海报类型
          width: this.posterConfig.width,
          height: this.posterConfig.height,
          backgroundColor: this.posterConfig.backgroundColor,
          posterImage: imageUrl,
          productId: this.selectedProduct ? this.selectedProduct.id : null,
          mainTitle: this.selectedProduct ? this.selectedProduct.storeName : '',
          description: this.selectedProduct ? this.selectedProduct.storeInfo : '',
          showQrCode: true,
          qrCodeContent: this.generateProductUrl(),
          qrCodeSize: 120,
          configJson: JSON.stringify({
            backgroundColor: this.posterConfig.backgroundColor,
            width: this.posterConfig.width,
            height: this.posterConfig.height,
            productInfo: this.selectedProduct ? {
              id: this.selectedProduct.id,
              name: this.selectedProduct.storeName,
              price: this.selectedProduct.price,
              otPrice: this.selectedProduct.otPrice,
              image: this.selectedProduct.image
            } : null
          }),
          merId: this.posterConfig.merId // 添加商户ID
        };
        
        console.log('保存海报数据:', posterData);
        console.log('posterImage字段值:', posterData.posterImage);
        const response = await createPlatformPosterApi(posterData);
        console.log('海报记录保存API响应:', response);
        console.log('响应数据:', JSON.stringify(response, null, 2));
        
      } catch (error) {
        console.error('保存海报记录失败:', error);
        throw new Error('保存海报记录失败：' + (error.message || '网络错误'));
      }
    },

    // 生成商品详情页URL
    generateProductUrl() {
      if (!this.selectedProduct || !this.selectedProduct.id) {
        console.error('❌ 无法生成商品URL：商品信息不完整', this.selectedProduct);
        return '';
      }
      
      // 生产环境商场前端地址
      const currentOrigin = window.location.origin;
      let mallBaseUrl;
      
      if (currentOrigin.includes('localhost') || currentOrigin.includes('127.0.0.1')) {
        // 本地开发环境：平台后台在9528，商场前端在8080
        mallBaseUrl = currentOrigin.replace(':9528', ':8080');
      } else {
        // 生产环境：使用固定的商场域名
        mallBaseUrl = 'https://hqlccn.com';
      }
      
      // 商场前端商品详情页路径
      const productDetailUrl = `${mallBaseUrl}/goods_detail/${this.selectedProduct.id}`;
      
      console.log('🔗 生成商品详情页URL:', {
        selectedProduct: this.selectedProduct,
        productId: this.selectedProduct.id,
        mallBaseUrl: mallBaseUrl,
        finalUrl: productDetailUrl
      });
      
      // 验证商品ID是否有效
      if (!this.selectedProduct.id || this.selectedProduct.id <= 0) {
        console.error('❌ 商品ID无效:', this.selectedProduct.id);
        return '';
      }
      
      return productDetailUrl;
    },


    // 预览生成（仿照商户端样式）
    generatePreview() {
      this.$nextTick(() => {
        this.generatePosterPreview();
      });
    },

    async generatePosterPreview() {
      const canvas = this.$refs.posterCanvas;
      if (!canvas) {
        console.error('Canvas元素未找到');
        return;
      }

      const ctx = canvas.getContext('2d');
      if (!ctx) {
        console.error('无法获取Canvas上下文');
        return;
      }

      ctx.clearRect(0, 0, canvas.width, canvas.height);
      
      ctx.fillStyle = this.posterConfig.backgroundColor;
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      
      if (this.posterConfig.type === 'product') {
        await this.drawProductPoster(ctx);
      } else {
        this.drawBasicPoster(ctx);
      }
    },

    async drawProductPoster(ctx) {
      console.log('开始绘制商品海报...');
      console.log('当前选中的商品:', this.selectedProduct);
      const canvas = this.$refs.posterCanvas;
      
      if (!this.selectedProduct) {
        // 绘制空状态提示
        ctx.fillStyle = '#999999';
        ctx.font = 'bold 24px Arial';
        ctx.textAlign = 'center';
        ctx.fillText('请先选择商品', canvas.width / 2, canvas.height / 2);
        return;
      }
      
      // 定义海报布局（750x1334）
      const layout = {
        // 顶部文字区域
        headerText: { x: 0, y: 0, width: 750, height: 60 },
        // 商品图片区域（占满宽度）
        productImage: { x: 0, y: 60, width: 750, height: 740 },
        // 下半部分 - 商品信息区域
        infoArea: { x: 0, y: 800, width: 750, height: 534 }
      };

      try {
        // 设置背景色
        ctx.fillStyle = this.posterConfig.backgroundColor;
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        // 1. 绘制顶部文字
        this.drawHeaderText(ctx, layout.headerText);

        // 2. 绘制商品图片（占满宽度）- 🔥 预览也使用临时Canvas策略
        if (this.selectedProduct && this.selectedProduct.image) {
          console.log('🖼️ 预览Canvas绘制商品图片（使用临时Canvas策略）:', this.selectedProduct.image);
          // 🔥 预览也使用和保存相同的临时Canvas策略，避免污染
          // 处理图片URL
          let processedUrl = this.selectedProduct.image;
          if (this.selectedProduct.image && !this.selectedProduct.image.startsWith('http')) {
            const apiBaseUrl = process.env.NODE_ENV === 'production' 
              ? 'https://api1.hqlccn.com'
              : 'http://localhost:20008';
            
            if (this.selectedProduct.image.startsWith('/')) {
              processedUrl = `${apiBaseUrl}${this.selectedProduct.image}`;
            } else if (this.selectedProduct.image.startsWith('crmebimage/')) {
              processedUrl = `${apiBaseUrl}/${this.selectedProduct.image}`;
            }
          }
          
          await this.drawImageViaTemporaryCanvas(ctx, processedUrl, 
            layout.productImage.x, layout.productImage.y, 
            layout.productImage.width, layout.productImage.height);
        } else {
          console.log('商品图片不存在，跳过绘制');
        }

        // 3. 绘制下半部分商品信息和二维码
        await this.drawInfoSection(ctx, layout.infoArea);

      } catch (error) {
        console.error('绘制商品海报失败:', error);
      }
      
      console.log('商品海报绘制完成');
    },

    drawBasicPoster(ctx) {
      // 绘制标题
      ctx.fillStyle = '#333';
      ctx.font = 'bold 24px Arial';
      ctx.textAlign = 'center';
      ctx.fillText(this.posterConfig.title || '海报标题', this.posterConfig.width / 2, 50);
    },

    // 绘制顶部文字
    drawHeaderText(ctx, area) {
      ctx.font = 'bold 24px Arial';
      ctx.fillStyle = '#333333';
      ctx.textAlign = 'center';
      ctx.fillText('推荐一个好物给你，请查收', area.width / 2, area.y + 35);
    },

    // 绘制图片到Canvas
    async drawImageToCanvas(ctx, imageUrl, x, y, width, height) {
      return new Promise((resolve, reject) => {
        const img = new Image();
        
        // 处理图片URL，确保能够正确加载
        let processedUrl = imageUrl;
        
        // 如果是相对路径，转换为完整URL
        if (imageUrl && !imageUrl.startsWith('http')) {
          if (this.$imageUrl) {
            processedUrl = this.$imageUrl(imageUrl);
          } else {
            // 手动构建完整URL
            const apiBaseUrl = process.env.NODE_ENV === 'production' 
              ? 'https://api1.hqlccn.com'  // 生产环境API服务器
              : 'http://localhost:20008';  // 开发环境
            
            if (imageUrl.startsWith('/')) {
              processedUrl = `${apiBaseUrl}${imageUrl}`;
            } else if (imageUrl.startsWith('crmebimage/')) {
              processedUrl = `${apiBaseUrl}/${imageUrl}`;
            }
          }
        }
        
        console.log('🖼️ 原始图片URL:', imageUrl);
        console.log('🔗  处理后URL:', processedUrl);
        
        // 设置跨域属性
        img.crossOrigin = 'anonymous';
        
        img.onload = () => {
          console.log('✅ 图片加载成功:', processedUrl);
          try {
            // 计算如何填满指定区域，可能会裁剪图片
            const aspectRatio = img.width / img.height;
            const targetAspectRatio = width / height;
            
            let sourceX = 0, sourceY = 0, sourceWidth = img.width, sourceHeight = img.height;
            
            if (aspectRatio > targetAspectRatio) {
              // 图片比目标区域更宽，需要裁剪左右
              sourceWidth = img.height * targetAspectRatio;
              sourceX = (img.width - sourceWidth) / 2;
            } else if (aspectRatio < targetAspectRatio) {
              // 图片比目标区域更高，需要裁剪上下
              sourceHeight = img.width / targetAspectRatio;
              sourceY = (img.height - sourceHeight) / 2;
            }
            
            // 绘制裁剪后的图片，填满整个目标区域
            ctx.drawImage(
              img,
              sourceX, sourceY, sourceWidth, sourceHeight, // 源图片的裁剪区域
              x, y, width, height // 目标绘制区域
            );
            
            console.log('🎨 图片绘制完成');
            resolve();
          } catch (error) {
            console.error('❌ 绘制图片失败:', error);
            this.drawImagePlaceholder(ctx, x, y, width, height, '图片绘制失败');
            resolve();
          }
        };
        
        img.onerror = (error) => {
          console.error('❌ 图片加载失败:');
          console.error('- 原始URL:', imageUrl);
          console.error('- 处理后URL:', processedUrl);
          console.error('- 错误事件:', error);
          console.error('- 图片对象状态:', {
            src: img.src,
            crossOrigin: img.crossOrigin,
            complete: img.complete,
            naturalWidth: img.naturalWidth,
            naturalHeight: img.naturalHeight
          });
          
          // 🔥 尝试不使用crossOrigin重新加载
          if (img.crossOrigin && !this.retryWithoutCors) {
            console.log('🔄 尝试不使用CORS重新加载图片...');
            this.retryWithoutCors = true;
            const retryImg = new Image();
            retryImg.onload = () => {
              console.log('✅ 不使用CORS加载成功');
              try {
                // 计算如何填满指定区域，可能会裁剪图片
                const aspectRatio = retryImg.width / retryImg.height;
                const targetAspectRatio = width / height;
                
                let sourceX = 0, sourceY = 0, sourceWidth = retryImg.width, sourceHeight = retryImg.height;
                
                if (aspectRatio > targetAspectRatio) {
                  sourceWidth = retryImg.height * targetAspectRatio;
                  sourceX = (retryImg.width - sourceWidth) / 2;
                } else if (aspectRatio < targetAspectRatio) {
                  sourceHeight = retryImg.width / targetAspectRatio;
                  sourceY = (retryImg.height - sourceHeight) / 2;
                }
                
                ctx.drawImage(
                  retryImg,
                  sourceX, sourceY, sourceWidth, sourceHeight,
                  x, y, width, height
                );
                
                this.retryWithoutCors = false;
                resolve();
              } catch (drawError) {
                console.error('❌ 重试绘制失败:', drawError);
                this.drawImagePlaceholder(ctx, x, y, width, height, '重试绘制失败');
                this.retryWithoutCors = false;
                resolve();
              }
            };
            retryImg.onerror = () => {
              console.error('❌ 重试也失败了');
              this.drawImagePlaceholder(ctx, x, y, width, height, '图片无法访问');
              this.retryWithoutCors = false;
              resolve();
            };
            retryImg.src = processedUrl;
          } else {
            this.drawImagePlaceholder(ctx, x, y, width, height, '图片加载失败');
            resolve();
          }
        };
        
        img.src = processedUrl;
      });
    },

    // 绘制图片占位符
    drawImagePlaceholder(ctx, x, y, width, height, errorMessage = '图片加载失败') {
      ctx.fillStyle = '#f5f5f5';
      ctx.fillRect(x, y, width, height);
      ctx.strokeStyle = '#ddd';
      ctx.lineWidth = 2;
      ctx.strokeRect(x, y, width, height);
      
      ctx.fillStyle = '#999';
      ctx.font = '14px Arial, sans-serif';
      ctx.textAlign = 'center';
      
      // 🔥 分行显示错误信息
      const lines = [errorMessage, '请检查图片路径'];
      const lineHeight = 18;
      const startY = y + height / 2 - (lines.length * lineHeight) / 2;
      
      lines.forEach((line, index) => {
        ctx.fillText(line, x + width / 2, startY + index * lineHeight);
      });
    },

    // 绘制下半部分信息区域
    async drawInfoSection(ctx, area) {
      try {
        // 绘制背景
        ctx.fillStyle = '#ffffff';
        ctx.fillRect(area.x, area.y, area.width, area.height);

        // 定义信息区域内的布局
        const padding = 30;
        const qrSize = 160;
        
        const infoLayout = {
          // 左侧商品信息区域
          productInfo: { 
            x: area.x + padding, 
            y: area.y + padding, 
            width: area.width - qrSize - padding * 3, 
            height: area.height - padding * 2 
          },
          // 右侧二维码区域
          qrCode: { 
            x: area.x + area.width - qrSize - padding, 
            y: area.y + padding, 
            width: qrSize, 
            height: qrSize 
          }
        };

        // 绘制商品信息
        await this.drawProductInfoDetail(ctx, infoLayout.productInfo);

        // 绘制二维码
        await this.drawQRCodeDetail(ctx, infoLayout.qrCode);

      } catch (error) {
        console.error('绘制信息区域失败:', error);
      }
    },

    // 绘制商品详细信息
    async drawProductInfoDetail(ctx, area) {
      try {
        let currentY = area.y;
        const lineHeight = 35;

        // 1. 商品名称
        ctx.font = 'bold 32px Arial';
        ctx.fillStyle = '#333333';
        ctx.textAlign = 'left';
        currentY += 40;
        const productName = this.selectedProduct && this.selectedProduct.storeName ? this.selectedProduct.storeName : '未知商品';
        this.drawMultilineText(ctx, productName, 
          area.x, currentY, area.width, lineHeight, 2);
        currentY += lineHeight * 2 + 20;

        // 2. 商品描述
        ctx.font = '20px Arial';
        ctx.fillStyle = '#666666';
        const description = (this.selectedProduct && this.selectedProduct.storeInfo) ? 
          this.selectedProduct.storeInfo : 
          ((this.selectedProduct && this.selectedProduct.keyword) ? this.selectedProduct.keyword : '优质商品，值得拥有');
        this.drawMultilineText(ctx, description, 
          area.x, currentY, area.width, 28, 3);
        currentY += 28 * 3 + 30;

        // 3. 价格信息
        await this.drawPriceInfo(ctx, area.x, currentY, area.width);

      } catch (error) {
        console.error('绘制商品信息失败:', error);
      }
    },

    // 绘制价格信息
    async drawPriceInfo(ctx, x, y, width) {
      try {
        let originalPrice = (this.selectedProduct && this.selectedProduct.price) ? this.selectedProduct.price : '0.00';
        
        ctx.textAlign = 'left';
        ctx.fillStyle = '#ff4444';
        ctx.font = 'bold 48px Arial';
        ctx.fillText('￥' + originalPrice, x, y + 30);
        
      } catch (error) {
        console.error('绘制价格信息失败:', error);
      }
    },

    // 绘制二维码详情
    async drawQRCodeDetail(ctx, area) {
      try {
        // 生成商品详情页URL
        const productUrl = this.generateProductUrl();
        
        // 绘制二维码背景
        ctx.fillStyle = '#ffffff';
        ctx.fillRect(area.x, area.y, area.width, area.height);
        ctx.strokeStyle = '#e0e0e0';
        ctx.lineWidth = 2;
        ctx.strokeRect(area.x, area.y, area.width, area.height);
        
        // 生成真实的二维码
        await this.generateRealQRCode(ctx, productUrl, area.x + 10, area.y + 10, area.width - 20);
        
        // 二维码说明文字
        ctx.fillStyle = '#666666';
        ctx.font = '16px Arial';
        ctx.textAlign = 'center';
        ctx.fillText('扫码查看', area.x + area.width / 2, area.y + area.height + 25);
        ctx.fillText('商品详情', area.x + area.width / 2, area.y + area.height + 45);
        
        console.log('商品详情页URL:', productUrl);
      } catch (error) {
        console.error('绘制二维码失败:', error);
      }
    },

    // 绘制真实的二维码图案
    drawRealisticQRCode(ctx, x, y, qrSize) {
      // 绘制白色背景
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(x, y, qrSize, qrSize);
      
      // 绘制边框
      ctx.strokeStyle = '#333333';
      ctx.lineWidth = 2;
      ctx.strokeRect(x, y, qrSize, qrSize);
      
      // 绘制更真实的二维码图案
      ctx.fillStyle = '#000000';
      
      // 绘制定位角
      this.drawQRCorner(ctx, x + 10, y + 10, 20);
      this.drawQRCorner(ctx, x + qrSize - 30, y + 10, 20);
      this.drawQRCorner(ctx, x + 10, y + qrSize - 30, 20);
      
      // 绘制数据点
      for (let i = 0; i < qrSize - 20; i += 6) {
        for (let j = 0; j < qrSize - 20; j += 6) {
          if (Math.random() > 0.4) { // 60%的密度
            const pointX = x + 10 + i;
            const pointY = y + 10 + j;
            
            // 避开定位角区域
            if (!this.isInCornerArea(i, j, qrSize - 20)) {
              ctx.fillRect(pointX, pointY, 4, 4);
            }
          }
        }
      }
    },

    // 绘制二维码定位角
    drawQRCorner(ctx, x, y, size) {
      // 外框
      ctx.fillRect(x, y, size, size);
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(x + 2, y + 2, size - 4, size - 4);
      ctx.fillStyle = '#000000';
      ctx.fillRect(x + 6, y + 6, size - 12, size - 12);
    },

    // 检查是否在定位角区域
    isInCornerArea(x, y, maxSize) {
      const cornerSize = 30;
      return (
        (x < cornerSize && y < cornerSize) || // 左上角
        (x > maxSize - cornerSize && y < cornerSize) || // 右上角
        (x < cornerSize && y > maxSize - cornerSize) // 左下角
      );
    },

    // 生成真实二维码
    async generateRealQRCode(ctx, text, x, y, size) {
      console.log('🔄 开始生成真实二维码:', text);
      
      // 🔥 直接使用前端qrcodejs2生成，已经验证可以正常工作
      console.log('✅ 使用前端qrcodejs2生成二维码');
      await this.generateQRCodeWithJS(ctx, text, x, y, size);
    },

    // 使用前端JS生成二维码（备选方案）
    async generateQRCodeWithJS(ctx, text, x, y, size) {
      return new Promise((resolve) => {
        try {
          console.log('🔄 尝试使用前端JS生成二维码:', text);
          
          // 创建临时div用于生成二维码
          const tempDiv = document.createElement('div');
          tempDiv.style.position = 'absolute';
          tempDiv.style.left = '-9999px';
          tempDiv.style.top = '-9999px';
          tempDiv.style.width = size + 'px';
          tempDiv.style.height = size + 'px';
          document.body.appendChild(tempDiv);
          
          // 尝试使用全局的QRCode（如果已加载）
          if (window.QRCode) {
            console.log('✅ 使用全局QRCode对象');
            this.createQRCodeWithLibrary(window.QRCode, tempDiv, text, size, ctx, x, y, resolve);
          } else {
            // 动态导入qrcodejs2
            console.log('🔄 动态导入qrcodejs2...');
            import('qrcodejs2').then((QRCodeModule) => {
              const QRCode = QRCodeModule.default || QRCodeModule;
              console.log('✅ qrcodejs2导入成功');
              this.createQRCodeWithLibrary(QRCode, tempDiv, text, size, ctx, x, y, resolve);
            }).catch((error) => {
              console.error('❌ 导入qrcodejs2失败:', error);
              this.drawQRCodePlaceholder(ctx, x, y, size, '二维码库加载失败');
              document.body.removeChild(tempDiv);
              resolve();
            });
          }
          
        } catch (error) {
          console.error('❌ 前端二维码生成失败:', error);
          this.drawQRCodePlaceholder(ctx, x, y, size, '二维码生成失败');
          resolve();
        }
      });
    },

    // 使用二维码库创建二维码
    createQRCodeWithLibrary(QRCode, tempDiv, text, size, ctx, x, y, resolve) {
      try {
        const qr = new QRCode(tempDiv, {
          text: text,
          width: size,
          height: size,
          colorDark: '#000000',
          colorLight: '#ffffff',
          correctLevel: QRCode.CorrectLevel.H
        });
        
        // 等待二维码生成完成
        setTimeout(() => {
          const qrCanvas = tempDiv.querySelector('canvas');
          const qrImg = tempDiv.querySelector('img');
          
          console.log('🔍 检查二维码生成结果:', {
            hasCanvas: !!qrCanvas,
            hasImg: !!qrImg,
            imgComplete: qrImg ? qrImg.complete : false
          });
          
          if (qrCanvas) {
            console.log('✅ 使用Canvas绘制二维码');
            ctx.drawImage(qrCanvas, x, y, size, size);
          } else if (qrImg && qrImg.complete) {
            console.log('✅ 使用Image绘制二维码');
            ctx.drawImage(qrImg, x, y, size, size);
          } else if (qrImg) {
            // 图片还没加载完成，等待加载
            console.log('⏳ 等待图片加载完成...');
            qrImg.onload = () => {
              console.log('✅ 图片加载完成，绘制二维码');
              ctx.drawImage(qrImg, x, y, size, size);
              document.body.removeChild(tempDiv);
              resolve();
            };
            qrImg.onerror = () => {
              console.error('❌ 二维码图片加载失败');
              this.drawQRCodePlaceholder(ctx, x, y, size, '二维码图片加载失败');
              document.body.removeChild(tempDiv);
              resolve();
            };
            return; // 不要立即清理，等待图片加载
          } else {
            console.error('❌ 二维码生成失败，没有找到canvas或img元素');
            this.drawQRCodePlaceholder(ctx, x, y, size, '二维码元素未找到');
          }
          
          // 清理临时元素
          document.body.removeChild(tempDiv);
          resolve();
        }, 300); // 增加等待时间
        
      } catch (error) {
        console.error('❌ 创建二维码对象失败:', error);
        this.drawQRCodePlaceholder(ctx, x, y, size, '二维码对象创建失败');
        document.body.removeChild(tempDiv);
        resolve();
      }
    },

    // 绘制二维码占位符
    drawQRCodePlaceholder(ctx, x, y, size, message = '二维码生成失败') {
      // 绘制背景
      ctx.fillStyle = '#f5f5f5';
      ctx.fillRect(x, y, size, size);
      
      // 绘制边框
      ctx.strokeStyle = '#ddd';
      ctx.lineWidth = 2;
      ctx.strokeRect(x, y, size, size);
      
      // 绘制错误信息
      ctx.fillStyle = '#999';
      ctx.font = '14px Arial';
      ctx.textAlign = 'center';
      ctx.fillText(message, x + size / 2, y + size / 2 - 10);
      ctx.fillText('请检查网络连接', x + size / 2, y + size / 2 + 10);
    },

    // 绘制多行文本
    drawMultilineText(ctx, text, x, y, maxWidth, lineHeight, maxLines) {
      const words = text.split('');
      let line = '';
      let lineCount = 0;
      
      for (let i = 0; i < words.length && lineCount < maxLines; i++) {
        const testLine = line + words[i];
        const metrics = ctx.measureText(testLine);
        const testWidth = metrics.width;
        
        if (testWidth > maxWidth && i > 0) {
          ctx.fillText(line, x, y + lineHeight * lineCount);
          line = words[i];
          lineCount++;
        } else {
          line = testLine;
        }
      }
      
      if (lineCount < maxLines && line) {
        ctx.fillText(line, x, y + lineHeight * lineCount);
      }
    },

    // 商品相关方法
    async loadProducts() {
      if (!this.posterConfig.merId) return;
      
      try {
        this.productLoading = true;
        
        console.log('DEBUG: 开始加载商品列表，商户ID:', this.posterConfig.merId);
        
        const params = {
          page: this.pagination.page,
          limit: this.pagination.limit,
          merId: this.posterConfig.merId, // 传递商户ID  
          type: 1 // 1=上架商品（出售中）
        };
        
        if (this.productSearch) {
          params.keywords = this.productSearch;
        }
        
        console.log('请求商品列表，参数:', params);
        const response = await productLstApi(params);
        console.log('商品列表API响应:', response);
        
        // 根据API响应格式解析数据
        if (response && response.list && Array.isArray(response.list)) {
          // 直接从response中获取list（这是实际的API返回格式）
          this.productList = response.list;
          this.pagination.total = response.total || response.count || response.list.length;
          console.log('DEBUG: 使用response.list格式，商品数量:', response.list.length);
        } else if (response && response.data) {
          if (response.data.list) {
            this.productList = response.data.list;
            this.pagination.total = response.data.total || 0;
            console.log('DEBUG: 使用response.data.list格式，商品数量:', response.data.list.length);
          } else if (Array.isArray(response.data)) {
            this.productList = response.data;
            this.pagination.total = response.data.length;
            console.log('DEBUG: 使用response.data数组格式，商品数量:', response.data.length);
          } else {
            console.log('DEBUG: response.data格式不匹配，设置空列表');
            this.productList = [];
            this.pagination.total = 0;
          }
        } else {
          console.log('DEBUG: response格式异常，设置空列表');
          this.productList = [];
          this.pagination.total = 0;
        }
        
        console.log(`成功加载商户${this.posterConfig.merId}的商品列表，数量:`, this.productList.length);
        
      } catch (error) {
        console.error('加载商品失败:', error);
        this.$message.error('加载商品失败: ' + (error.message || '未知错误'));
        this.productList = [];
        this.pagination.total = 0;
      } finally {
        this.productLoading = false;
      }
    },

    handleProductSearch() {
      if (this.searchTimer) {
        clearTimeout(this.searchTimer);
      }
      this.searchTimer = setTimeout(() => {
        this.pagination.page = 1;
        this.loadProducts();
      }, 500);
    },

    handleProductSelection(selection) {
      this.selectedProducts = selection;
    },

    handleProductPageChange(page) {
      this.pagination.page = page;
      this.loadProducts();
    },

    // 🔥 调试图片加载
    handleImageError(event, originalUrl) {
      console.error('❌ 表格图片加载失败:');
      console.error('  原始URL:', originalUrl);
      console.error('  处理后URL:', this.$imageUrl(originalUrl));
      console.error('  实际请求URL:', event.target.src);
    },

    handleImageLoad(event, originalUrl) {
      console.log('✅ 表格图片加载成功:');
      console.log('  原始URL:', originalUrl);
      console.log('  处理后URL:', this.$imageUrl(originalUrl));
      console.log('  实际请求URL:', event.target.src);
    },

    // 🔥 简单的图片URL处理（用于表格显示）
    getImageUrl(imageUrl) {
      if (!imageUrl) return '';
      
      // 对于表格显示，使用标准的$imageUrl处理
      return this.$imageUrl ? this.$imageUrl(imageUrl) : imageUrl;
    },

    // 🔥 获取同源图片URL（确保不会被Canvas污染）
    getSameOriginImageUrl(originalUrl) {
      if (!originalUrl) return '';
      
      console.log('🔧 处理图片URL:', originalUrl);
      
      // 使用$imageUrl处理，然后转换为同源
      let processedUrl = this.$imageUrl ? this.$imageUrl(originalUrl) : originalUrl;
      console.log('🔧 $imageUrl处理后:', processedUrl);
      
      // 🎯 正确的同源转换：直接使用 /crmebimage/ 路径
      if (processedUrl.includes('https://api1.hqlccn.com/crmebimage/')) {
        processedUrl = processedUrl.replace('https://api1.hqlccn.com', '');
        console.log('🔧 转换为同源URL:', processedUrl);
      } else if (processedUrl.includes('http://localhost:20008/crmebimage/')) {
        processedUrl = processedUrl.replace('http://localhost:20008', '');
        console.log('🔧 转换为同源URL（本地）:', processedUrl);
      }
      
      console.log('🔧 最终同源URL:', processedUrl);
      return processedUrl;
    },

    confirmProductSelection() {
      if (this.selectedProducts.length > 0) {
        if (this.selectedProducts.length === 1) {
          // 单个商品选择
          this.selectedProduct = this.selectedProducts[0];
          this.posterConfig.productId = this.selectedProduct.id;
          
          // 验证商品信息完整性
          console.log('🔍 验证选中商品信息:', {
            id: this.selectedProduct.id,
            storeName: this.selectedProduct.storeName,
            price: this.selectedProduct.price,
            image: this.selectedProduct.image,
            status: this.selectedProduct.status,
            isShow: this.selectedProduct.isShow
          });
          
          // 检查商品是否可用
          if (!this.selectedProduct.id || this.selectedProduct.id <= 0) {
            this.$message.error('选中的商品ID无效，请重新选择');
            return;
          }
          
          // 检查商品状态
          if (this.selectedProduct.status === 0 || this.selectedProduct.isShow === 0) {
            this.$message.warning('选中的商品已下架，生成的二维码可能无法访问');
          }
          
          // 自动填入商品名称作为海报标题
          if (this.selectedProduct.storeName) {
            this.posterConfig.title = this.selectedProduct.storeName;
          }
          
          console.log('✅ 已选择单个商品:', this.selectedProduct);
          console.log('📝 海报标题已更新为:', this.posterConfig.title);
          
          // 测试生成的URL是否有效
          const testUrl = this.generateProductUrl();
          console.log('🔗 将要生成的二维码URL:', testUrl);
          
          // 单个商品时生成预览
          this.generatePreview();
        } else {
          // 多个商品选择（批量模式）
          console.log(`✅ 已选择${this.selectedProducts.length}个商品进行批量生成:`, this.selectedProducts.map(p => `${p.storeName}(ID:${p.id})`));
          this.posterConfig.title = '批量生成模式'; // 批量模式下的默认标题
        }
        
        this.showProductDialog = false;
      }
    },

    // 验证商品URL是否可访问
    async validateProductUrl(productId) {
      try {
        const testUrl = `https://hqlccn.com/goods_detail/${productId}`;
        console.log('🔍 验证商品URL:', testUrl);
        
        // 这里可以添加实际的URL验证逻辑
        // 比如调用后端接口检查商品是否存在
        
        return true;
      } catch (error) {
        console.error('❌ 商品URL验证失败:', error);
        return false;
      }
    },

    // 通过代理加载图片
    async loadImageViaProxy(originalImageSrc) {
      try {
        console.log('尝试通过代理加载图片:', originalImageSrc);
        
        // 方案1：尝试使用CORS代理服务
        const corsProxyUrls = [
          `https://api.allorigins.win/raw?url=${encodeURIComponent(originalImageSrc)}`,
          `https://cors-anywhere.herokuapp.com/${originalImageSrc}`,
          // 如果有自己的代理服务，可以添加在这里
        ];
        
        for (const proxyUrl of corsProxyUrls) {
          try {
            console.log('尝试CORS代理:', proxyUrl);
            return proxyUrl;
          } catch (proxyError) {
            console.log('CORS代理失败:', proxyError);
            continue;
          }
        }
        
        // 方案2：尝试调用后端接口代理
        try {
          const response = await this.$http.post('/api/common/image/proxy', {
            imageUrl: originalImageSrc
          });
          
          if (response.data && response.data.success && response.data.data) {
            console.log('✅ 后端代理返回图片数据');
            return response.data.data;
          }
        } catch (apiError) {
          console.log('后端API代理失败:', apiError);
        }
        
        // 方案3：尝试转换为base64
        try {
          const base64Image = await this.convertImageToBase64(originalImageSrc);
          if (base64Image) {
            console.log('✅ 成功转换为base64');
            return base64Image;
          }
        } catch (base64Error) {
          console.log('base64转换失败:', base64Error);
        }
        
        console.log('所有代理方案都失败');
        return null;
      } catch (error) {
        console.error('代理加载图片失败:', error);
        return null;
      }
    },

    // 通过代理将图片转换为Base64（避免污染）
    async convertImageToBase64ViaProxy(originalImageSrc) {
      try {
        // 方案1：使用fetch + blob转base64
        try {
          const corsProxyUrls = [
            `https://api.allorigins.win/raw?url=${encodeURIComponent(originalImageSrc)}`,
            `https://cors-anywhere.herokuapp.com/${originalImageSrc}`,
          ];
          
          for (const proxyUrl of corsProxyUrls) {
            try {
              const response = await fetch(proxyUrl);
              if (response.ok) {
                const blob = await response.blob();
                const base64 = await this.blobToBase64(blob);
                return base64;
              }
            } catch (fetchError) {
              continue;
            }
          }
        } catch (fetchError) {
          // 继续尝试其他方案
        }
        
        // 方案2：使用后端API代理
        try {
          const response = await this.$http.post('/api/common/image/proxy', {
            imageUrl: originalImageSrc,
            returnType: 'base64'
          });
          
          if (response.data && response.data.success && response.data.data) {
            return response.data.data;
          }
        } catch (apiError) {
          // 继续尝试其他方案
        }
        
        // 方案3：尝试直接转换
        try {
          const base64 = await this.convertImageToBase64(originalImageSrc);
          if (base64) {
            return base64;
          }
        } catch (directError) {
          // 所有方案都失败
        }
        
        return null;
      } catch (error) {
        return null;
      }
    },

    // 将Blob转换为Base64
    async blobToBase64(blob) {
      return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => {
          resolve(reader.result);
        };
        reader.onerror = (error) => {
          reject(error);
        };
        reader.readAsDataURL(blob);
      });
    },

    // 尝试将图片转换为base64（通过canvas）
    async convertImageToBase64(imageSrc) {
      return new Promise((resolve) => {
        try {
          // 创建一个隐藏的img元素
          const img = new Image();
          img.crossOrigin = 'anonymous';
          
          img.onload = function() {
            try {
              // 创建临时canvas
              const canvas = document.createElement('canvas');
              const ctx = canvas.getContext('2d');
              
              canvas.width = img.width;
              canvas.height = img.height;
              
              // 绘制图片到canvas
              ctx.drawImage(img, 0, 0);
              
              // 转换为base64
              const base64 = canvas.toDataURL('image/png');
              resolve(base64);
            } catch (error) {
              console.error('canvas转base64失败:', error);
              resolve(null);
            }
          };
          
          img.onerror = function() {
            console.error('base64转换时图片加载失败');
            resolve(null);
          };
          
          // 尝试不同的图片URL格式
          const urlVariants = [
            imageSrc,
            imageSrc.replace('https://', 'http://'),
            imageSrc + '?t=' + Date.now(), // 添加时间戳避免缓存
          ];
          
          let currentIndex = 0;
          const tryNextUrl = () => {
            if (currentIndex < urlVariants.length) {
              img.src = urlVariants[currentIndex];
              currentIndex++;
            } else {
              resolve(null);
            }
          };
          
          img.onerror = tryNextUrl;
          tryNextUrl();
          
        } catch (error) {
          console.error('base64转换异常:', error);
          resolve(null);
        }
      });
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}

.selected-product {
  color: #67c23a;
  margin-left: 10px;
}

.box-card {
  margin-bottom: 20px;
}

.dialog-footer {
  text-align: right;
}
</style>
