# 🛡️ OpenClaw 自动回滚保护系统

> 远程修改配置的"后悔药"，防止改崩后失联

## 概述

当通过远程方式修改 OpenClaw 核心配置时，最大的风险是**改崩后无法恢复**，导致必须物理接触机器才能修复。本系统通过"先设保险再动手"的机制，确保远程操作的安全性。

## 系统架构

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  用户/Agent     │ ──▶ │ rollback-protector│ ──▶ │ Sentinel 守护   │
│  (触发敏感操作)  │     │  Skill           │     │ 进程            │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                                                        │
                              ┌─────────────────────────┘
                              ▼
                        ┌─────────────┐
                        │ 自动回滚    │
                        │ + 重启 Gateway │
                        └─────────────┘
```

## 组件说明

| 组件 | 路径 | 说明 |
|------|------|------|
| rollback-protector Skill | `SKILL.md` | 与用户交互，检测敏感操作，触发备份 |
| Sentinel 守护脚本 | `openclaw-sentinel.sh` | 后台进程，检测超时自动回滚 |
| LaunchAgent 配置 | `ai.openclaw.sentinel.plist` | macOS 开机自启 |
| 锁文件 | `/tmp/openclaw_guard.lock` | 标记"等待确认"状态 |
| 备份目录 | `~/.openclaw/backups/latest/` | 存储配置快照 |

---

## 快速开始

### 1. 安装

```bash
# 复制脚本到系统目录
cp openclaw-sentinel.sh /Users/mia/maintenance/

# 复制 LaunchAgent 配置
cp ai.openclaw.sentinel.plist ~/Library/LaunchAgents/

# 加载 LaunchAgent
launchctl load ~/Library/LaunchAgents/ai.openclaw.sentinel.plist
```

### 2. 验证安装

```bash
# 检查 Sentinel 是否运行
ps aux | grep sentinel

# 查看日志
tail -f ~/.openclaw/logs/sentinel.log
```

---

## 使用方法

### 触发条件

当执行以下操作时，系统自动触发保护：

- `restart gateway` / `重启网关`
- `config set` / `修改配置`
- 修改 `openclaw.json`
- 任何涉及 `.openclaw/` 目录的重大写操作

### 操作流程

```
1. 用户执行敏感操作
        ↓
2. rollback-protector 检测到敏感操作
        ↓
3. 自动备份当前配置到 ~/.openclaw/backups/{timestamp}/
        ↓
4. 创建锁文件 /tmp/openclaw_guard.lock（写入当前时间戳）
        ↓
5. 发送确认请求给用户：
   "⚠️ 保护机制已启动！5分钟内未确认将自动回滚。请回复'确认'继续操作。"
        ↓
┌──────────────────────────────────────────┐
│ 6a. 用户回复"确认" → 删除锁文件 → 操作继续  │
│ 6b. 超时(5分钟) → Sentinel 自动回滚 + 重启  │
└──────────────────────────────────────────┘
```

### 手动操作

```bash
# 取消回滚（确认操作成功）
rm -f /tmp/openclaw_guard.lock

# 手动触发回滚（测试用）
date +%s > /tmp/openclaw_guard.lock
# 等待 300 秒后自动回滚

# 查看 Sentinel 日志
tail -f ~/.openclaw/logs/sentinel.log

# 停止 Sentinel
launchctl unload ~/Library/LaunchAgents/ai.openclaw.sentinel.plist
```

---

## 配置说明

### 超时时间

默认 5 分钟（300 秒），可在脚本中修改：

```bash
# openclaw-sentinel.sh 第 12 行
TIMEOUT=300  # 单位：秒
```

### 备份保留策略

当前为单备份（覆盖式），保留最后一次备份。如需保留历史备份，可修改脚本。

### 排除目录

回滚时默认排除以下目录：
- `backups/` - 备份目录本身
- `logs/` - 日志目录

---

## 故障排查

### Sentinel 未启动

```bash
# 手动启动
bash /Users/mia/maintenance/openclaw-sentinel.sh &

# 检查错误
cat ~/.openclaw/logs/sentinel.log
```

### 备份目录为空

首次触发时自动填充。如需手动备份：

```bash
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$HOME/.openclaw/backups/$TIMESTAMP"
mkdir -p "$BACKUP_DIR"
cp -r "$HOME/.openclaw/openclaw.json" "$BACKUP_DIR/"
rm -f "$HOME/.openclaw/backups/latest"
ln -s "$BACKUP_DIR" "$HOME/.openclaw/backups/latest"
```

### 回滚失败

1. 检查备份目录是否存在
2. 检查日志 `~/.openclaw/logs/sentinel.log`
3. 手动恢复：

```bash
cp ~/.openclaw/backups/latest/openclaw.json ~/.openclaw/
launchctl kickstart -k ai.openclaw.gateway
```

---

## 与其他方案对比

| 特性 | Sentinel 守护进程 | at 命令方案 | 回滚 Protector Skill |
|------|------------------|------------|---------------------|
| 定时机制 | 每 10 秒检测超时 | 一次性 at 任务 | 配合 Sentinel |
| 可取消 | ✅ 删除锁文件 | ❌ 几乎无法取消 | ✅ |
| 可交互 | ✅ 发送确认消息 | ❌ | ✅ |
| 可扩展 | ✅ 可加更多检测 | ❌ | ✅ |
| 复杂度 | 较复杂 | 简单 | 中等 |

---

## 文件清单

```
reback/
├── README.md                    # 本文档
├── INSTALL.md                  # 安装指南
├── CONFIG.md                   # 配置说明
├── openclaw-sentinel.sh        # Sentinel 守护脚本
├── ai.openclaw.sentinel.plist  # LaunchAgent 配置
├── docs/
│   └── rollback-flow.png       # 流程图（可选）
└── rollback-protector/          # Skill 相关
    └── SKILL.md                # Skill 定义
```

---

*最后更新：2026-03-01*
