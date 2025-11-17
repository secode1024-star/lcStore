package com.zbkj.service.service.impl;

import cn.hutool.core.util.StrUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 异步翻译队列服务
 * 解决百度翻译API频率限制问题（54003错误）
 * 
 * 特点：
 * 1. 单线程队列处理，确保严格的顺序执行
 * 2. 可配置的翻译间隔，避免频率限制
 * 3. 支持优先级队列（紧急翻译可插队）
 * 4. 完善的错误处理和重试机制
 * 5. 实时监控队列状态
 */
@Slf4j
@Service
public class AsyncTranslationQueueService {

    @Autowired
    private com.zbkj.common.service.TranslationService commonTranslationService;

    /**
     * 翻译任务队列（使用优先级队列）
     */
    private final PriorityBlockingQueue<TranslationTask> taskQueue = new PriorityBlockingQueue<>();

    /**
     * 单线程执行器，确保翻译任务严格按顺序执行
     */
    private ExecutorService executor;

    /**
     * 队列处理线程是否运行
     */
    private volatile boolean running = false;

    /**
     * 翻译间隔（毫秒）- 可以根据API限制动态调整
     */
    private volatile long translationIntervalMs = 1500; // 默认1.5秒间隔，确保不超过频率限制，适用于标准版账户

    /**
     * 上次翻译时间
     */
    private final AtomicLong lastTranslationTime = new AtomicLong(0);

    /**
     * 任务计数器
     */
    private final AtomicLong taskCounter = new AtomicLong(0);

    /**
     * 翻译任务
     */
    public static class TranslationTask implements Comparable<TranslationTask> {
        private final long taskId;
        private final String sourceText;
        private final String targetLang;
        private final String sourceLang;
        private final String fieldName;
        private final CompletableFuture<String> future;
        private final int priority; // 优先级：0=最高，数字越大优先级越低
        private final long createTime;
        private int retryCount = 0;
        private final int maxRetries;

        public TranslationTask(long taskId, String sourceText, String targetLang, String sourceLang, 
                             String fieldName, int priority, int maxRetries) {
            this.taskId = taskId;
            this.sourceText = sourceText;
            this.targetLang = targetLang;
            this.sourceLang = sourceLang;
            this.fieldName = fieldName;
            this.priority = priority;
            this.maxRetries = maxRetries;
            this.createTime = System.currentTimeMillis();
            this.future = new CompletableFuture<>();
        }

        @Override
        public int compareTo(TranslationTask other) {
            // 首先按优先级排序（数字小的优先级高）
            int priorityCompare = Integer.compare(this.priority, other.priority);
            if (priorityCompare != 0) {
                return priorityCompare;
            }
            // 相同优先级按创建时间排序（先创建的先执行）
            return Long.compare(this.createTime, other.createTime);
        }

        // Getters
        public long getTaskId() { return taskId; }
        public String getSourceText() { return sourceText; }
        public String getTargetLang() { return targetLang; }
        public String getSourceLang() { return sourceLang; }
        public String getFieldName() { return fieldName; }
        public CompletableFuture<String> getFuture() { return future; }
        public int getPriority() { return priority; }
        public long getCreateTime() { return createTime; }
        public int getRetryCount() { return retryCount; }
        public int getMaxRetries() { return maxRetries; }
        public void incrementRetryCount() { this.retryCount++; }
    }

    @PostConstruct
    public void init() {
        // 创建单线程执行器
        executor = Executors.newSingleThreadExecutor(r -> {
            Thread t = new Thread(r, "AsyncTranslationQueue");
            t.setDaemon(true);
            return t;
        });

        running = true;
        
        // 启动队列处理线程
        executor.submit(this::processQueue);
        
        log.info("异步翻译队列服务已启动，翻译间隔: {}ms", translationIntervalMs);
    }

