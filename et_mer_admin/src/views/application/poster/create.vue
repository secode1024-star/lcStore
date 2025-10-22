<template>
  <div class="app-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #e4e7ed;">
      <div>
        <h3 style="margin: 0 0 5px 0; font-size: 18px; font-weight: 600;">创建海报</h3>
        <p style="margin: 0; color: #909399; font-size: 14px;">选择商品并配置海报样式，生成专属推广海报</p>
      </div>
      <div>
        <el-button @click="$router.push('/application/poster')">返回列表</el-button>
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

        <el-form-item label="海报标题" prop="title">
          <el-input v-model="posterConfig.title" placeholder="请输入海报标题" />
        </el-form-item>

        <el-form-item label="选择商品">
          <el-button @click="showProductDialog = true">选择商品</el-button>
          <span v-if="selectedProduct" class="selected-product"> 已选择：{{ selectedProduct.storeName }} </span>
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
        <el-button type="primary" @click="submitForm" :loading="submitting">
          {{ submitting ? '生成中...' : '生成海报' }}
        </el-button>
        <el-button @click="generatePreview">预览海报</el-button>
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
            <img :src="scope.row.image" style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px;" />
          </template>
        </el-table-column>
        <el-table-column prop="storeName" label="商品名称" show-overflow-tooltip />
        <el-table-column prop="price" label="价格" width="100">
          <template slot-scope="scope">
            ¥{{ scope.row.price }}
          </template>
        </el-table-column>
        <el-table-column prop="stock" label="库存" width="80" />
        <el-table-column prop="sales" label="销量" width="80" />
      </el-table>

      <el-pagination
        @size-change="handleProductSizeChange"
        @current-change="handleProductCurrentChange"
        :current-page="pagination.page"
        :page-sizes="[10, 20, 50, 100]"
        :page-size="pagination.limit"
        layout="total, sizes, prev, pager, next, jumper"
        :total="pagination.total"
        style="margin-top: 20px; text-align: center;"
      />

      <div slot="footer" class="dialog-footer">
        <el-button @click="showProductDialog = false">取消</el-button>
        <el-button type="primary" @click="confirmProductSelection">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import request from '@/utils/request'
import { productLstApi } from '@/api/store'

