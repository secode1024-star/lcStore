<template>
  <div class="app-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h3>编辑海报</h3>
        <p class="header-desc">编辑和修改海报配置</p>
      </div>
      <div class="header-right">
        <el-button type="primary" @click="submitForm">保存修改</el-button>
        <el-button type="success" @click="testImageGeneration" style="margin-left: 10px;">测试图片生成</el-button>
        <el-button @click="$router.push('/application/poster')">返回列表</el-button>
      </div>
    </div>

    <!-- 加载状态 -->
    <div v-if="loading" v-loading="loading" style="height: 300px;"></div>

    <!-- 主要内容区域 -->
    <div v-else style="display: flex; gap: 20px; align-items: flex-start;">
      <!-- 左侧配置面板 -->
      <div style="flex: 1; min-width: 0;">
        <el-form
          ref="posterForm"
          :model="posterConfig"
          :rules="rules"
          label-width="120px"
        >
      <!-- 基础信息 -->
      <el-card class="box-card" style="margin-bottom: 20px;">
        <div slot="header" class="clearfix">
          <span>基础信息</span>
        </div>

        <el-form-item label="海报标题" prop="title">
          <el-input v-model="posterConfig.title" placeholder="请输入海报标题" />
        </el-form-item>

        <el-form-item label="海报类型" prop="type">
          <el-radio-group v-model="posterConfig.type">
            <el-radio label="product">商品海报</el-radio>
            <el-radio label="store">店铺海报</el-radio>
            <el-radio label="activity">活动海报</el-radio>
            <el-radio label="custom">自定义海报</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item v-if="posterConfig.type === 'product'" label="选择商品">
          <el-button @click="showProductDialog = true">
            {{ selectedProduct ? selectedProduct.storeName : '选择商品' }}
          </el-button>
        </el-form-item>
      </el-card>

      <!-- 海报设置 -->
      <el-card class="box-card" style="margin-bottom: 20px;">
        <div slot="header" class="clearfix">
          <span>海报设置</span>
        </div>

        <el-form-item label="海报尺寸">
          <el-row :gutter="20">
            <el-col :span="12">
              <el-input-number
                v-model="posterConfig.width"
                :min="100"
                :max="2000"
                controls-position="right"
                style="width: 100%"
              />
              <span style="margin-left: 10px">px</span>
            </el-col>
            <el-col :span="12">
              <el-input-number
                v-model="posterConfig.height"
                :min="100"
                :max="3000"
                controls-position="right"
                style="width: 100%"
              />
              <span style="margin-left: 10px">px</span>
            </el-col>
          </el-row>
        </el-form-item>

        <el-form-item label="背景颜色">
          <el-color-picker v-model="posterConfig.backgroundColor" />
        </el-form-item>

        <el-form-item v-if="posterConfig.type === 'product'" label="显示二维码">
          <el-switch v-model="showQRCode" />
          <div v-if="showQRCode && selectedProduct" style="margin-top: 10px; color: #67c23a; font-size: 12px;">
            <i class="el-icon-check"></i> 
            将自动生成该商品的商城详情页二维码
          </div>
          <div v-if="showQRCode && posterConfig.qrCodeContent" style="margin-top: 10px; color: #909399; font-size: 12px;">
            链接: {{ posterConfig.qrCodeContent }}
          </div>
        </el-form-item>
      </el-card>

      <!-- 操作按钮 -->
      <el-form-item>
        <el-button @click="$router.push('/application/poster')">取消</el-button>
        <el-button type="primary" @click="submitForm">更新海报</el-button>
      </el-form-item>
        </el-form>
      </div>

      <!-- 右侧预览面板 -->
      <div style="width: 300px; flex-shrink: 0;">
        <el-card style="position: sticky; top: 20px;">
          <div slot="header" class="clearfix">
            <span>海报预览</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="generatePreview">
              刷新预览
            </el-button>
          </div>
          
          <!-- 预览容器 -->
          <div style="display: flex; justify-content: center; align-items: center; margin: 20px 0; background: #f5f5f5; border-radius: 8px; padding: 20px;" :style="{ width: previewWidth + 'px', height: previewHeight + 'px' }">
            <canvas
              ref="posterCanvas"
              :width="posterConfig.width"
              :height="posterConfig.height"
              :style="{ 
                width: previewWidth + 'px', 
                height: previewHeight + 'px',
                backgroundColor: posterConfig.backgroundColor,
                border: '1px solid #ddd'
              }"
            ></canvas>
          </div>
          
          <!-- 预览信息 -->
          <div style="margin-top: 15px; padding: 10px; background: #f9f9f9; border-radius: 4px; font-size: 12px; color: #666;">
            <p style="margin: 5px 0;"><strong>尺寸:</strong> {{ posterConfig.width }}x{{ posterConfig.height }}px</p>
            <p style="margin: 5px 0;"><strong>背景:</strong> {{ posterConfig.backgroundColor }}</p>
            <p style="margin: 5px 0;" v-if="posterConfig.type === 'product' && selectedProduct">
              <strong>商品:</strong> {{ selectedProduct.storeName }}
            </p>
          </div>
        </el-card>
      </div>
    </div>

    <!-- 选择商品对话框 -->
    <el-dialog title="选择商品" :visible.sync="showProductDialog" width="80%">
      <div style="margin-bottom: 20px;">
        <el-input
          v-model="productSearch"
          placeholder="搜索商品名称"
          @input="handleSearchProduct"
          style="width: 300px; margin-right: 10px;"
        />
        <el-button type="primary" @click="loadProducts">搜索</el-button>
      </div>

      <el-table
        v-loading="productLoading"
        :data="productList"
        @selection-change="handleProductSelection"
        style="width: 100%"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="storeName" label="商品名称" min-width="200" />
        <el-table-column prop="price" label="价格" width="100">
          <template slot-scope="scope">
            ¥{{ scope.row.price }}
          </template>
        </el-table-column>
        <el-table-column prop="stock" label="库存" width="100" />
        <el-table-column prop="sales" label="销量" width="100" />
      </el-table>

      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="pagination.page"
        :page-sizes="[10, 20, 50]"
        :page-size="pagination.limit"
        layout="total, sizes, prev, pager, next, jumper"
        :total="pagination.total"
        style="margin-top: 20px; text-align: center;"
      />

      <div slot="footer" class="dialog-footer">
        <el-button @click="showProductDialog = false">取消</el-button>
        <el-button type="primary" @click="selectProduct">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { productLstApi } from '@/api/store';
