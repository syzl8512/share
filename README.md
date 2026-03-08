# OpenClaw 技能分类体系

基于 4 层架构的技能管理系统。

---

## 📊 分类总览

| 层次 | 名称 | 描述 | 数量 |
|------|------|------|------|
| 01 | 基础能力 | 搜索、图片、文件收发 | 5+ |
| 02 | 造Skill+分析 | 找技能、创技能、分析能力 | 8+ |
| 03 | 运维稳定 | 记忆、上下文、健康、回滚 | 8 |
| 04 | 工具对接 | 高德、办公、飞书、公文 | 15+ |
| 05 | 备份 | commands、记忆、运维经验 | 3 |

---

## 01_基础能力

核心基础能力，AI 助手必备。

### 搜索
| 技能 | 用途 |
|------|------|
| tavily-search | AI 优化网页搜索 |
| deep-research | 深度研究能力 |
| search1-api | 搜索 API |

### 图片
| 技能 | 用途 |
|------|------|
| image (内置) | 图片识别与分析 |

### 文件
| 技能 | 用途 |
|------|------|
| feishu-drive | 飞书云盘操作 |
| file-sender | 文件发送到飞书 |

---

## 02_造Skill+分析

Skill 的创建、分析和处理能力。

### FindSkill
| 技能 | 用途 |
|------|------|
| find-skills | 发现和安装新技能 |

### SkillCreator
| 技能 | 用途 |
|------|------|
| skill-creator | 创建新技能 |

### 头脑风暴
| 技能 | 用途 |
|------|------|
| brainstorm | 头脑风暴助手 |

### 文档分析
| 技能 | 用途 |
|------|------|
| mineru | PDF/Word/PPT 解析 |
| mineru-cloud | 云端文档解析 |
| markdown-converter | 格式转换为 Markdown |
| document-summarizer | 文档摘要 |

### 视频分析
| 技能 | 用途 |
|------|------|
| video-learning-skill | 视频学习笔记 |

### 音频分析
| 技能 | 用途 |
|------|------|
| notebooklm-cli | Google NotebookLM CLI |

---

## 03_运维稳定

系统运维和稳定性保障。

| 技能 | 用途 |
|------|------|
| memory-hygiene | 内存清理维护 |
| context-manager | 会话上下文管理 |
| session-log | 会话日志记录 |
| reback | 回滚保护系统 |
| healthcheck | 健康检测监控 |
| rollback-protector | 自动回滚保护 |
| server-manager | 服务器管理 |
| openclaw-ops | 运维初始化 |

---

## 04_工具对接

对外接口和工具集成。

### 高德
| 技能 | 用途 |
|------|------|
| gaodemapskill | 高德地图 API |

### 办公
| 技能 | 用途 |
|------|------|
| word-docx | Word 文档处理 |
| excel-xlsx | Excel 表格处理 |
| pptx-2 | PPT 制作 |
| ppt-generator | PPT 生成 |

### 飞书
| 技能 | 用途 |
|------|------|
| feishu-doc | 飞书文档操作 |
| feishu-drive | 飞书云盘操作 |
| feishu-wiki | 飞书知识库 |
| file-sender | 文件发送到飞书 |

### 公文
| 技能 | 用途 |
|------|------|
| doc-writer | 文档生成 |
| writing-plans | 写作规划 |

### 其他工具
| 技能 | 用途 |
|------|------|
| weather | 天气查询 |
| pdf-generator | PDF 生成 |
| web-translator | 网页翻译 |
| workflow-runner | 工作流执行 |

---

## 05_备份

重要数据备份。

| 目录 | 内容 |
|------|------|
| commands | Claude 命令备份 |
| todolist | 记忆和待办 |
| 运维经验 | 运维文档和经验 |

---

## 🔄 同步机制

```
本地 (~/.openclaw/workspace/skills/)
    ↑
    ↓ 经验分享/发布
GitHub (syzl8512/openclaw-experience/share/)
```

### 命令
- `同步技能` - 推送到 GitHub
- `拉取技能` - 从 GitHub 安装

---

**最后更新**: 2026-03-08
