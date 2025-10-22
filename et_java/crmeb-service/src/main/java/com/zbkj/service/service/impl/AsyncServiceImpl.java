package com.zbkj.service.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.http.HttpUtil;
import com.alibaba.fastjson.JSONObject;
import com.zbkj.common.config.CrmebConfig;
import com.zbkj.common.constants.*;
import com.zbkj.common.model.record.BrowseRecord;
import com.zbkj.common.model.record.UserVisitRecord;
import com.zbkj.common.model.system.SystemUserLevel;
import com.zbkj.common.model.user.*;
import com.zbkj.common.utils.CrmebUtil;
import com.zbkj.common.utils.RedisUtil;
import com.zbkj.common.vo.PaidMemberBenefitsVo;
import com.zbkj.service.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 异步调用服务实现类
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
public class AsyncServiceImpl implements AsyncService {

    private final Logger logger = LoggerFactory.getLogger(AsyncServiceImpl.class);

    @Autowired
    private StoreProductService storeProductService;
    @Autowired
    private RedisUtil redisUtil;
    @Autowired
    private UserVisitRecordService userVisitRecordService;

    @Lazy
    @Autowired
    private UserService userService;
    @Lazy
    @Autowired
    private SystemConfigService systemConfigService;
    @Autowired
    private TransactionTemplate transactionTemplate;

    @Lazy
    @Autowired
    private UserExperienceRecordService userExperienceRecordService;
    @Lazy
    @Autowired
    private SystemUserLevelService systemUserLevelService;
    @Lazy
    @Autowired
    private UserLevelService userLevelService;
    @Lazy
    @Autowired
    private CommunityNotesService communityNotesService;
    @Lazy
    @Autowired
    private CommunityReplyService communityReplyService;

    @Lazy
    @Autowired
    private PaidMemberService paidMemberService;
    @Lazy
    @Autowired
    private BrowseRecordService browseRecordService;



    /**
     * 商品详情统计
     * @param proId 商品id
     * @param uid 用户uid
     */
    @Async
    @Override
    public void productDetailStatistics(Integer proId, Integer uid) {
        // 商品浏览量+1
        storeProductService.addBrowse(proId);
        // 商品浏览量统计(每日/商城)
        String yesterdayStr = DateUtil.date().toString(DateConstants.DATE_FORMAT_DATE);
        redisUtil.incrAndCreate(RedisConstants.PRO_PAGE_VIEW_KEY + yesterdayStr);
        // 商品浏览量统计(每日/个体)
        redisUtil.incrAndCreate(StrUtil.format(RedisConstants.PRO_PRO_PAGE_VIEW_KEY, yesterdayStr, proId));
        // 保存用户访问记录
        if (uid > 0) {
            UserVisitRecord visitRecord = new UserVisitRecord();
            visitRecord.setDate(DateUtil.date().toString(DateConstants.DATE_FORMAT_DATE));
            visitRecord.setUid(uid);
            visitRecord.setVisitType(VisitRecordConstants.VISIT_TYPE_DETAIL);
            userVisitRecordService.save(visitRecord);
            BrowseRecord browseRecord = browseRecordService.getByUidAndProId(uid, proId);
            if (ObjectUtil.isNull(browseRecord)) {
                browseRecord = new BrowseRecord();
                browseRecord.setUid(uid);
                browseRecord.setProductId(proId);
                browseRecord.setDate(DateUtil.date().toString(DateConstants.DATE_FORMAT_DATE));
                browseRecord.setCreateTime(DateUtil.date());
                browseRecordService.save(browseRecord);
            } else {
                browseRecord.setDate(DateUtil.date().toString(DateConstants.DATE_FORMAT_DATE));
                browseRecordService.myUpdate(browseRecord);
            }
        }

    }

    /**
     * 保存用户访问记录
     * @param userId 用户id
     * @param visitType 访问类型
     */
    @Async
    @Override
    public void saveUserVisit(Integer userId, Integer visitType) {
        UserVisitRecord visitRecord = new UserVisitRecord();
        visitRecord.setDate(DateUtil.date().toDateStr());
        visitRecord.setUid(userId);
        visitRecord.setVisitType(visitType);
        userVisitRecordService.save(visitRecord);
    }




