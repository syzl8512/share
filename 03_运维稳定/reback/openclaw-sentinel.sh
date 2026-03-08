#!/bin/bash
#
# OpenClaw Sentinel - 自动回滚守护进程 (优化版)
# 监控 /tmp/openclaw_guard.lock，超时自动回滚
#

LOCK_FILE="/tmp/openclaw_guard.lock"
BACKUP_DIR="$HOME/.openclaw/backups/latest"
CONFIG_DIR="$HOME/.openclaw"
LOG_FILE="$HOME/.openclaw/logs/sentinel.log"

# 超时时间（秒）- 5分钟
TIMEOUT=300

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 确保日志目录存在
mkdir -p "$(dirname "$LOG_FILE")"

log "Sentinel 启动，监控模式已开启..."

while true; do
    if [ -f "$LOCK_FILE" ]; then
        # 读取锁文件时间戳（第一行是 Unix 时间戳）
        LOCK_TIME=$(head -n 1 "$LOCK_FILE")
        NOW=$(date +%s)
        
        # 计算时间差
        ELAPSED=$((NOW - LOCK_TIME))
        
        # 检查是否超时
        if [ $ELAPSED -gt $TIMEOUT ]; then
            log "⚠️ 检测到超时 (${ELAPSED}s)，准备执行原子回滚..."
            
            # 1. 验证备份目录是否存在且包含核心配置
            if [ -d "$BACKUP_DIR" ] && [ -f "$BACKUP_DIR/openclaw.json" ]; then
                log "从 $BACKUP_DIR 恢复配置..."
                
                # 2. 回滚前快照 (防止回滚过程崩溃导致不可用)
                PRE_ROLLBACK_SNAP="$CONFIG_DIR/pre_rollback_$(date +%Y%m%d_%H%M%S).tar.gz"
                tar -czf "$PRE_ROLLBACK_SNAP" -C "$CONFIG_DIR" . --exclude="backups" --exclude="logs" 2>/dev/null
                
                # 3. 执行原子覆盖
                # 建议：如果系统安装了 rsync，使用 rsync --delete 更安全
                if command -v rsync >/dev/null 2>&1; then
                    rsync -a --delete "$BACKUP_DIR/" "$CONFIG_DIR/"
                else
                    cp -rf "$BACKUP_DIR/"* "$CONFIG_DIR/"
                fi
                
                log "配置已恢复，正在重启 Gateway..."
                
                # 4. 重启 Gateway
                if ! launchctl kickstart -k ai.openclaw.gateway 2>/dev/null; then
                    log "⚠️ launchctl 重启失败，尝试命令行重启..."
                    /Users/agent/.local/bin/openclaw gateway restart >> "$LOG_FILE" 2>&1
                fi
                
                # 5. 清理现场
                rm -f "$LOCK_FILE"
                log "✅ 回滚完成！系统已恢复至最后一次确认状态。"
            else
                log "❌ 错误: 备份目录不存在或核心配置文件 (openclaw.json) 缺失，跳过回滚。"
                rm -f "$LOCK_FILE"
            fi
        fi
    fi
    
    # 降低 CPU 占用，每 10 秒检查一次
    sleep 10
done
