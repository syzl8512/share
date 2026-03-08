# Skills 体系

## 4.1 Skills 存放位置（优先级）

1. **Workspace skills**: `<workspace>/skills` (最高)
2. **Managed/local skills**: `~/.openclaw/skills`
3. **Bundled skills**: 随安装包提供 (最低)

## 4.2 ClawHub - 公共 Skills 注册表

- **网站**: https://clawhub.ai
- **CLI**: `npm i -g clawhub`
- **常用命令**:
  - `clawhub search <keyword>` - 搜索
  - `clawhub install <skill-slug>` - 安装
  - `clawhub update --all` - 更新全部
  - `clawhub publish` - 发布

## 4.3 Skill 格式 (AgentSkills 兼容)

```yaml
---
name: skill-name
description: 技能描述
metadata:
  openclaw:
    requires: { bins: ["cmd"] }
---
# Skill 内容
## When to Use
## Steps
```

---

## 已有的 Skills

| Skill | 功能 |
|-------|------|
| pdf-processor | PDF 深度处理 |
| meeting-insights | 会议洞察分析 |
| content-writer | 内容研究写手 |
| document-converter | 文档格式转换 |
| 视频分析 (B站/抖音) | 短视频内容分析 |
| 政策解读分析 | 政策写作 |
| 企业调研报告 | 调研写作 |
| 技术方案文档 | 方案写作 |
| 省内通知公文 | 公文写作 |

---

## 需要新建的 Skills

- **内容处理**: content-classifier, task-extractor, file-router
- **书籍创作**: world-builder, character-creator, chapter-planner
- **政策分析**: policy-scanner, policy-analyzer
- **样本分析**: format-analyzer, skill-generator
- **存储管理**: quark-sync, alist-manager, nas-manager

## 已安装的 Skills

| Skill | 功能 | 状态 |
|-------|------|------|
| **tavily-search** | Tavily AI 搜索 (web_search 备选) | ✅ 已配置 |

> 注：Tavily MCP 服务已配置，API Key: `tvly-dev-7ROxs-...`

---

## 🤖 大龙虾的 Skills（群晖版）

> 位于: syzl8512/openclaw-workspace (GitHub)
> 更新: 2026-02-24

### 🆕 新建6个 Skills

| Skill | 功能描述 | 状态 |
|-------|----------|------|
| document-summarizer | 文档摘要/问答/出题 | 🆕 新建 |
| writing-assistant | 写作润色/语法检查 | 🆕 新建 |
| ppt-generator | AI生成PPT | 🆕 新建 |
| web-translator | 网页双语翻译 | 🆕 新建 |
| data-visualizer | 数据可视化 | 🆕 新建 |
| deep-research | 深度研究/报告 | 🆕 新建 |

### ✅ 已有 Skills (19个)

tavily-search, aliyun-tts, edge-tts, data-analysis, excel-xlsx, word-docx, pptx, markdown-converter, mineru, notebooklm-cli, supabase, gaodemapskill, sheet-cog, claude-optimised, backend-patterns, coding, research, productivity, social

---

## 🔗 双机器人沟通机制

### 当前状态
- **mini** (本机/MacMini): 主要对话入口
- **大龙虾** (群晖): 运行于 syzl8512@ximi.space:2211

### 沟通方式
- sessions_send: 跨session发消息
- 需配置 SSH 密钥或消息转发

### 监督机制
- 大龙虾可执行文件处理、NAS管理、下载等任务
- mini 可远程调度大龙虾执行任务

---

*新增: 大龙虾 Skills 信息 + 沟通机制*
