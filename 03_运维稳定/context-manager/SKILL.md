---
name: context-manager
description: 会话上下文管理器 - 自动检测并摘要长会话，保留关键信息
metadata:
  openclaw:
    emoji: 🧠
---

# Context Manager

会话上下文管理器，自动检测并摘要长会话，保留关键信息。

## 功能

- **token-usage**: 检查当前上下文占用
- **summarize-session**: 提取核心要点
- **auto-summarize**: 超过阈值时自动执行

## 使用方式

### 检查上下文占用

```bash
openclaw session status
```

或使用内置命令：

```bash
# 查看当前 session 状态
session_status
```

### 手动触发摘要

当需要手动触发摘要时：

```bash
# 使用 skill 中的脚本
bash scripts/summarize.sh
```

### 自动触发配置

在 `HEARTBEAT.md` 中添加定期检查：

```markdown
## 上下文检查（每次 heartbeat）
- 检查 session_status 中的 context 占比
- 超过 35% 时触发摘要提取
```

## 配置

### 阈值设置

编辑 `scripts/config.sh`：

```bash
# 触发摘要的阈值（百分比）
TOKEN_THRESHOLD=35
```

### 摘要提示词

编辑 `scripts/prompt.txt` 自定义摘要风格。

## 摘要提取规则

### 保留内容

1. **关键决策** - 用户明确的要求、偏好、禁止事项
2. **待办事项** - 未完成的任务、后续步骤
3. **上下文** - 当前项目/任务的背景信息
4. **配置变更** - 系统配置的修改
5. **重要结论** - AI 给出的最终答案、方案

### 丢弃内容

1. **调试过程** - 失败的尝试、错误信息
2. **重复内容** - 多轮相似的讨论
3. **中间推导** - 思维过程、试错记录
4. **工具调用** - 纯技术性的命令执行日志

### 摘要格式

```markdown
## 会话摘要 [日期]

### 关键决策
- 用户偏好：xxx
- 系统配置：xxx

### 待办事项
- [ ] xxx

### 当前上下文
- 项目：xxx
- 进度：xxx

### 重要结论
- xxx
```

## 技术实现

### Token 计算

使用 OpenClaw 的 `session_status` 命令获取：

```json
{
  "context": "172k/200k (86%)"
}
```

### 摘要触发流程

1. 解析 `session_status` 输出中的百分比
2. 如果 > 阈值，提取会话历史
3. 调用 LLM 进行摘要
4. 写入 MEMORY.md 或对应主题文件
5. 通知用户摘要完成

## 依赖

- `session_status` - OpenClaw 内置命令
- LLM 摘要能力 - 使用当前模型的摘要功能

## 示例

### 阈值触发示例

```
Context: 172k/200k (86%) → 触发摘要
摘要完成：提取 15 个关键点
写入位置：memory/2026-03-05.md
```

## 注意事项

- 摘要会保留关键信息，不只是简单删减
- 摘要后会话将"清爽"，但保留关键上下文
- 建议设置 30-35% 作为触发阈值
