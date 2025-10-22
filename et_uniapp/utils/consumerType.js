import Cache from "@/utils/cache";
export function chatConfig(mer){
	if(Cache.getItem('merPlatChatConfig') && !mer){
		let chatConfig = Cache.getItem('merPlatChatConfig');
		switch (chatConfig.consumerType){
			case 'h5':
				window.open(chatConfig.consumerH5Url);
				break;
			case 'message':
				window.open(chatConfig.consumerMessage);
				break;
			case 'hotline':
				uni.makePhoneCall({
					phoneNumber: chatConfig.consumerHotline
				});
				break;
			case 'email':
				parent.location.href = 'mailto:' + chatConfig.consumerEmail;
				break;
			default:
				location.href = chatConfig.consumerH5Url;
				break;
		}
	}
	if(Cache.get('merchantAPPInfo') && mer){
		let chatConfig = Cache.getItem('merchantAPPInfo');
		switch (chatConfig.serviceType){
			case 'H5':
				location.href = chatConfig.serviceLink;
				break;
			case 'message':
				window.open(chatConfig.serviceMessage);
				break;
			case 'phone':
				uni.makePhoneCall({
					phoneNumber: chatConfig.servicePhone
				});
				break;
			case 'email':
				parent.location.href = 'mailto:' + chatConfig.serviceEmail;
				break;
		}
	}
}