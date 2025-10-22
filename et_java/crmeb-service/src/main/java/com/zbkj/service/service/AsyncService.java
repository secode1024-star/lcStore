package com.zbkj.service.service;



/**
 * 异步调用服务
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
public interface AsyncService {

    /**
     * 商品详情统计
     * @param proId 商品id
     * @param uid 用户uid
     */
    void productDetailStatistics(Integer proId, Integer uid);

    /**
     * 保存用户访问记录
     * @param userId 用户id
     * @param visitType 访问类型
     */
    void saveUserVisit(Integer userId, Integer visitType);



    /**
     * 社区笔记用户添加经验
     * @param userId 用户ID
     * @param noteId 文章ID
     */
    void noteUpExp(Integer userId, Integer noteId);


    /**
     * 社区笔记评论点赞与取消
     * @param replyId 评论ID
     * @param operationType 操作类型：add-点赞，sub-取消
     */
    void communityReplyLikeOrClean(Integer replyId, String operationType);

    /**
     * 社区笔记添加评论后置处理
     * @param noteId 笔记ID
     * @param parentId 一级评论ID，0-没有
     * @param replyId 评论ID
     */
    void noteAddReplyAfter(Integer noteId, Integer parentId, Integer replyId);

    /**
     * 社区评论删除后置处理
     * @param noteId 笔记ID
     * @param firstReplyId 一级笔记评论ID
     * @param replyId 评论ID
     * @param countReply 评论回复数量
     */
    void communityReplyDeleteAfter(Integer noteId, Integer firstReplyId, Integer replyId, Integer countReply);

    /**
     * 用户升级
     * @param userId 用户ID
     * @param userLevel 用户等级
     * @param exp 当前经验
     */
    void userLevelUp(Integer userId, Integer userLevel, Integer exp);

    /**
     * 社区笔记点赞与取消
     * @param noteId 笔记ID
     * @param operationType 操作类型：add-点赞，sub-取消
     */
    void communityNoteLikeOrClean(Integer noteId, String operationType);
}