    /**
     * 社区笔记用户添加经验
     *
     * @param userId 用户ID
     * @param noteId 文章ID
     */
    @Async
    @Override
    public void noteUpExp(Integer userId, Integer noteId) {

        String levelSwitch = systemConfigService.getValueByKey(UserLevelConstants.SYSTEM_USER_LEVEL_SWITCH);
        if (!Constants.COMMON_SWITCH_OPEN.equals(levelSwitch)) {
            // 开启会员后，才进行经验添加
            return;
        }
        String noteExpStr = systemConfigService.getValueByKeyException(UserLevelConstants.SYSTEM_USER_LEVEL_COMMUNITY_NOTES_EXP);
        if (noteExpStr.equals("0")) {
            return;
        }
        String noteNum = systemConfigService.getValueByKeyException(UserLevelConstants.SYSTEM_USER_LEVEL_COMMUNITY_NOTES_NUM);
        if (noteNum.equals("0")) {
            return;
        }
        if (userExperienceRecordService.isExistNote(userId, noteId)) {
            return;
        }
        Integer noteCountToday = userExperienceRecordService.getCountByNoteToday(userId);
        if (noteCountToday >= Integer.parseInt(noteNum)) {
            return;
        }
        User user = userService.getById(userId);
        int noteExp = Integer.parseInt(noteExpStr);
        if (user.getIsPaidMember()) {
            List<PaidMemberBenefitsVo> benefitsList = paidMemberService.getBenefitsList();
            for (PaidMemberBenefitsVo b : benefitsList) {
                if (b.getStatus()) {
                    if (b.getName().equals("experienceDoubling") && b.getMultiple() > 1 && b.getChannelStr().contains("2")) {
                        noteExp = noteExp * b.getMultiple();
                    }
                }
            }
        }
        UserExperienceRecord record = new UserExperienceRecord();
        record.setUid(userId);
        record.setLinkId(noteId.toString());
        record.setLinkType(ExperienceRecordConstants.EXPERIENCE_RECORD_LINK_TYPE_NOTE);
        record.setType(ExperienceRecordConstants.EXPERIENCE_RECORD_TYPE_ADD);
        record.setTitle(ExperienceRecordConstants.EXPERIENCE_RECORD_TITLE_NOTE);
        record.setExperience(noteExp);
        record.setBalance(user.getExperience() + noteExp);
//        record.setMark(StrUtil.format("社区发布笔记奖励{}经验", noteExp));
        record.setMark(StrUtil.format("社区发布种草奖励{}经验", noteExp));
        record.setCreateTime(DateUtil.date());

        int finalNoteExp = noteExp;
        Boolean execute = transactionTemplate.execute(e -> {
            userService.updateExperience(userId, finalNoteExp, Constants.OPERATION_TYPE_ADD);
            userExperienceRecordService.save(record);
            userLevelUp(userId, user.getLevel(), user.getExperience() + finalNoteExp);
            return Boolean.TRUE;
        });
        if (!execute) {
            logger.error("用户社区发布笔记添加经验失败，userId={},noteId={}", userId, noteId);
        }
    }



    /**
     * 社区笔记评论点赞与取消
     *
     * @param replyId       评论ID
     * @param operationType 操作类型：add-点赞，sub-取消
     */
    @Async
    @Override
    public void communityReplyLikeOrClean(Integer replyId, String operationType) {
        communityReplyService.operationLike(replyId, operationType);
    }

    /**
     * 社区笔记添加评论后置处理
     *
     * @param noteId   笔记ID
     * @param parentId 一级评论ID，0-没有
     * @param replyId  评论ID
     */
    @Async
    @Override
    public void noteAddReplyAfter(Integer noteId, Integer parentId, Integer replyId) {
        communityNotesService.operationReplyNum(noteId, 1, Constants.OPERATION_TYPE_ADD);
        if (parentId > 0) {
            communityReplyService.operationReplyNum(parentId, 1, Constants.OPERATION_TYPE_ADD);
        }
    }

    /**
     * 社区评论删除后置处理
     *
     * @param noteId       笔记ID
     * @param firstReplyId 一级笔记评论ID
     * @param replyId      评论ID
     * @param countReply   评论回复数量
     */
    @Async
    @Override
    public void communityReplyDeleteAfter(Integer noteId, Integer firstReplyId, Integer replyId, Integer countReply) {
        if (firstReplyId > 0) {
            communityNotesService.operationReplyNum(noteId, 1, Constants.OPERATION_TYPE_SUBTRACT);
            communityReplyService.operationReplyNum(firstReplyId, 1, Constants.OPERATION_TYPE_SUBTRACT);
        } else {
            communityNotesService.operationReplyNum(noteId, 1 + countReply, Constants.OPERATION_TYPE_SUBTRACT);
        }
    }

    /**
     * 用户升级
     *
     * @param userId      用户ID
     * @param userLevelId 用户等级
     * @param exp         当前经验
     */
    @Async
    @Override
    public void userLevelUp(Integer userId, Integer userLevelId, Integer exp) {
        String levelSwitch = systemConfigService.getValueByKey(UserLevelConstants.SYSTEM_USER_LEVEL_SWITCH);
        if (levelSwitch.equals(Constants.COMMON_SWITCH_CLOSE)) {
            return;
        }
        SystemUserLevel userLevel = systemUserLevelService.getByLevelId(userLevelId);
        SystemUserLevel systemLevel = systemUserLevelService.getByExp(exp);
        if (userLevel.getGrade() >= systemLevel.getGrade()) {
            return;
        }
        if (systemLevel.getExperience() > exp) {
            systemLevel = systemUserLevelService.getPreviousGrade(systemLevel.getGrade());
        }

        UserLevel level = new UserLevel();
        level.setUid(userId);
        level.setLevelId(systemLevel.getId());
        level.setGrade(systemLevel.getGrade());

        userService.updateUserLevel(userId, level.getLevelId());
        userLevelService.deleteByUserId(userId);
        userLevelService.save(level);
    }

    /**
     * 社区笔记点赞与取消
     *
     * @param noteId        笔记ID
     * @param operationType 操作类型：add-点赞，sub-取消
     */
    @Async
    @Override
    public void communityNoteLikeOrClean(Integer noteId, String operationType) {
        communityNotesService.operationLike(noteId, operationType);
    }

}
