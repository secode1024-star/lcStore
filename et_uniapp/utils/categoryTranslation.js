/**
 * 分类翻译服务
 * 提供分类名称的多语言翻译功能
 */

class CategoryTranslationService {
  constructor() {
    this.cache = new Map(); // 内存缓存
  }

  /**
   * 获取翻译后的分类名称
   * @param {Object} category - 分类对象
   * @param {string} targetLanguage - 目标语言
   * @returns {Promise<string>} 翻译后的名称
   */
  async getTranslatedCategoryName(category, targetLanguage = null) {
    if (!category || !category.name) {
      return '';
    }

    // 获取当前语言
    const lang = targetLanguage || uni.getStorageSync('locale') || 'zh';
    
    // 如果是中文，直接返回原名称
    if (lang === 'zh' || lang === 'zh-CN') {
      return category.name;
    }

    const cacheKey = `category_${category.id}_${lang}`;
    
    // 先检查内存缓存
    if (this.cache.has(cacheKey)) {
      return this.cache.get(cacheKey);
    }

    // 检查本地存储缓存
    const localCached = this.getLocalCache(cacheKey);
    if (localCached) {
      this.cache.set(cacheKey, localCached);
      return localCached;
    }

    try {
      // 调用翻译服务
      const translatedName = await this.translateCategory(category, lang, cacheKey);
      return translatedName;
    } catch (error) {
      console.error(`获取分类翻译失败: ${category.name}`, error);
      // 翻译失败时返回原名称
      return category.name;
    }
  }

  /**
   * 执行分类翻译（暂时返回原名称，避免API调用问题）
   * @param {Object} category - 分类对象
   * @param {string} targetLanguage - 目标语言
   * @param {string} cacheKey - 缓存键
   * @returns {Promise<string>} 翻译结果
   */
  async translateCategory(category, targetLanguage, cacheKey) {
    // 暂时直接返回原名称，避免API调用导致的加载问题
    console.log(`分类翻译暂时禁用，返回原名称: ${category.name}`);
    return category.name;
  }

  /**
   * 批量翻译分类
   * @param {Array} categories - 分类数组
   * @param {string} targetLanguage - 目标语言
   * @returns {Promise<Object>} 翻译结果映射
   */
  async preloadTranslations(categories, targetLanguage) {
    if (!categories || categories.length === 0) {
      return {};
    }

    const lang = targetLanguage || uni.getStorageSync('locale') || 'zh';
    
    if (lang === 'zh' || lang === 'zh-CN') {
      return {};
    }

    const translations = {};
    
    // 批量处理，但控制并发数量
    const batchSize = 3; // 限制并发数量
    for (let i = 0; i < categories.length; i += batchSize) {
      const batch = categories.slice(i, i + batchSize);
      const promises = batch.map(async (category) => {
        if (category && category.id && category.name) {
          try {
            const translatedName = await this.getTranslatedCategoryName(category, lang);
            translations[category.id] = translatedName;
          } catch (error) {
            console.warn(`预加载分类翻译失败: ${category.name}`, error);
            translations[category.id] = category.name;
          }
        }
      });

      await Promise.all(promises);
      
      // 批次间稍作延迟，避免请求过于频繁
      if (i + batchSize < categories.length) {
        await new Promise(resolve => setTimeout(resolve, 100));
      }
    }

    console.log(`批量翻译完成，共处理 ${Object.keys(translations).length} 个分类`);
    return translations;
  }

  /**
   * 递归翻译分类树
   * @param {Array} categoryTree - 分类树
   * @param {string} targetLanguage - 目标语言
   * @returns {Promise<Array>} 翻译后的分类树
   */
  async translateCategoryTree(categoryTree, targetLanguage) {
    if (!categoryTree || categoryTree.length === 0) {
      return categoryTree;
    }

    const lang = targetLanguage || uni.getStorageSync('locale') || 'zh';
    
    if (lang === 'zh' || lang === 'zh-CN') {
      return categoryTree;
    }

    const translatedTree = [];
    
    for (const category of categoryTree) {
      const translatedCategory = { ...category };
      
      // 翻译当前分类名称
      try {
        translatedCategory.name = await this.getTranslatedCategoryName(category, lang);
      } catch (error) {
        console.warn(`翻译分类失败: ${category.name}`, error);
      }
      
      // 递归翻译子分类
      if (category.childList && category.childList.length > 0) {
        translatedCategory.childList = await this.translateCategoryTree(category.childList, lang);
      }
      
      translatedTree.push(translatedCategory);
    }
    
    return translatedTree;
  }

  /**
   * 清除所有缓存
   */
  clearCache() {
    this.cache.clear();
    try {
      const keys = uni.getStorageInfoSync().keys;
      keys.forEach(key => {
        if (key.startsWith('category_translation_')) {
          uni.removeStorageSync(key);
        }
      });
      console.log('分类翻译缓存已清除');
    } catch (error) {
      console.warn('清除本地缓存失败:', error);
    }
  }

  /**
   * 从本地存储获取缓存
   * @param {string} cacheKey - 缓存键
   * @returns {string|null} 缓存的翻译结果
   */
  getLocalCache(cacheKey) {
    try {
      const key = `category_translation_${cacheKey}`;
      const cached = uni.getStorageSync(key);
      if (cached) {
        const data = JSON.parse(cached);
        // 检查是否过期（24小时）
        if (Date.now() - data.timestamp < 24 * 60 * 60 * 1000) {
          return data.value;
        } else {
          uni.removeStorageSync(key);
        }
      }
    } catch (error) {
      console.warn('获取本地缓存失败:', error);
    }
    return null;
  }

  /**
   * 保存到本地存储
   * @param {string} cacheKey - 缓存键
   * @param {string} value - 要缓存的值
   */
  setLocalCache(cacheKey, value) {
    try {
      const key = `category_translation_${cacheKey}`;
      const data = {
        value: value,
        timestamp: Date.now()
      };
      uni.setStorageSync(key, JSON.stringify(data));
    } catch (error) {
      console.warn('保存本地缓存失败:', error);
    }
  }
}

// 创建单例实例
const categoryTranslation = new CategoryTranslationService();

export default categoryTranslation;