    @PreDestroy
    public void destroy() {
        running = false;
        
        if (executor != null) {
            executor.shutdown();
            try {
                if (!executor.awaitTermination(10, TimeUnit.SECONDS)) {
                    executor.shutdownNow();
                }
            } catch (InterruptedException e) {
                executor.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
        
        log.info("异步翻译队列服务已关闭");
    }

    /**
     * 提交翻译任务（普通优先级）
     */
    public CompletableFuture<String> submitTranslation(String sourceText, String targetLang, String sourceLang, String fieldName) {
        return submitTranslation(sourceText, targetLang, sourceLang, fieldName, 5, 3); // 默认优先级5，最多重试3次
    }

    /**
     * 提交翻译任务（指定优先级）
     */
    public CompletableFuture<String> submitTranslation(String sourceText, String targetLang, String sourceLang, 
                                                     String fieldName, int priority, int maxRetries) {
        if (StrUtil.isBlank(sourceText) || StrUtil.isBlank(targetLang)) {
            CompletableFuture<String> future = new CompletableFuture<>();
            future.complete(sourceText);
            return future;
        }

        long taskId = taskCounter.incrementAndGet();
        TranslationTask task = new TranslationTask(taskId, sourceText, targetLang, sourceLang, fieldName, priority, maxRetries);
        
        taskQueue.offer(task);
        
        log.debug("翻译任务已提交到队列: taskId={}, sourceText={}, targetLang={}, priority={}, queueSize={}", 
                taskId, sourceText, targetLang, priority, taskQueue.size());
        
        return task.getFuture();
    }

    /**
     * 提交高优先级翻译任务（紧急翻译）
     */
    public CompletableFuture<String> submitUrgentTranslation(String sourceText, String targetLang, String sourceLang, String fieldName) {
        return submitTranslation(sourceText, targetLang, sourceLang, fieldName, 0, 5); // 最高优先级，最多重试5次
    }

    /**
     * 队列处理主循环
     */
    private void processQueue() {
        log.info("翻译队列处理线程已启动");
        
        while (running) {
            try {
                // 从队列中获取任务（阻塞等待）
                TranslationTask task = taskQueue.poll(1, TimeUnit.SECONDS);
                if (task == null) {
                    continue; // 超时，继续循环
                }

                // 处理翻译任务
                processTranslationTask(task);
                
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log.warn("翻译队列处理线程被中断");
                break;
            } catch (Exception e) {
                log.error("翻译队列处理异常", e);
                // 继续处理下一个任务
            }
        }
        
        log.info("翻译队列处理线程已退出");
    }

    /**
     * 处理单个翻译任务
     */
    private void processTranslationTask(TranslationTask task) {
        try {
            // 确保翻译间隔
            ensureTranslationInterval();

            log.info("开始处理翻译任务: taskId={}, sourceText={}, targetLang={}, fieldName={}, retryCount={}/{}", 
                    task.getTaskId(), task.getSourceText(), task.getTargetLang(), 
                    task.getFieldName(), task.getRetryCount(), task.getMaxRetries());

            // 执行翻译
            String translatedText = executeTranslation(task);

            // 更新最后翻译时间
            lastTranslationTime.set(System.currentTimeMillis());

            if (StrUtil.isNotBlank(translatedText) && !task.getSourceText().equals(translatedText)) {
                // 翻译成功
                task.getFuture().complete(translatedText);
                log.debug("翻译任务完成: taskId={}, result={}", task.getTaskId(), translatedText);
            } else {
                // 翻译失败或返回原文
                handleTranslationFailure(task, "翻译返回空或原文");
            }

        } catch (Exception e) {
            log.error("翻译任务执行异常: taskId={}, error={}", task.getTaskId(), e.getMessage(), e);
            handleTranslationFailure(task, e.getMessage());
        }
    }

    /**
     * 确保翻译间隔
     */
    private void ensureTranslationInterval() {
        long currentTime = System.currentTimeMillis();
        long timeSinceLastTranslation = currentTime - lastTranslationTime.get();
        
        if (timeSinceLastTranslation < translationIntervalMs) {
            long waitTime = translationIntervalMs - timeSinceLastTranslation;
            log.debug("等待 {}ms 以确保翻译间隔", waitTime);
            try {
                Thread.sleep(waitTime);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                throw new RuntimeException("等待翻译间隔被中断", e);
            }
        }
    }

    /**
     * 执行翻译
     */
    private String executeTranslation(TranslationTask task) {
        String translatedText = null;
        
        try {
            // 只使用百度翻译，注释掉Google翻译避免混乱
            translatedText = commonTranslationService.translateWithBaidu(
                task.getSourceText(), task.getTargetLang(), task.getSourceLang());
            
            log.debug("百度翻译结果: taskId={}, sourceText={}, translatedText={}", 
                    task.getTaskId(), task.getSourceText(), translatedText);
            
        } catch (Exception e) {
            log.error("百度翻译API调用异常: taskId={}, error={}", task.getTaskId(), e.getMessage());
            
            // 检查是否是频率限制错误
            if (e.getMessage() != null && 
                (e.getMessage().contains("54003") || e.getMessage().contains("Invalid Access Limit"))) {
                // 动态增加翻译间隔
                adjustTranslationInterval(true);
                throw new RuntimeException("频率限制错误，已调整翻译间隔", e);
            }
            
            // 检查是否是不支持的语言错误
            if (e.getMessage() != null && 
                (e.getMessage().contains("58001") || e.getMessage().contains("INVALID_TO_PARAM"))) {
                log.warn("不支持的目标语言: {}, 跳过翻译", task.getTargetLang());
                return task.getSourceText(); // 返回原文
            }
            
            throw e;
        }
        
        return translatedText;
    }

    /**
     * 处理翻译失败
     */
    private void handleTranslationFailure(TranslationTask task, String errorMessage) {
        if (task.getRetryCount() < task.getMaxRetries()) {
            // 重试
            task.incrementRetryCount();
            
            // 计算重试延迟（指数退避）
            long retryDelay = Math.min(1000 * (1L << task.getRetryCount()), 30000); // 最大30秒
            
            log.warn("翻译任务失败，{}ms后重试: taskId={}, retryCount={}/{}, error={}", 
                    retryDelay, task.getTaskId(), task.getRetryCount(), task.getMaxRetries(), errorMessage);
            
            // 延迟后重新提交任务（Java 8兼容方式）
            ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
            scheduler.schedule(() -> {
                taskQueue.offer(task);
                scheduler.shutdown();
            }, retryDelay, TimeUnit.MILLISECONDS);
        } else {
            // 重试次数用完，返回原文
            log.error("翻译任务最终失败，返回原文: taskId={}, error={}", task.getTaskId(), errorMessage);
            task.getFuture().complete(task.getSourceText());
        }
    }

    /**
     * 动态调整翻译间隔
     */
    private void adjustTranslationInterval(boolean increase) {
        if (increase) {
            // 增加间隔（最大15秒）- 更保守的策略
            translationIntervalMs = Math.min(translationIntervalMs * 2, 15000);
            log.warn("检测到频率限制，增加翻译间隔至: {}ms", translationIntervalMs);
        } else {
            // 减少间隔（最小1500ms）- 保持更保守的最小间隔
            translationIntervalMs = Math.max(translationIntervalMs / 2, 1500);
            log.info("翻译稳定，减少翻译间隔至: {}ms", translationIntervalMs);
        }
    }

    /**
     * 获取队列状态
     */
    public QueueStatus getQueueStatus() {
        return new QueueStatus(
            taskQueue.size(),
            translationIntervalMs,
            taskCounter.get(),
            running
        );
    }

    /**
     * 队列状态
     */
    public static class QueueStatus {
        private final int queueSize;
        private final long translationInterval;
        private final long totalTasks;
        private final boolean running;

        public QueueStatus(int queueSize, long translationInterval, long totalTasks, boolean running) {
            this.queueSize = queueSize;
            this.translationInterval = translationInterval;
            this.totalTasks = totalTasks;
            this.running = running;
        }

        public int getQueueSize() { return queueSize; }
        public long getTranslationInterval() { return translationInterval; }
        public long getTotalTasks() { return totalTasks; }
        public boolean isRunning() { return running; }

        @Override
        public String toString() {
            return String.format("QueueStatus{queueSize=%d, interval=%dms, totalTasks=%d, running=%s}", 
                               queueSize, translationInterval, totalTasks, running);
        }
    }
}






