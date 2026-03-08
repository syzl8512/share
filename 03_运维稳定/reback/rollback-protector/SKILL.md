---
name: rollback-protector
description: OpenClaw 自动回滚保护技能。用于在执行敏感操作（Gateway重启、配置修改）前自动备份，并在超时未确认时自动回滚。
---

# 🛡️ Rollback Protector - 自动回滚保护 (优化版)

本 Skill 负责在执行敏感操作前自动备份系统状态，并在超时未确认时触发回滚。

## 触发条件

检测用户消息是否包含以下敏感操作：
- `restart gateway` / `重启网关` / `重启服务`
- `config set` / `修改配置` / `修改 openclaw.json`
- `system upgrade` / `系统更新`
- 任何涉及 `.openclaw/` 目录的重大写操作

## 执行流程

### 1. 自动环境检查、备份与清理

```bash
# A. 环境检查：确保 Gateway 正在运行
if ! launchctl list | grep -q "ai.openclaw.gateway"; then
    echo "⚠️ 警告：Gateway 服务未运行，跳过保护机制。"
    return
fi

# B. 定期清理旧备份（保留最近30天的记录）
find "$HOME/.openclaw/backups" -maxdepth 1 -type d -mtime +30 -exec rm -rf {} + 2>/dev/null

# C. 执行备份
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$HOME/.openclaw/backups/$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

cp -r "$HOME/.openclaw/openclaw.json" "$BACKUP_DIR/"
# 备份其他关键组件，但排除日志和缓存以节省空间
cp -r "$HOME/.openclaw/agents/" "$BACKUP_DIR/" 2>/dev/null
cp -r "$HOME/.openclaw/channels/" "$BACKUP_DIR/" 2>/dev/null

# 更新 latest 软链接
rm -f "$HOME/.openclaw/backups/latest"
ln -s "$BACKUP_DIR" "$HOME/.openclaw/backups/latest"

echo "✅ 系统状态已备份至: $TIMESTAMP"
```

### 2. 创建高优先级锁文件

```bash
# 写入 Unix 时间戳作为 Sentinel 的计时起点
date +%s > /tmp/openclaw_guard.lock
```

### 3. 互动确认

向用户发送确认请求：
```text
⚠️ 【后悔药】保护机制已启动！

已自动创建系统快照。
⏳ 等待确认：5 分钟（超时将自动拉回配置并重启网关）

请回复 "确认" 继续操作，或回复 "取消" 手动终止。
```

### 4. 状态解除

- **收到确认**：回复“确认”、“收到”、“OK”。
  - 操作：`rm -f /tmp/openclaw_guard.lock`
  - 反馈：“✅ 保护已解除，您可以继续操作。”
- **收到取消**：
  - 操作：立即执行回滚逻辑并重置锁文件。

## 注意事项

1. **原子性**：本版本配合优化后的 Sentinel 脚本，支持回滚前的二次快照。
2. **磁盘空间**：内置了 30 天自动清理逻辑，防止备份撑爆磁盘。
3. **独立性**：Sentinel 即使在 OpenClaw 主进程卡死时也能强制接管回滚。
