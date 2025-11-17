import VueI18n from 'vue-i18n'
import Vue from 'vue'
import zh from './common/zh.js'
import en from './common/en.js'
import fr from './common/fr.js'
import th from './common/th.js'
import ru from './common/ru.js'

Vue.use(VueI18n)
export default new VueI18n({
	locale: uni.getStorageSync('locale') ? uni.getStorageSync('locale') :'en',
	messages:{
		'en': en,
		'zh': zh,
		'fr': fr,
		'th': th,
		'ru': ru
	}
})