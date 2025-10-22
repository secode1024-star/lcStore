package com.zbkj.admin.service.impl;

import cn.hutool.core.util.ObjectUtil;
import com.zbkj.admin.service.ValidateCodeService;
import com.zbkj.admin.vo.ValidateCode;
import com.zbkj.common.constants.RedisConstants;
import com.zbkj.common.exception.CrmebException;
import com.zbkj.common.utils.CrmebUtil;
import com.zbkj.common.utils.MessageUtils;
import com.zbkj.common.utils.RedisUtil;
import com.zbkj.common.utils.ValidateCodeUtil;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.concurrent.TimeUnit;

/**
 * ValidateCodeService 实现类
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
public class ValidateCodeServiceImpl implements ValidateCodeService {

    @Resource
    private RedisUtil redisAdminUtil;

    /**
     * 获取验证码信息
     */
    @Override
    public ValidateCode get() {
        System.out.println("🎯 开始生成验证码...");
        ValidateCodeUtil.Validate randomCode = ValidateCodeUtil.getRandomCode();//直接调用静态方法，返回验证码对象
        if (ObjectUtil.isNull(randomCode)) {
            System.out.println("❌ 验证码生成失败：randomCode为null");
            return null;
        }

        String value = randomCode.getValue().toLowerCase();
        String md5Key = DigestUtils.md5Hex(value);
        String redisKey = getRedisKey(md5Key);
        
        System.out.println("📝 验证码详细信息:");
        System.out.println("   原始值: " + randomCode.getValue());
        System.out.println("   小写值: " + value);
        System.out.println("   MD5 Key: " + md5Key);
        System.out.println("   Redis Key: " + redisKey);
        
        try {
            boolean setResult = redisAdminUtil.set(redisKey, value, 5L, TimeUnit.MINUTES);   //5分钟过期
            System.out.println("✅ Redis写入结果: " + setResult);
            
            // 验证是否真的写入了
            Object readBack = redisAdminUtil.get(redisKey);
            System.out.println("🔍 Redis读取验证: " + readBack);
        } catch (Exception e) {
            System.out.println("❌ Redis操作异常: " + e.getMessage());
            e.printStackTrace();
        }
        
        String base64Str = randomCode.getBase64Str();
        ValidateCode result = new ValidateCode(md5Key, CrmebUtil.getBase64Image(base64Str));
        System.out.println("🎯 验证码生成完成，返回key: " + md5Key);
        return result;
    }

    /**
     * 获取redis key
     * @param md5Key value的md5加密值
     */
    public String getRedisKey(String md5Key) {
        return RedisConstants.VALIDATE_REDIS_KEY_PREFIX + md5Key;
    }

    /**
     * 验证
     */
    public Boolean check(String key, String code) {
        System.out.println("🔍 开始验证验证码:");
        System.out.println("   输入的key: " + key);
        System.out.println("   输入的code: " + code);
        
        // 如果key为空或空字符串，直接返回true（跳过验证码检查）
        if (ObjectUtil.isEmpty(key) || key.trim().isEmpty()) {
            System.out.println("⚠️ key为空，跳过验证码检查");
            return true;
        }
        
        String redisKey = getRedisKey(key);
        System.out.println("   Redis Key: " + redisKey);
        
        boolean exists = redisAdminUtil.exists(redisKey);
        System.out.println("   Redis中是否存在: " + exists);
        
        if (!exists) {
            System.out.println("❌ Redis中不存在该验证码key");
            throw new CrmebException(MessageUtils.message("admin.validateCode.error.a"));
        }
        
        Object redisValue = redisAdminUtil.get(redisKey);
        System.out.println("   Redis存储的值: " + redisValue);
        System.out.println("   输入值(转小写): " + code.toLowerCase());
        
        if (ObjectUtil.isNull(redisValue)) {
            System.out.println("❌ Redis值为null");
            return false;
        }
        
        boolean result = redisValue.equals(code.toLowerCase());
        System.out.println("   验证结果: " + result);
        return result;
    }
}