import { posterDetailApi, updatePosterApi } from '@/api/poster';

export default {
  name: 'EditPoster',
  data() {
    return {
      loading: true,
      posterConfig: {
        id: null,
        title: '',
        type: 'product',
        productId: null,
        width: 750,
        height: 1334,
        backgroundColor: '#FFFFFF',
        qrCodeContent: '',
      },
      showQRCode: false,
      showProductDialog: false,
      selectedProduct: null,
      selectedProducts: [],
      productList: [],
      productLoading: false,
      productSearch: '',
      searchTimer: null,
      pagination: {
        page: 1,
        limit: 10,
        total: 0,
      },
      rules: {
        title: [{ required: true, message: '请输入海报标题', trigger: 'blur' }],
        type: [{ required: true, message: '请选择海报类型', trigger: 'change' }],
      },
      // 预览相关
      previewWidth: 250,
      previewHeight: 445,
    };
  },
  created() {
    this.loadPosterDetail();
  },
  methods: {
    // 加载海报详情
    async loadPosterDetail() {
      const posterId = this.$route.params.id;
      if (!posterId) {
        this.$message.error('海报ID不能为空');
        this.$router.push('/application/poster');
        return;
      }

      try {
        this.loading = true;
        console.log('调用 posterDetailApi，ID:', posterId);
        const response = await posterDetailApi(posterId);
        console.log('posterDetailApi 响应:', response);

        if (response) {
          console.log('加载海报详情成功:', response);
          this.posterConfig = {
            ...response,
            backgroundColor: response.backgroundColor || '#FFFFFF',
            qrCodeContent: response.qrCodeContent || '',
          };
          this.showQRCode = !!response.showQrCode;

          // 如果有关联商品，加载商品信息
          if (response.productId) {
            console.log('有关联商品，开始加载商品信息:', response.productId);
            await this.loadProductInfo(response.productId);
          } else {
            // 没有关联商品时也要生成预览
            console.log('没有关联商品，生成基础预览');
            this.$nextTick(() => {
              this.updatePreviewSize();
              this.generatePreview();
            });
          }
        } else {
          console.warn('posterDetailApi 返回空数据');
          this.$message.warning('未找到海报数据');
        }
      } catch (error) {
        console.error('加载海报详情失败:', error);
        this.$message.error('加载海报详情失败: ' + (error.message || '未知错误'));
      } finally {
        this.loading = false;
        console.log('海报详情加载完成，loading设置为false');
      }
    },

    // 加载商品信息
    async loadProductInfo(productId) {
      console.log('开始加载商品信息，productId:', productId);
      try {
        // 先尝试通过商品列表API查找指定ID的商品
        const params = {
          page: 1,
          limit: 50, // 增大限制，提高找到商品的概率
          type: '1', // 1=上架商品
        };
        
        console.log('请求商品列表参数:', params);
        const response = await productLstApi(params);
        console.log('商品列表API响应:', response);
        
        if (response && response.list && response.list.length > 0) {
          // 查找指定ID的商品
          const targetProduct = response.list.find(product => product.id == productId);
          
          if (targetProduct) {
            this.selectedProduct = targetProduct;
            console.log('找到目标商品:', this.selectedProduct);
          } else {
            console.log('在商品列表中未找到ID为', productId, '的商品，使用列表中第一个商品作为示例');
            // 如果没找到指定商品，使用列表中第一个作为示例
            this.selectedProduct = response.list[0];
            // 更新海报配置中的商品ID
            this.posterConfig.productId = this.selectedProduct.id;
          }
          
          // 如果没有二维码内容，自动生成
          if (!this.posterConfig.qrCodeContent && this.posterConfig.type === 'product') {
            this.generateProductQRCode();
            this.showQRCode = true;
          }
          
          // 商品信息加载完成后生成预览
          console.log('商品信息加载完成，准备生成预览');
          this.$nextTick(() => {
            this.generatePreview();
          });
        } else {
          console.log('商品列表为空，使用模拟数据');
          this.useSimulatedProductData(productId);
        }
      } catch (error) {
        console.error('加载商品信息失败:', error);
        this.useSimulatedProductData(productId);
      }
    },

    // 使用模拟商品数据
    useSimulatedProductData(productId) {
      console.log('使用模拟商品数据，productId:', productId);
      this.selectedProduct = { 
        id: productId, 
        storeName: 'Cotton Eyelet Midi Dress', 
        storeInfo: 'LAUREN Ralph Lauren Cotton Eyelet Midi Dress is a classic pick to wear on any casual day!',
        price: '245.00',
        otPrice: '300.00',
        image: 'crmebimage/public/maintain/2025/09/22/ff96b9d59d9c472684dff1cfbd6359f9ymc53k85rm.png'
      };
      
      // 生成二维码
      if (!this.posterConfig.qrCodeContent && this.posterConfig.type === 'product') {
        this.generateProductQRCode();
        this.showQRCode = true;
      }
      
      // 生成预览
      console.log('模拟数据准备完成，生成预览');
      this.$nextTick(() => {
        this.generatePreview();
      });
    },

    // 提交表单
    async submitForm() {
      try {
        const valid = await this.$refs.posterForm.validate();
        if (!valid) return;

        if (this.posterConfig.type === 'product' && !this.posterConfig.productId) {
          this.$message.error('请选择商品');
          return;
        }

        // 生成海报图片
        const loading = this.$loading({
          lock: true,
          text: '正在生成海报图片...',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)',
        });
        
        const posterImageUrl = await this.generatePosterImage();
        
        if (!posterImageUrl) {
          loading.close();
          this.$message.error('生成海报图片失败，请检查网络连接或稍后重试');
          return;
        }
        
        loading.close();

        const posterData = {
          id: this.posterConfig.id,
          title: this.posterConfig.title,
          type: this.posterConfig.type,
          productId: this.posterConfig.productId || null,
          width: this.posterConfig.width,
          height: this.posterConfig.height,
          backgroundColor: this.posterConfig.backgroundColor,
          showQrCode: this.showQRCode,
          qrCodeContent: this.showQRCode ? this.posterConfig.qrCodeContent : null,
          posterImage: posterImageUrl // 添加生成的海报图片URL
        };

        console.log('更新海报数据:', posterData);

        const response = await updatePosterApi(posterData);

        console.log('更新海报响应:', response);

        this.$message.success('海报更新成功！海报图片已保存');
        this.$router.push('/application/poster');
      } catch (error) {
        console.error('更新海报失败:', error);
        this.$message.error('更新海报失败: ' + (error.message || '未知错误'));
      }
    },

    // 生成海报图片并上传
    async generatePosterImage() {
      console.log('开始生成海报图片...');
      
      try {
        // 确保预览是最新的
        console.log('刷新预览...');
        this.generatePreview();
        
        // 等待Canvas绘制完成
        console.log('等待Canvas绘制完成...');
        await new Promise(resolve => setTimeout(resolve, 1500)); // 增加等待时间
        
        const canvas = this.$refs.posterCanvas;
        console.log('Canvas元素:', canvas);
        
        if (!canvas) {
          throw new Error('Canvas元素不存在，请确保预览面板已显示');
        }

        // 检查Canvas是否有内容
        const ctx = canvas.getContext('2d');
        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        const hasContent = imageData.data.some(channel => channel !== 0);
        
        if (!hasContent) {
          throw new Error('Canvas内容为空，请确保预览正常显示');
        }

        console.log('Canvas内容检查通过，开始转换为图片...');

        // 将Canvas转换为Blob
        return new Promise((resolve, reject) => {
          canvas.toBlob(async (blob) => {
            console.log('Canvas toBlob 回调，blob:', blob);
            
            if (!blob) {
              reject(new Error('Canvas转换为图片失败，可能是浏览器不支持'));
              return;
            }

            console.log('Blob大小:', blob.size, 'bytes');

            try {
              // 创建FormData上传图片
              const formData = new FormData();
              const filename = `poster_${Date.now()}.png`;
              formData.append('multipart', blob, filename);
              
              console.log('准备上传图片，文件名:', filename);
              
              // 调用系统的图片上传API
              const { fileImageApi } = await import('@/api/systemSetting');
              const uploadParams = {
                model: 'application',
                pid: 0,
              };
              
              console.log('调用上传API，参数:', uploadParams);
              const uploadResponse = await fileImageApi(formData, uploadParams);
              console.log('上传API响应:', uploadResponse);
              
              if (uploadResponse && uploadResponse.url) {
                console.log('海报图片上传成功:', uploadResponse.url);
                resolve(uploadResponse.url);
              } else {
                console.error('上传响应无效:', uploadResponse);
                reject(new Error('图片上传失败：服务器返回无效响应'));
              }
            } catch (error) {
              console.error('上传海报图片失败:', error);
              reject(new Error('图片上传失败：' + (error.message || '网络错误')));
            }
          }, 'image/png', 0.9);
        });
      } catch (error) {
        console.error('生成海报图片失败:', error);
        return null;
      }
    },

    // 测试图片生成功能
    async testImageGeneration() {
      console.log('测试图片生成功能...');
      
      const loading = this.$loading({
        lock: true,
        text: '正在测试图片生成...',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)',
      });
      
      try {
        const imageUrl = await this.generatePosterImage();
        loading.close();
        
        if (imageUrl) {
          this.$message.success('图片生成成功！URL: ' + imageUrl);
          console.log('生成的图片URL:', imageUrl);
        } else {
          this.$message.error('图片生成失败，请检查控制台错误信息');
        }
      } catch (error) {
        loading.close();
        console.error('测试图片生成失败:', error);
        this.$message.error('图片生成失败: ' + error.message);
      }
    },

    // 加载商品列表
    async loadProducts() {
      this.productLoading = true;
      try {
        const params = {
          page: this.pagination.page,
          limit: this.pagination.limit,
          keywords: this.productSearch || undefined,
          type: '1',
        };

        const response = await productLstApi(params);

        if (response && response.list) {
          this.productList = response.list;
          this.pagination.total = response.total || 0;
        } else {
          this.productList = [];
          this.pagination.total = 0;
        }
      } catch (error) {
        console.error('加载商品列表失败:', error);
        this.$message.error('加载商品列表失败');
        this.productList = [];
      } finally {
        this.productLoading = false;
      }
    },

    // 搜索商品防抖
    handleSearchProduct() {
      if (this.searchTimer) clearTimeout(this.searchTimer);
      this.searchTimer = setTimeout(() => {
        this.pagination.page = 1;
        this.loadProducts();
      }, 500);
    },

    // 分页相关
    handleSizeChange(size) {
      this.pagination.limit = size;
      this.pagination.page = 1;
      this.loadProducts();
    },

    handleCurrentChange(page) {
      this.pagination.page = page;
      this.loadProducts();
    },

    // 商品选择
    handleProductSelection(selection) {
      this.selectedProducts = selection;
    },

    selectProduct() {
      if (this.selectedProducts.length === 0) {
        this.$message.warning('请选择一个商品');
        return;
      }

      this.selectedProduct = this.selectedProducts[0];
      this.posterConfig.productId = this.selectedProduct.id;
      
      // 选择商品后自动生成商城商品详情页链接
      this.generateProductQRCode();
      
      // 如果是商品海报，默认启用二维码
      if (this.posterConfig.type === 'product') {
        this.showQRCode = true;
      }
      
      this.showProductDialog = false;
    },

    // 生成商品二维码链接
    generateProductQRCode() {
      if (this.selectedProduct && this.selectedProduct.id) {
        // 生成商城前端的商品详情页链接
        const baseUrl = window.location.origin.replace(':9527', ':8080'); // 商城前端端口通常是8080
        this.posterConfig.qrCodeContent = `${baseUrl}/pages/goods_details/index?id=${this.selectedProduct.id}`;
        
        console.log('生成商品二维码链接:', this.posterConfig.qrCodeContent);
      }
    },

    // 生成海报预览
    generatePreview() {
      this.$nextTick(() => {
        const canvas = this.$refs.posterCanvas;
        if (!canvas) {
          console.warn('Canvas元素未找到，预览生成失败');
          return;
        }

        console.log('正在生成海报预览...', {
          type: this.posterConfig.type,
          hasProduct: !!this.selectedProduct,
          showQRCode: this.showQRCode
        });

        const ctx = canvas.getContext('2d');
        
        // 清空画布
        ctx.clearRect(0, 0, this.posterConfig.width, this.posterConfig.height);
        
        // 设置背景色
        ctx.fillStyle = this.posterConfig.backgroundColor;
        ctx.fillRect(0, 0, this.posterConfig.width, this.posterConfig.height);
        
        if (this.posterConfig.type === 'product' && this.selectedProduct) {
          this.drawProductPoster(ctx);
        } else {
          this.drawBasicPoster(ctx);
        }
      });
    },

    // 绘制商品海报
    drawProductPoster(ctx) {
      const width = this.posterConfig.width;
      const height = this.posterConfig.height;
      
      // 绘制顶部推荐区域
      this.drawTopRecommendArea(ctx);
      
      // 绘制商品图片区域
      if (this.selectedProduct.image) {
        this.drawProductImageSection(ctx);
      }
      
      // 绘制商品信息区域
      this.drawProductInfoSection(ctx);
      
      // 绘制价格区域
      this.drawPriceSection(ctx);
      
      // 绘制二维码区域
      if (this.showQRCode) {
        this.drawQRCodeSection(ctx);
      }
      
      // 绘制底部品牌/店铺信息
      this.drawBottomBrandSection(ctx);
    },

    // 绘制基础海报
    drawBasicPoster(ctx) {
      // 绘制标题
      if (this.posterConfig.title) {
        ctx.fillStyle = '#333';
        ctx.font = 'bold 36px Arial, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText(this.posterConfig.title, this.posterConfig.width / 2, 80);
      }
      
      // 绘制类型标识
      ctx.fillStyle = '#3498db';
      ctx.font = '20px Arial, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText(this.getTypeText(), this.posterConfig.width / 2, this.posterConfig.height / 2);
    },

    // 绘制顶部推荐区域
    drawTopRecommendArea(ctx) {
      const width = this.posterConfig.width;
      const headerHeight = 60;
      
      // 绘制白色背景
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(0, 0, width, headerHeight);
      
      // 绘制浅灰色文字背景
      const textPadding = 20;
      const textHeight = 36;
      const textY = (headerHeight - textHeight) / 2;
      
      ctx.fillStyle = '#f5f5f5';
      ctx.fillRect(textPadding, textY, width - textPadding * 2, textHeight);
      
      // 绘制推荐文字
      ctx.fillStyle = '#666666';
      ctx.font = 'bold 20px Arial, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('🛒 推荐一个好物给你，请查收', width / 2, headerHeight / 2 + 6);
    },

    // 绘制商品图片区域
    drawProductImageSection(ctx) {
      const width = this.posterConfig.width;
      const height = this.posterConfig.height;
      
      // 图片区域从推荐区域下方开始
      const headerHeight = 60; // 推荐区域高度
      const imageAreaHeight = height * 0.35; // 调整为35%高度，给文字留出更多空间
      
      // 图片宽度占满整个海报宽度
      const imageWidth = width;
      const imageHeight = imageAreaHeight; // 图片高度
      
      const x = 0; // 从左边开始
      const y = headerHeight; // 从推荐区域下方开始
      
      // 绘制图片背景
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(x, y, imageWidth, imageHeight);
      
      // 加载并绘制商品图片
      this.drawProductImage(ctx, this.selectedProduct.image, x, y, imageWidth, imageHeight);
    },

    // 计算价格区域Y坐标
    calculatePriceAreaY() {
      const height = this.posterConfig.height;
      // 价格区域位于二维码上方，预留足够空间
      const qrCodeAreaHeight = 200; // 二维码区域高度
      const bottomMargin = 80; // 底部边距
      return height - qrCodeAreaHeight - bottomMargin;
    },

    // 绘制商品信息区域
    drawProductInfoSection(ctx) {
      const width = this.posterConfig.width;
      const height = this.posterConfig.height;
      
      // 商品信息区域直接紧跟图片下方
      const headerHeight = 60;
      const imageAreaHeight = height * 0.35; // 与图片区域高度保持一致
      let currentY = headerHeight + imageAreaHeight + 40; // 图片下方40px开始，增加更多间距
      
      // 绘制商品名称
      ctx.fillStyle = '#333333';
      ctx.font = 'bold 22px Arial, sans-serif';
      ctx.textAlign = 'center';
      
      const productName = this.selectedProduct.storeName || this.posterConfig.title;
      const nameHeight = this.drawMultilineText(ctx, productName, width / 2, currentY, 26, width - 40);
      currentY += nameHeight + 10; // 更新Y位置
      
      // 绘制商品描述
      if (this.selectedProduct.storeInfo) {
        ctx.fillStyle = '#666666';
        ctx.font = '14px Arial, sans-serif';
        
        // 限制描述长度，确保不会太长
        const desc = this.selectedProduct.storeInfo.length > 80 
          ? this.selectedProduct.storeInfo.substring(0, 80) + '...' 
          : this.selectedProduct.storeInfo;
        
        const descHeight = this.drawMultilineText(ctx, desc, width / 2, currentY, 18, width - 50);
        currentY += descHeight + 10; // 更新Y位置
      }
    },

    // 绘制价格区域
    drawPriceSection(ctx) {
      const width = this.posterConfig.width;
      const height = this.posterConfig.height;
      
      // 使用计算出的价格区域Y坐标
      const priceY = this.calculatePriceAreaY();
      
      if (this.selectedProduct.price) {
        // 价格背景
        const priceAreaHeight = 55;
        ctx.fillStyle = '#fff5f5';
        ctx.fillRect(20, priceY - 25, width - 40, priceAreaHeight);
        
        // 添加边框
        ctx.strokeStyle = '#ffebeb';
        ctx.lineWidth = 2;
        ctx.strokeRect(20, priceY - 25, width - 40, priceAreaHeight);
        
        // 价格标签
        ctx.fillStyle = '#ff4757';
        ctx.font = 'bold 32px Arial, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText(`¥${this.selectedProduct.price}`, width / 2, priceY + 8);
        
        // 原价（如果有）
        if (this.selectedProduct.otPrice && parseFloat(this.selectedProduct.otPrice) > parseFloat(this.selectedProduct.price)) {
          ctx.fillStyle = '#999999';
          ctx.font = '16px Arial, sans-serif';
          ctx.fillText(`原价: ¥${this.selectedProduct.otPrice}`, width / 2, priceY + 25);
          
          // 划线效果
          const originalPriceText = `原价: ¥${this.selectedProduct.otPrice}`;
          const textWidth = ctx.measureText(originalPriceText).width;
          ctx.strokeStyle = '#999999';
          ctx.lineWidth = 2;
          ctx.beginPath();
          ctx.moveTo((width - textWidth) / 2, priceY + 22);
          ctx.lineTo((width + textWidth) / 2, priceY + 22);
          ctx.stroke();
        }
      }
    },

    // 绘制二维码区域
    drawQRCodeSection(ctx) {
      const width = this.posterConfig.width;
      const height = this.posterConfig.height;
      
      // 增大二维码尺寸
      const qrSize = Math.min(160, width * 0.2); // 二维码大小为宽度的20%，最大160px
      const x = (width - qrSize) / 2;
      const y = height - qrSize - 120; // 距离底部120px，为底部文字留出更多空间
      
      // 二维码背景（调整高度，为说明文字留出空间）
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(x - 15, y - 15, qrSize + 30, qrSize + 60);
      
      // 添加阴影效果（调整阴影区域高度）
      ctx.shadowColor = 'rgba(0, 0, 0, 0.1)';
      ctx.shadowBlur = 8;
      ctx.shadowOffsetX = 0;
      ctx.shadowOffsetY = 4;
      ctx.fillRect(x - 15, y - 15, qrSize + 30, qrSize + 60);
      
      // 重置阴影
      ctx.shadowColor = 'transparent';
      ctx.shadowBlur = 0;
      ctx.shadowOffsetX = 0;
      ctx.shadowOffsetY = 0;
      
      // 绘制二维码占位符
      this.drawQRCode(ctx, x, y, qrSize);
      
      // 二维码说明文字（调整位置，确保不被遮挡）
      ctx.fillStyle = '#333333';
      ctx.font = 'bold 16px Arial, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('长按或扫描查看', x + qrSize / 2, y + qrSize + 35);
    },

    // 绘制底部品牌区域
    drawBottomBrandSection(ctx) {
      const width = this.posterConfig.width;
      const height = this.posterConfig.height;
      
      // 底部背景（调整高度和位置，确保不与二维码文字重叠）
      ctx.fillStyle = '#f8f9fa';
      ctx.fillRect(0, height - 50, width, 50);
      
      // 店铺/品牌信息（调整位置）
      ctx.fillStyle = '#666666';
      ctx.font = '14px Arial, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('价格具有时效性，具体请以商详为准', width / 2, height - 30);
      
      // 右下角类型标识（调整位置）
      ctx.fillStyle = '#3498db';
      ctx.font = '12px Arial, sans-serif';
      ctx.textAlign = 'right';
      ctx.fillText(this.getTypeText(), width - 20, height - 12);
    },

    // 绘制多行文本
    drawMultilineText(ctx, text, x, y, lineHeight, maxWidth) {
      const words = text.split('');
      let line = '';
      let currentY = y;
      const startY = y;
      
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
      
      // 返回实际绘制的高度
      return currentY - startY + lineHeight * 0.3; // 添加一点底部间距
    },

    // 绘制商品图片
    drawProductImage(ctx, imageUrl, x, y, width, height = null) {
      // 如果只传了width参数（向后兼容），当作正方形处理
      if (height === null) {
        height = width;
      }
      
      const img = new Image();
      img.crossOrigin = 'anonymous';
      img.onload = () => {
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
      };
      img.onerror = () => {
        // 绘制占位符
        ctx.fillStyle = '#f5f5f5';
        ctx.fillRect(x, y, width, height);
        ctx.strokeStyle = '#ddd';
        ctx.lineWidth = 2;
        ctx.strokeRect(x, y, width, height);
        
        ctx.fillStyle = '#999';
        ctx.font = '16px Arial, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('图片加载中...', x + width / 2, y + height / 2);
      };
      
      // 处理图片URL
      const processedUrl = this.$imageUrl ? this.$imageUrl(imageUrl) : imageUrl;
      img.src = processedUrl;
    },

    // 绘制二维码占位符
    drawQRCode(ctx, x, y, qrSize) {
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

    // 获取类型文本
    getTypeText() {
      const typeMap = {
        product: '商品海报',
        store: '店铺海报',
        activity: '活动海报',
        custom: '自定义海报'
      };
      return typeMap[this.posterConfig.type] || '海报';
    },

    // 更新预览尺寸
    updatePreviewSize() {
      const maxWidth = 250;
      const maxHeight = 400;
      const ratio = this.posterConfig.width / this.posterConfig.height;
      
      if (ratio > maxWidth / maxHeight) {
        this.previewWidth = maxWidth;
        this.previewHeight = maxWidth / ratio;
      } else {
        this.previewHeight = maxHeight;
        this.previewWidth = maxHeight * ratio;
      }
      
      this.$nextTick(() => {
        this.generatePreview();
      });
    },
  },

  watch: {
    // 监听配置变化，自动更新预览
    'posterConfig.title': function() {
      this.generatePreview();
    },
    'posterConfig.type': function() {
      this.generatePreview();
    },
    'posterConfig.backgroundColor': function() {
      this.generatePreview();
    },
    'posterConfig.width': function() {
      this.updatePreviewSize();
    },
    'posterConfig.height': function() {
      this.updatePreviewSize();
    },
    'selectedProduct': function() {
      // 选择商品时自动生成二维码链接
      if (this.selectedProduct) {
        this.generateProductQRCode();
      }
      this.generatePreview();
    },
    'showQRCode': function() {
      this.generatePreview();
    }
  },

  mounted() {
    console.log('编辑页面组件已挂载');
    // 初始化预览
    this.$nextTick(() => {
      console.log('组件挂载后初始化预览尺寸');
      this.updatePreviewSize();
    });
    
    // 延迟一点时间再次确保预览生成（防止数据还没完全加载）
    setTimeout(() => {
      if (this.posterConfig.id && this.$refs.posterCanvas) {
        console.log('延迟确保预览生成');
        this.generatePreview();
      }
    }, 500);
  },
};
</script>

<style scoped>
.box-card {
  margin-bottom: 20px;
}
</style>







