-- 翻译失败记录表
CREATE TABLE IF NOT EXISTS `eb_translation_failure_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '失败记录ID',
  `entity_type` varchar(50) NOT NULL COMMENT '实体类型',
  `entity_id` int(11) DEFAULT NULL COMMENT '实体ID',
  `field_name` varchar(100) NOT NULL COMMENT '字段名称',
  `source_language` varchar(10) NOT NULL DEFAULT 'zh-CN' COMMENT '源语言',
  `target_language` varchar(10) NOT NULL COMMENT '目标语言',
  `source_text` text NOT NULL COMMENT '源文本',
  `failure_reason` text COMMENT '失败原因',
  `retry_count` int(11) NOT NULL DEFAULT '0' COMMENT '重试次数',
  `max_retries` int(11) NOT NULL DEFAULT '3' COMMENT '最大重试次数',
  `status` varchar(20) NOT NULL DEFAULT 'pending' COMMENT '状态：pending-待重试，retrying-重试中，success-已成功，failed-最终失败',
  `mer_id` int(11) NOT NULL COMMENT '商户ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `last_retry_time` datetime DEFAULT NULL COMMENT '最后重试时间',
  PRIMARY KEY (`id`),
  KEY `idx_mer_id` (`mer_id`),
  KEY `idx_status` (`status`),
  KEY `idx_entity` (`entity_type`, `entity_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='翻译失败记录表';
