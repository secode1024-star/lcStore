/**
 * 分类翻译服务插件
 * 提供分类名称的多语言翻译功能
 */

class CategoryTranslationService {
  constructor(axios, i18n) {
    this.axios = axios;
    this.i18n = i18n;
    this.cache = new Map(); // 内存缓存
  }

  /**
   * 获取翻译后的分类名称
   * @param {Object} category - 分类对象
   * @param {string} targetLanguage - 目标语言，默认使用当前i18n语言
   * @returns {Promise<string>} 翻译后的名称
   */
  async getTranslatedCategoryName(category, targetLanguage = null) {
    if (!category || !category.name) {
      return '';
    }

    const lang = targetLanguage || this.i18n.locale;
    
    // 如果是中文，直接返回原名称
    if (lang === 'zh-CN') {
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
   * 执行分类翻译（仅从缓存获取，不调用API）
   * @param {Object} category - 分类对象
   * @param {string} targetLanguage - 目标语言
   * @param {string} cacheKey - 缓存键
   * @returns {Promise<string>} 翻译结果
   */
  async translateCategory(category, targetLanguage, cacheKey) {
    // 不再调用翻译API，直接返回原名称
    // 翻译应该在平台管理页面完成，这里只显示已翻译的内容
    console.log(`分类翻译已禁用，返回原名称: ${category.name}`);
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

    if (targetLanguage === 'zh-CN') {
      return {};
    }

    const translations = {};
    
    // 批量处理，但控制并发数量
    const batchSize = 3; // 限制并发数量
    for (let i = 0; i < categories.length; i += batchSize) {
      const batch = categories.slice(i, i + batchSize);
      const promises = batch.map(async (category) => {
        if (category && category.id && category.name) {
          const cacheKey = `category_${category.id}_${targetLanguage}`;
          
          // 检查是否已缓存
          if (this.cache.has(cacheKey)) {
            translations[category.id] = this.cache.get(cacheKey);
            return;
          }

          try {
            const translatedName = await this.getTranslatedCategoryName(category, targetLanguage);
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
   * 清除所有缓存
   */
  clearCache() {
    this.cache.clear();
    try {
      const keys = Object.keys(localStorage);
      keys.forEach(key => {
        if (key.startsWith('category_translation_')) {
          localStorage.removeItem(key);
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
      const cached = localStorage.getItem(key);
      if (cached) {
        const data = JSON.parse(cached);
        // 检查是否过期（24小时）
        if (Date.now() - data.timestamp < 24 * 60 * 60 * 1000) {
          return data.value;
        } else {
          localStorage.removeItem(key);
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
      localStorage.setItem(key, JSON.stringify(data));
    } catch (error) {
      console.warn('保存本地缓存失败:', error);
    }
  }
}

// Nuxt.js 插件导出
export default ({ $axios, app }, inject) => {
  const categoryTranslation = new CategoryTranslationService($axios, app.i18n);
  
  // 注入到 Vue 实例中
  inject('categoryTranslation', categoryTranslation);
}







