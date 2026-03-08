---
name: openclaw-ops
description: OpenClaw运维初始化与系统管理 - 网关配置、SSH连接、节点管理
metadata:
  openclaw:
    requires: { bins: ["openclaw", "ssh", "git"] }
---

# OpenClaw 运维初始化

## 概述

本技能提供OpenClaw系统的初始化、配置和管理能力。

## 网关管理

### 启动/停止/重启

```bash
openclaw gateway start
openclaw gateway stop
openclaw gateway restart
```

### 查看状态

```bash
openclaw status
```

### 配置管理

```bash
# 查看当前配置
openclaw gateway status
cat ~/.openclaw/openclaw.json

# 修改配置后重启生效
openclaw gateway restart
```

## SSH 连接管理

### 常用SSH配置

根据 `~/.ssh/config` 中的配置：

| 别名 | 主机 | 端口 | 用户 | 用途 |
|------|------|------|------|------|
| synology-wan | ximi.space | 2211 | syzl8512 | 群晖远程维护 |
| istore | ximi.space | 9998 | root | 软路由管理 |

### SSH连接测试

```bash
ssh -v synology-wan
ssh -v istore
```

## 节点管理

### 列出节点

```bash
openclaw node list
```

### 节点状态

```bash
openclaw node status <node-id>
```

## 定时任务

### Cron任务管理

```bash
# 列出所有任务
openclaw cron list

# 添加新任务
openclaw cron add --name "每日记忆" --schedule "0 * * * *" --command "..."

# 运行任务
openclaw cron run <job-id>
```

## 日志查看

```bash
# 查看网关日志
tail -f ~/.openclaw/logs/gateway.log

# 查看最近错误
grep -i error ~/.openclaw/logs/gateway.log | tail -20
```

## 技能重载

当添加新技能后，需要重启网关：

```bash
openclaw gateway restart
```

## 常用命令速查

| 功能 | 命令 |
|------|------|
| 启动网关 | `openclaw gateway start` |
| 停止网关 | `openclaw gateway stop` |
| 重启网关 | `openclaw gateway restart` |
| 查看状态 | `openclaw status` |
| 查看日志 | `tail -f ~/.openclaw/logs/gateway.log` |
| 列出节点 | `openclaw node list` |
| 列出定时任务 | `openclaw cron list` |
