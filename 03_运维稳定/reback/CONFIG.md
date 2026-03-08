# ⚙️ 配置说明

## 配置文件

### 1. Sentinel 脚本配置

打开 `openclaw-sentinel.sh`，可修改以下参数：

```bash
# 第 10 行：锁文件位置
LOCK_FILE="/tmp/openclaw_guard.lock"

# 第 11 行：备份目录
BACKUP_DIR="$HOME/.openclaw/backups/latest"

# 第 12 行：配置目录
CONFIG_DIR="$HOME/.openclaw"

# 第 13 行：日志文件
LOG_FILE="$HOME/.openclaw/logs/sentinel.log"

# 第 16 行：超时时间（秒）
TIMEOUT=300  # 默认 5 分钟
```

### 2. LaunchAgent 配置

`ai.openclaw.sentinel.plist` 关键配置：

```xml
<!-- 服务标签 -->
<key>Label</key>
<string>ai.openclaw.sentinel</string>

<!-- 开机自启 -->
<key>RunAtLoad</key>
<true/>

<!-- 崩溃后自动重启 -->
<key>KeepAlive</key>
<true/>

<!-- 主程序 -->
<key>ProgramArguments</key>
<array>
    <string>/bin/bash</string>
    <string>/Users/mia/maintenance/openclaw-sentinel.sh</string>
</array>
```

## 可调参数

### 超时时间

根据操作复杂度调整：

| 操作类型 | 建议超时 |
|----------|----------|
| 简单配置修改 | 3 分钟 |
| 一般操作 | 5 分钟 |
| 复杂迁移 | 10 分钟 |

```bash
TIMEOUT=180   # 3 分钟
TIMEOUT=300   # 5 分钟
TIMEOUT=600   # 10 分钟
```

### 排除目录

回滚时自动排除的目录（在脚本中修改）：

```bash
# 第 47 行左右，修改 tar 命令的 --exclude 参数
tar -czf "$PRE_ROLLBACK_SNAP" -C "$CONFIG_DIR" . \
    --exclude="backups" \
    --exclude="logs" \
    --exclude="memory" \
    --exclude="*.db"
```

### 备份保留策略

当前为单备份（只保留 latest）。如需保留历史：

```bash
# 修改备份逻辑（高级）
# 在创建备份前，先 rotate 历史备份
if [ -d "$BACKUP_DIR" ]; then
    mv "$BACKUP_DIR" "$BACKUP_DIR.old"
fi
```

## 环境变量

Sentinel 使用以下环境变量：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `HOME` | 用户目录 | 自动获取 |
| `PATH` | 命令路径 | 系统默认 |

## 日志配置

### 日志级别

当前脚本使用简单日志，如需更详细：

```bash
# 添加调试模式
DEBUG=1

log() {
    if [ "$DEBUG" = "1" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [DEBUG] $1" >> "$LOG_FILE"
    fi
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}
```

### 日志轮转

防止日志过大：

```bash
# 添加日志轮转逻辑
if [ -f "$LOG_FILE" ]; then
    SIZE=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE")
    if [ "$SIZE" -gt 10485760 ]; then  # 10MB
        mv "$LOG_FILE" "$LOG_FILE.old"
    fi
fi
```

## 多实例支持

如需在同一机器运行多个 Sentinel（测试/开发）：

```bash
# 为不同实例创建不同的锁文件
LOCK_FILE="/tmp/openclaw_guard.lock"        # 生产
LOCK_FILE="/tmp/openclaw_guard_dev.lock"   # 开发
```

---

*配置说明 - 最后更新：2026-03-01*
