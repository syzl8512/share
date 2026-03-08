# mia_vault 项目分析

> 分析时间: 2026-02-24

## 项目背景

- **来源**：`/Users/agent/Documents/mia` 文件夹
- **目标**：重构到 `/Users/agent/Documents/syzl8512`

## 三大核心领域

| 领域 | 主要内容 | 自动化程度 |
|------|----------|------------|
| **工作** | 新型工业化、政策洞察、汇报材料、客户管理、公文写作 | 高 |
| **生活** | AI学习、健康档案、英语学习、阅读笔记、网盘管理 | 中 |
| **教育** | 女儿学习(错题本/成绩记录)、AI助教、儿童书籍创作 | 高 |

## 核心技术栈

- **核心平台**: Obsidian + Claude Code MCP
- **AI引擎**: Claude Code + 自定义Commands
- **OCR识别**: MinerU API
- **图像分析**: ZAI MCP Server
- **浏览器自动化**: Chrome DevTools MCP
- **飞书集成**: Feishu MCP

## 重构目标目录

```
/Users/agent/Documents/syzl8512/
├── skills/           # 技能包
├── commands/        # 自定义命令
├── scripts/         # 自动化脚本
└── README.md
```

---

*来源: MEMORY.md 二、mia_vault 项目分析*
