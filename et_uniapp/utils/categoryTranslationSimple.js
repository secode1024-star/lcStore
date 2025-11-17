/**
 * 简化版分类翻译服务
 * 使用静态翻译映射，避免API调用导致的加载问题
 */

// 分类翻译映射表 - 根据实际API返回的分类名称
const categoryTranslations = {
  // 从控制台看到的实际分类名称
  '电脑配件': {
    'en': 'Computer Accessories',
    'fr': 'Accessoires informatiques',
    'th': 'อุปกรณ์คอมพิวเตอร์',
    'ru': 'Компьютерные аксессуары',
    'ar': 'ملحقات الكمبيوتر',
    'ja': 'コンピューターアクセサリー',
    'ko': '컴퓨터 액세서리'
  },
  '外设产品': {
    'en': 'Peripheral Products',
    'fr': 'Produits périphériques',
    'th': 'ผลิตภัณฑ์อุปกรณ์ต่อพ่วง',
    'ru': 'Периферийные устройства',
    'ar': 'المنتجات الطرفية',
    'ja': '周辺機器',
    'ko': '주변기기'
  },
  '办公设备': {
    'en': 'Office Equipment',
    'fr': 'Équipement de bureau',
    'th': 'อุปกรณ์สำนักงาน',
    'ru': 'Офисное оборудование',
    'ar': 'معدات المكتب',
    'ja': 'オフィス機器',
    'ko': '사무용품'
  },
  '材料': {
    'en': 'Materials',
    'fr': 'Matériaux',
    'th': 'วัสดุ',
    'ru': 'Материалы',
    'ar': 'المواد',
    'ja': '材料',
    'ko': '재료'
  },
  '办公用品': {
    'en': 'Office Supplies',
    'fr': 'Fournitures de bureau',
    'th': 'อุปกรณ์สำนักงาน',
    'ru': 'Канцелярские товары',
    'ar': 'اللوازم المكتبية',
    'ja': '事務用品',
    'ko': '사무용품'
  },
  '财务办公': {
    'en': 'Financial Office',
    'fr': 'Bureau financier',
    'th': 'สำนักงานการเงิน',
    'ru': 'Финансовый офис',
    'ar': 'المكتب المالي',
    'ja': '財務オフィス',
    'ko': '재무 사무소'
  },
  '收纳整理': {
    'en': 'Storage & Organization',
    'fr': 'Rangement et organisation',
    'th': 'การจัดเก็บและจัดระเบียบ',
    'ru': 'Хранение и организация',
    'ar': 'التخزين والتنظيم',
    'ja': '収納・整理',
    'ko': '수납 정리'
  },
  // 添加更多实际分类
  '特色分类': {
    'en': 'Featured Categories',
    'fr': 'Catégories distinctives',
    'th': 'หมวดหมู่พิเศษ',
    'ru': 'Особые категории',
    'ar': 'فئات مميزة',
    'ja': '特色カテゴリー',
    'ko': '특색 카테고리'
  },
  '可能喜欢': {
    'en': 'You Might Like',
    'fr': 'Pourrais aussi aimer',
    'th': 'คุณอาจชอบ',
    'ru': 'Вам может понравиться',
    'ar': 'قد يعجبك أيضا',
    'ja': 'おすすめ',
    'ko': '추천 상품'
  }
};

class SimpleCategoryTranslation {
  /**
   * 获取翻译后的分类名称
   * @param {Object} category - 分类对象
   * @param {string} targetLanguage - 目标语言
   * @returns {string} 翻译后的名称
   */
  getTranslatedCategoryName(category, targetLanguage = null) {
    if (!category || !category.name) {
      return '';
    }

    // 获取当前语言
    const lang = targetLanguage || uni.getStorageSync('locale') || 'zh';
    
    // 如果是中文，直接返回原名称
    if (lang === 'zh' || lang === 'zh-CN') {
      return category.name;
    }

    // 查找翻译映射
    const translations = categoryTranslations[category.name];
    if (translations && translations[lang]) {
      return translations[lang];
    }

    // 如果没有找到翻译，返回原名称
    return category.name;
  }

  /**
   * 翻译分类树
   * @param {Array} categoryTree - 分类树
   * @param {string} targetLanguage - 目标语言
   * @returns {Array} 翻译后的分类树
   */
  translateCategoryTree(categoryTree, targetLanguage) {
    if (!categoryTree || categoryTree.length === 0) {
      return categoryTree;
    }

    const lang = targetLanguage || uni.getStorageSync('locale') || 'zh';
    
    if (lang === 'zh' || lang === 'zh-CN') {
      return categoryTree;
    }

    return categoryTree.map(category => {
      const translatedCategory = { ...category };
      
      // 翻译当前分类名称
      translatedCategory.name = this.getTranslatedCategoryName(category, lang);
      
      // 递归翻译子分类
      if (category.childList && category.childList.length > 0) {
        translatedCategory.childList = this.translateCategoryTree(category.childList, lang);
      }
      
      return translatedCategory;
    });
  }

  /**
   * 添加新的翻译映射
   * @param {string} chineseName - 中文名称
   * @param {Object} translations - 翻译映射对象
   */
  addTranslation(chineseName, translations) {
    categoryTranslations[chineseName] = translations;
  }
}

// 创建单例实例
const simpleCategoryTranslation = new SimpleCategoryTranslation();

export default simpleCategoryTranslation;