export default {
  name: 'CreatePoster',
  data() {
    return {
      submitting: false,
      posterConfig: {
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
      previewTimer: null,
      rules: {
        title: [{ required: true, message: '请输入海报标题', trigger: 'blur' }],
        type: [{ required: true, message: '请选择海报类型', trigger: 'change' }],
      },
    };
  },
  mounted() {
    this.loadProducts();
    this.generatePreview();
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
    async submitForm() {
      let loading = null;
      try {
        const valid = await this.$refs.posterForm.validate();
        if (!valid) return;

        if (this.posterConfig.type === 'product' && !this.selectedProduct) {
          this.$message.error('请选择商品');
          return;
        }

        this.submitting = true;
        loading = this.$loading({
          lock: true,
          text: '正在生成海报...',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)'
        });

        console.log('开始生成海报...');
        const imageUrl = await this.generatePosterImage();
        console.log('海报生成完成，图片URL:', imageUrl);

        if (imageUrl) {
          // 保存海报记录到数据库
          await this.savePosterRecord(imageUrl);
          this.$message.success('海报生成成功！');
          this.$router.push('/application/poster');
        } else {
          throw new Error('图片生成失败');
        }
      } catch (error) {
        console.error('提交失败:', error);
        this.$message.error('生成失败：' + (error.message || '未知错误'));
      } finally {
        this.submitting = false;
        if (loading) loading.close();
      }
    },

    async generatePosterImage() {
      console.log('开始生成海报图片...');
      
      try {
        console.log('刷新预览...');
        await this.generatePosterPreview();
        
        const canvas = this.$refs.posterCanvas;
        if (!canvas) {
          throw new Error('Canvas元素未找到');
        }

        console.log('Canvas尺寸:', canvas.width, 'x', canvas.height);

        console.log('转换Canvas为Blob...');
        const imageUrl = await new Promise((resolve, reject) => {
          const self = this;
          canvas.toBlob(function(blob) {
            if (!blob) {
              reject(new Error('Canvas转换为Blob失败'));
              return;
            }
            console.log('Blob创建成功');
            console.log('Blob类型:', blob.type);
            console.log('Blob大小:', blob.size, 'bytes');

            self.uploadPosterBlob(blob).then(resolve).catch(reject);
          }, 'image/png', 0.9);
        });

        return imageUrl;
      } catch (error) {
        console.error('生成海报图片失败:', error);
        throw error;
      }
    },

    async uploadPosterBlob(blob) {
      try {
              const formData = new FormData();
        const filename = 'poster_' + Date.now() + '.png';
              formData.append('multipart', blob, filename);
              
              console.log('准备上传图片，文件名:', filename);
              
              const { fileImageApi } = await import('@/api/systemSetting');
              
              const posterCategoryId = await this.getPosterCategoryId();
        console.log('商品海报分类ID:', posterCategoryId);
              
              const testCategoryId = 859;
        console.log('测试使用硬编码分类ID:', testCategoryId);
              
              const uploadParams = {
                model: 'application',
          pid: testCategoryId,
              };
              
        console.log('上传参数:', uploadParams);
              if (posterCategoryId > 0) {
          console.log('将上传到商品海报分类');
              } else {
          console.log('将上传到默认分类（全部图片）');
              }
              
              console.log('调用上传API，参数:', uploadParams);
              console.log('FormData内容:', Array.from(formData.entries()));
              
              const uploadResponse = await fileImageApi(formData, uploadParams);
              console.log('=== 上传API完整响应 ===');
              console.log('Response status:', uploadResponse && uploadResponse.status);
              console.log('Response data:', JSON.stringify(uploadResponse, null, 2));
              
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

    async savePosterRecord(imageUrl) {
      try {
        console.log('开始保存海报记录到数据库...');
        const { createPosterApi } = await import('@/api/poster');
        
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
          })
        };
        
        console.log('保存海报数据:', posterData);
        console.log('posterImage字段值:', posterData.posterImage);
        const response = await createPosterApi(posterData);
        console.log('海报记录保存API响应:', response);
        console.log('响应数据:', JSON.stringify(response, null, 2));
        
      } catch (error) {
        console.error('保存海报记录失败:', error);
        // 不抛出错误，避免影响主流程
        this.$message.warning('海报图片生成成功，但保存记录时出现问题');
      }
    },

    async loadProducts() {
      console.log('DEBUG: 开始加载商品列表...');
      this.productLoading = true;
      try {
        const params = {
          page: this.pagination.page,
          limit: this.pagination.limit,
          type: '1' // 1=上架商品，0=下架商品，不传=全部
        };
        
        if (this.productSearch) {
          params.keywords = this.productSearch;
        }

        console.log('DEBUG: 请求参数:', params);
        const response = await productLstApi(params);
        console.log('DEBUG: API响应:', response);

        if (response && response.list) {
          this.productList = response.list;
          this.pagination.total = response.total || response.count || 0;
          console.log('DEBUG: 成功加载商品列表，数量:', response.list.length);
        } else if (response && response.data && response.data.list) {
          this.productList = response.data.list;
          this.pagination.total = response.data.total || response.data.count || 0;
          console.log('DEBUG: 使用response.data格式，商品数量:', response.data.list.length);
        } else {
          console.log('DEBUG: 响应格式异常，设置空列表');
          this.productList = [];
          this.pagination.total = 0;
        }
      } catch (error) {
        console.error('加载商品列表失败:', error);
        console.error('错误详情:', error.response || error.message);
        this.$message.error('加载商品列表失败: ' + (error.message || '未知错误'));
        this.productList = [];
        this.pagination.total = 0;
      } finally {
        this.productLoading = false;
      }
    },

    handleProductSearch() {
      clearTimeout(this.searchTimer);
      this.searchTimer = setTimeout(() => {
        this.pagination.page = 1;
        this.loadProducts();
      }, 500);
    },

    handleProductSizeChange(size) {
      this.pagination.limit = size;
      this.pagination.page = 1;
      this.loadProducts();
    },

    handleProductCurrentChange(page) {
      this.pagination.page = page;
      this.loadProducts();
    },

    handleProductSelection(selection) {
      this.selectedProducts = selection;
    },

    confirmProductSelection() {
      if (this.selectedProducts.length === 0) {
        this.$message.warning('请选择商品');
        return;
      }
      
      this.selectedProduct = this.selectedProducts[0];
      this.posterConfig.productId = this.selectedProduct.id;
      // 自动填充海报标题为商品名
      this.posterConfig.title = this.selectedProduct.storeName;
      // 自动生成商品详情页二维码URL
      this.posterConfig.qrCodeContent = this.generateProductUrl();
      this.showProductDialog = false;
      this.generatePosterPreview();
      
      this.$message.success('商品选择成功');
    },

    generatePreview() {
      clearTimeout(this.previewTimer);
      this.previewTimer = setTimeout(() => {
        this.$nextTick(() => {
          this.generatePosterPreview();
        });
      }, 300);
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
        throw new Error('未选择商品，无法生成海报');
      }
      
      // 定义海报布局（750x1334）
      // 上半部分（3/5）= 800px，下半部分（2/5）= 534px
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

        // 2. 绘制商品图片（占满宽度）
        if (this.selectedProduct && this.selectedProduct.image) {
          console.log('绘制商品图片:', this.selectedProduct.image);
          
          // 预处理图片URL，尝试解决CORS问题
          const processedImageUrl = this.preprocessImageUrl(this.selectedProduct.image);
          console.log('处理后的图片URL:', processedImageUrl);
          
          await this.drawImageToCanvas(ctx, processedImageUrl, 
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

    async getPosterCategoryId() {
      try {
        const { treeCategroy } = await import('@/api/categoryApi');
        
        console.log('开始获取素材分类列表...');
        const categoryResponse = await treeCategroy({
          type: 2,   // 2=附件分类
          status: 1  // 1=启用状态
        });
        console.log('素材分类API响应:', categoryResponse);
        
        if (categoryResponse && categoryResponse.length > 0) {
          const findCategory = (categories, targetName) => {
      for (const category of categories) {
              console.log('检查分类:', category.name, 'ID:', category.id);
              if (category.name && category.name.includes(targetName)) {
                console.log('找到目标分类:', category.name, 'ID:', category.id);
                return category.id;
              }
        if (category.children && category.children.length > 0) {
                const childResult = findCategory(category.children, targetName);
                if (childResult) return childResult;
              }
            }
            return null;
          };
          
          const searchTerms = ['商品海报', '海报', '商品', '产品海报', '产品'];
          let foundCategoryId = null;
          
          for (const term of searchTerms) {
            console.log('搜索分类关键词:', term);
            foundCategoryId = findCategory(categoryResponse, term);
            if (foundCategoryId) {
              console.log('使用分类ID:', foundCategoryId, '关键词:', term);
              break;
            }
          }
          
          if (foundCategoryId) {
            return foundCategoryId;
          } else {
            console.log('未找到匹配的分类，将使用创建新分类');
            return await this.createPosterCategory();
          }
        } else {
          console.log('分类列表为空，将创建新分类');
          return await this.createPosterCategory();
        }
      } catch (error) {
        console.error('获取素材分类失败:', error);
        console.log('fallback: 将尝试创建新分类');
        return await this.createPosterCategory();
      }
    },

    async createPosterCategory() {
      try {
        console.log('开始创建商品海报分类...');
        const { categoryAddApi } = await import('@/api/categoryApi');
        
        const categoryData = {
          name: '商品海报',
          pid: 0,
          sort: 99
        };
        
        console.log('创建分类参数:', categoryData);
        const createResponse = await categoryAddApi(categoryData);
        console.log('创建分类响应:', createResponse);
        
        if (createResponse && createResponse.id) {
          console.log('成功创建商品海报分类，ID:', createResponse.id);
          return createResponse.id;
        } else {
          console.error('创建分类失败，响应无效');
          return 0;
        }
      } catch (error) {
        console.error('创建商品海报分类失败:', error);
        return 0;
      }
    },

    async getProductDetailWithCoupon(productId) {
      try {
        console.log('正在调用新的后端API获取商品详情:', 'admin/merchant/poster/product-detail/' + productId);
        console.log('完整URL应该是:', request.defaults.baseURL + 'admin/merchant/poster/product-detail/' + productId);
        const response = await request.get('admin/merchant/poster/product-detail/' + productId);
        console.log('后端返回的商品详情（含优惠券):', response);
        console.log('couponPriceResult:', response.couponPriceResult);
        return response;
      } catch (error) {
        console.error('获取商品详情失败:', error);
        console.error('错误详情:', error.response || error.message);
        console.error('请求URL:', error.config && error.config.url);
        return null;
      }
    },

    async calculateCouponPrice() {
      if (!this.selectedProduct) return null;
      
      try {
        console.log('开始计算优惠券价格，商品ID:', this.selectedProduct.id);
        const productDetail = await this.getProductDetailWithCoupon(this.selectedProduct.id);
        
        if (productDetail && productDetail.couponPriceResult) {
          console.log('获取到优惠券价格信息:', productDetail.couponPriceResult);
          return productDetail.couponPriceResult;
        } else {
          console.log('未获取到优惠券价格信息');
          return null;
        }
      } catch (error) {
        console.error('计算优惠券价格失败:', error);
        return null;
      }
    },


    drawBasicPoster(ctx) {
      ctx.fillStyle = '#333333';
      ctx.font = 'bold 32px Arial';
      ctx.textAlign = 'center';
      ctx.fillText(this.posterConfig.title, this.posterConfig.width / 2, 100);
      
      ctx.fillStyle = '#666666';
      ctx.font = '24px Arial';
      ctx.fillText('请选择商品以生成商品海报', this.posterConfig.width / 2, 150);
    },

    // 绘制顶部文字
    drawHeaderText(ctx, area) {
      ctx.font = 'bold 24px Arial';
      ctx.fillStyle = '#333333';
      ctx.textAlign = 'center';
      ctx.fillText('推荐一个好物给你，请查收', area.width / 2, area.y + 35);
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
        await this.drawProductInfo(ctx, infoLayout.productInfo);

        // 绘制二维码
        await this.drawQRCode(ctx, infoLayout.qrCode);

      } catch (error) {
        console.error('绘制信息区域失败:', error);
      }
    },

    // 绘制商品信息
    async drawProductInfo(ctx, area) {
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
        // 获取优惠券价格信息
        const couponPriceInfo = await this.calculateCouponPrice();
        
        let originalPrice = (this.selectedProduct && this.selectedProduct.price) ? this.selectedProduct.price : '0.00';
        let finalPrice = originalPrice;
        let hasCoupon = false;
        
        if (couponPriceInfo && couponPriceInfo.hasCoupon) {
          console.log('找到优惠券！', couponPriceInfo);
          finalPrice = couponPriceInfo.finalPrice;
          hasCoupon = true;
        }

        ctx.textAlign = 'left';

        if (hasCoupon) {
          // 显示"特惠价"标签
          ctx.fillStyle = '#ff4444';
          ctx.fillRect(x, y - 25, 80, 30);
          ctx.fillStyle = '#ffffff';
          ctx.font = 'bold 16px Arial';
          ctx.textAlign = 'center';
          ctx.fillText('特惠价', x + 40, y - 5);
          
          // 显示优惠后价格（大号红色）
          ctx.fillStyle = '#ff4444';
          ctx.font = 'bold 48px Arial';
          ctx.textAlign = 'left';
          ctx.fillText('￥' + finalPrice, x, y + 30);
          
          // 显示原价（小号灰色，带删除线）
          ctx.fillStyle = '#999999';
          ctx.font = 'normal 28px Arial';
          const originalPriceText = '￥' + originalPrice;
          const originalPriceWidth = ctx.measureText(originalPriceText).width;
          ctx.fillText(originalPriceText, x + 200, y + 30);
          
          // 绘制删除线
          ctx.strokeStyle = '#999999';
          ctx.lineWidth = 2;
          ctx.beginPath();
          ctx.moveTo(x + 200, y + 15);
          ctx.lineTo(x + 200 + originalPriceWidth, y + 15);
          ctx.stroke();
          
          // 显示优惠信息
          const discountAmount = (parseFloat(originalPrice) - parseFloat(finalPrice)).toFixed(2);
          ctx.fillStyle = '#ff6600';
          ctx.font = 'bold 22px Arial';
          ctx.fillText('立减￥' + discountAmount, x, y + 70);
        } else {
          // 只显示原价
          ctx.fillStyle = '#ff4444';
          ctx.font = 'bold 48px Arial';
          ctx.fillText('￥' + originalPrice, x, y + 30);
        }
      } catch (error) {
        console.error('绘制价格信息失败:', error);
      }
    },

    // 绘制二维码
    async drawQRCode(ctx, area) {
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
        const qrSize = area.width - 20;
        const qrX = area.x + 10;
        const qrY = area.y + 10;
        
        try {
          // 方案1：调用后端接口生成真实二维码
          const response = await this.$http.post('/api/front/qrcode/str/to/base64', {
            text: productUrl,
            width: qrSize,
            height: qrSize
          });
          
          if (response.data && response.data.code) {
            // 绘制真实二维码
            const img = new Image();
            img.onload = () => {
              ctx.drawImage(img, qrX, qrY, qrSize, qrSize);
            };
            img.src = response.data.code;
          } else {
            // 如果接口调用失败，使用前端生成
            await this.generateQRCodeWithJS(ctx, productUrl, qrX, qrY, qrSize);
          }
        } catch (apiError) {
          console.error('调用二维码生成接口失败:', apiError);
          // 使用前端生成作为备选方案
          await this.generateQRCodeWithJS(ctx, productUrl, qrX, qrY, qrSize);
        }
        
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

    // 使用前端JS生成二维码（备选方案）
    async generateQRCodeWithJS(ctx, text, x, y, size) {
      return new Promise((resolve) => {
        try {
          // 创建临时div用于生成二维码
          const tempDiv = document.createElement('div');
          tempDiv.style.position = 'absolute';
          tempDiv.style.left = '-9999px';
          tempDiv.style.top = '-9999px';
          tempDiv.style.width = size + 'px';
          tempDiv.style.height = size + 'px';
          document.body.appendChild(tempDiv);
          
          // 动态导入qrcodejs2
          import('qrcodejs2').then((QRCodeModule) => {
            const QRCode = QRCodeModule.default || QRCodeModule;
            
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
              
              if (qrCanvas) {
                ctx.drawImage(qrCanvas, x, y, size, size);
              } else if (qrImg && qrImg.complete) {
                ctx.drawImage(qrImg, x, y, size, size);
              } else {
                // 如果都失败，绘制占位符
                this.drawQRCodePlaceholder(ctx, x, y, size);
              }
              
              // 清理临时元素
              document.body.removeChild(tempDiv);
              resolve();
            }, 200);
            
          }).catch((error) => {
            console.error('导入qrcodejs2失败:', error);
            this.drawQRCodePlaceholder(ctx, x, y, size);
            document.body.removeChild(tempDiv);
            resolve();
          });
          
        } catch (error) {
          console.error('前端二维码生成失败:', error);
          this.drawQRCodePlaceholder(ctx, x, y, size);
          resolve();
        }
      });
    },

    // 绘制二维码占位符（当真实二维码生成失败时使用）
    drawQRCodePlaceholder(ctx, x, y, size) {
      ctx.fillStyle = '#000000';
      const blockSize = size / 15;
      for (let i = 0; i < 15; i++) {
        for (let j = 0; j < 15; j++) {
          if ((i + j) % 3 === 0 || (i % 4 === 0 && j % 4 === 0)) {
            ctx.fillRect(x + i * blockSize, y + j * blockSize, blockSize - 1, blockSize - 1);
          }
        }
      }
    },

    // 生成商品详情页URL
    generateProductUrl() {
      if (!this.selectedProduct || !this.selectedProduct.id) {
        return '';
      }
      
      // 生产环境商场前端地址
      const currentOrigin = window.location.origin;
      let mallBaseUrl;
      
      if (currentOrigin.includes('localhost') || currentOrigin.includes('127.0.0.1')) {
        // 本地开发环境：商户后台在9528，商场前端在8080
        mallBaseUrl = currentOrigin.replace(':9528', ':8080');
      } else {
        // 生产环境：使用固定的商场域名
        mallBaseUrl = 'https://hqlccn.com';
      }
      
      // 商场前端商品详情页路径
      const productDetailUrl = `${mallBaseUrl}/goods_detail/${this.selectedProduct.id}`;
      
      console.log('生成商品详情页URL:', productDetailUrl);
      return productDetailUrl;
    },

    drawMultilineText(ctx, text, x, y, maxWidth, lineHeight, maxLines = 10) {
      const words = text.split('');
      let line = '';
      let currentY = y;
      let lineCount = 0;

      for (let i = 0; i < words.length && lineCount < maxLines; i++) {
        const testLine = line + words[i];
        const metrics = ctx.measureText(testLine);
        const testWidth = metrics.width;

        if (testWidth > maxWidth && i > 0) {
          if (lineCount === maxLines - 1) {
            // 最后一行，添加省略号
            line = line.substring(0, line.length - 3) + '...';
          }
          ctx.fillText(line, x, currentY);
          line = words[i];
          currentY += lineHeight;
          lineCount++;
        } else {
          line = testLine;
        }
      }
      
      if (lineCount < maxLines && line) {
        ctx.fillText(line, x, currentY);
      }
    },

    drawImageToCanvas(ctx, imageSrc, x, y, width, height) {
      return new Promise((resolve, reject) => {
        console.log('开始加载图片:', imageSrc);
        
        const img = new Image();
        
        // 设置CORS处理
        img.crossOrigin = 'anonymous';
        
        img.onload = function() {
          try {
            console.log('图片加载成功，开始绘制到Canvas');
            ctx.drawImage(img, x, y, width, height);
            console.log('图片绘制完成');
            resolve();
          } catch (error) {
            console.error('绘制图片失败:', error);
            // 如果绘制失败，绘制占位符
            ctx.fillStyle = '#f0f0f0';
            ctx.fillRect(x, y, width, height);
            ctx.fillStyle = '#999999';
            ctx.font = '24px Arial';
            ctx.textAlign = 'center';
            ctx.fillText('图片加载失败', x + width/2, y + height/2);
            resolve();
          }
        };
        
        img.onerror = function(error) {
          console.error('❌ CORS图片加载失败:', imageSrc, error);
          console.log('尝试使用代理方式加载图片...');
          
          // 尝试使用后端代理加载图片
          this.loadImageViaProxy(imageSrc)
            .then(proxyImageSrc => {
              if (proxyImageSrc) {
                const proxyImg = new Image();
                proxyImg.onload = function() {
                  try {
                    console.log('✅ 代理图片加载成功，使用临时Canvas避免污染');
                    
                    // 🔥 关键修复：使用临时Canvas避免污染主Canvas
                    const tempCanvas = document.createElement('canvas');
                    tempCanvas.width = width;
                    tempCanvas.height = height;
                    const tempCtx = tempCanvas.getContext('2d');
                    
                    // 先绘制到临时Canvas
                    tempCtx.drawImage(proxyImg, 0, 0, width, height);
                    
                    // 🔥 关键：从临时Canvas复制到主Canvas（避免污染）
                    ctx.drawImage(tempCanvas, x, y, width, height);
                    
                    console.log('✅ 通过代理+临时Canvas成功绘制图片（无污染）');
                    resolve();
                  } catch (error) {
                    console.error('代理图片绘制失败:', error);
                    this.drawImagePlaceholder(ctx, x, y, width, height);
                    resolve();
                  }
                };
                proxyImg.onerror = function() {
                  console.error('代理图片也加载失败');
                  this.drawImagePlaceholder(ctx, x, y, width, height);
                  resolve();
                };
                proxyImg.src = proxyImageSrc;
              } else {
                this.drawImagePlaceholder(ctx, x, y, width, height);
                resolve();
              }
            })
            .catch(proxyError => {
              console.error('代理加载也失败:', proxyError);
              this.drawImagePlaceholder(ctx, x, y, width, height);
              resolve();
            });
        }.bind(this);
        
        // 重要：在设置src之前确保crossOrigin已设置
        setTimeout(() => {
          img.src = imageSrc;
        }, 0);
      });
    },

    // 绘制图片占位符
    drawImagePlaceholder(ctx, x, y, width, height) {
      // 绘制灰色背景
      ctx.fillStyle = '#f5f5f5';
      ctx.fillRect(x, y, width, height);
      
      // 绘制边框
      ctx.strokeStyle = '#dcdfe6';
      ctx.lineWidth = 2;
      ctx.strokeRect(x, y, width, height);
      
      // 绘制图片图标
      ctx.fillStyle = '#c0c4cc';
      ctx.font = '48px Arial';
      ctx.textAlign = 'center';
      ctx.fillText('🖼️', x + width/2, y + height/2 - 20);
      
      // 绘制提示文字
      ctx.fillStyle = '#909399';
      ctx.font = '20px Arial';
      ctx.fillText('图片加载失败', x + width/2, y + height/2 + 30);
    },

    // 通过后端代理加载图片
    async loadImageViaProxy(originalImageSrc) {
      try {
        console.log('尝试通过后端代理加载图片:', originalImageSrc);
        
        // 方案1：尝试使用CORS代理服务
        const corsProxyUrls = [
          `https://cors-anywhere.herokuapp.com/${originalImageSrc}`,
          `https://api.allorigins.win/raw?url=${encodeURIComponent(originalImageSrc)}`,
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

    // 预处理图片URL，尝试解决CORS问题
    preprocessImageUrl(originalUrl) {
      if (!originalUrl) return originalUrl;
      
      console.log('原始图片URL:', originalUrl);
      
      // 如果是相对路径或同域名，直接返回
      if (originalUrl.startsWith('/') || originalUrl.startsWith('./')) {
        return originalUrl;
      }
      
      // 检查是否是同域名
      try {
        const currentOrigin = window.location.origin;
        const imageUrl = new URL(originalUrl);
        if (imageUrl.origin === currentOrigin) {
          return originalUrl;
        }
      } catch (e) {
        console.log('URL解析失败:', e);
      }
      
      // 对于跨域图片，尝试多种解决方案
      
      // 方案1：如果是api1.hqlccn.com的图片，尝试使用CORS代理
      if (originalUrl.includes('api1.hqlccn.com')) {
        // 尝试使用公共CORS代理（注意：生产环境应该使用自己的代理服务）
        const corsProxyUrl = `https://api.allorigins.win/raw?url=${encodeURIComponent(originalUrl)}`;
        console.log('使用CORS代理:', corsProxyUrl);
        return corsProxyUrl;
      }
      
      // 方案2：添加时间戳和CORS参数
      const separator = originalUrl.includes('?') ? '&' : '?';
      const processedUrl = `${originalUrl}${separator}t=${Date.now()}&cors=1`;
      
      console.log('添加时间戳和CORS参数:', processedUrl);
      return processedUrl;
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
};
</script>

<style scoped>
.selected-product {
  margin-left: 10px;
  color: #67c23a;
  font-weight: bold;
}

.box-card {
  margin-bottom: 0;
}

canvas {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
}

.dialog-footer {
  text-align: right;
}

.el-table {
  margin-top: 0;
}

.poster-preview {
  background: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  text-align: center;
}
</style>
      