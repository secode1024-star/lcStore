package com.zbkj.service.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.zbkj.common.constants.Constants;
import com.zbkj.common.constants.GroupConfigConstants;
import com.zbkj.common.constants.SysConfigConstants;
import com.zbkj.common.exception.CrmebException;
import com.zbkj.common.model.system.GroupConfig;
import com.zbkj.common.vo.PaidMemberBenefitsVo;
import com.zbkj.service.service.*;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * CdkeyLibraryServiceImpl 接口实现
 * +----------------------------------------------------------------------
 * | CRMEB [ CRMEB赋能开发者，助力企业发展 ]
 * +----------------------------------------------------------------------
 * | Copyright (c) 2016~2025 https://www.crmeb.com All rights reserved.
 * +----------------------------------------------------------------------
 * | Licensed CRMEB并不是自由软件，未经许可不能去掉CRMEB相关版权
 * +----------------------------------------------------------------------
 * | Author: CRMEB Team <admin@crmeb.com>
 * +----------------------------------------------------------------------
 */
@Service
public class PaidMemberServiceImpl implements PaidMemberService {

    @Autowired
    private GroupConfigService groupConfigService;





    /**
     * 获取付费会员会员权益
     */
    @Override
    public List<PaidMemberBenefitsVo> getBenefitsList() {
        List<GroupConfig> configList = groupConfigService.findByTag(GroupConfigConstants.TAG_PAID_MEMBER_BENEFITS, Constants.SORT_DESC, null);
        if (CollUtil.isEmpty(configList)) {
            return new ArrayList<>();
        }
        Iterator<GroupConfig> iterator = configList.iterator();
        List<PaidMemberBenefitsVo> voList = new ArrayList<>();
        while (iterator.hasNext()) {
            GroupConfig config = iterator.next();
            PaidMemberBenefitsVo vo = new PaidMemberBenefitsVo();
            BeanUtils.copyProperties(config, vo);
            int multiple = 1;
            String channelStr = "";
            if (StrUtil.isNotBlank(config.getLinkUrl())) {
                StrUtil.split(config.getLinkUrl(), ":");
                String[] split = config.getLinkUrl().split(":");
                String multipleStr = split[0];
                multiple = Integer.parseInt(multipleStr);
                channelStr = split[1];
                if (channelStr.equals("0")) {
                    channelStr = "";
                }
            }
            vo.setMultiple(multiple);
            vo.setChannelStr(channelStr);
            voList.add(vo);
        }
        return voList;
    }


}


