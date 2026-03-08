# mia_vault 系统详细分析报告

## 分析时间: 2026-02-24

---

## 一、系统整体架构

### 1.1 三大核心领域

| 领域 | 主要内容 | 自动化程度 |
|------|----------|------------|
| **工作** | 新型工业化、政策洞察、汇报材料、客户管理、公文写作 | 高 |
| **生活** | AI学习、健康档案、英语学习、阅读笔记、网盘管理 | 中 |
| **教育** | 女儿学习(错题本/成绩记录)、AI助教、儿童书籍创作 | 高 |

### 1.2 技术栈

- **核心平台**: Obsidian + Claude Code MCP
- **AI引擎**: Claude Code + 自定义Commands
- **OCR识别**: MinerU API (教育内容)
- **图像分析**: ZAI MCP Server
- **浏览器自动化**: Chrome DevTools MCP
- **飞书集成**: Feishu MCP

---

## 二、核心工作流详细分析

### 2.1 /学习管家Plus - 智能素材处理

**功能定位**: 统一入口的智能素材处理中枢

**输入类型**:
| 文件类型 | 分析工具 | 特殊能力 |
|---------|---------|---------|
| 作业/试卷图片 | MinerU API | 高精度OCR |
| 会议音频 | 会议洞察技能 | 音频转录+行为分析 |
| 政策PDF | PDF处理技能 | 深度解析+影响评估 |
| 其他图片 | ZAI MCP | 通用图像分析 |
| 视频 | ZAI MCP | 视频内容提取 |
| 文档 | Read工具 | 直接读取分析 |
| 网页链接 | WebFetch | 网页内容抓取 |

**处理流程**:
```
扫描 → 智能分析 → 分类识别 → 人工确认(教育) → 智能归档
```

**分类逻辑**:
- 女儿教育: 作业、练习、成绩、考试、张一楠 → MinerU OCR → 错题分析
- 会议内容: 会议、纪要、讨论、决议 → 任务提取 → 责任人识别
- 工作政策: 政策、通知、意见、方案 → PDF深度解析 → 产品匹配
- 学习资料: 课程、技术、AI、编程 → 知识图谱 → 学习路径

**输出归档**:
- 教育 → 04_教育/学校教育/{作业记录|成绩记录}
- 工作 → 02_工作/{会议纪要|政策与趋势|日常报告}
- 学习 → 03_生活/学习记录/

---

### 2.2 /书籍创作 - 儿童成长书籍

**功能定位**: 五步法创作儿童成长书籍

**创作流程**:
```
需求澄清 → 世界设计 → 章节规划 → 逐章创作 → 质量检查
```

**核心原则**:
1. 绝不说教 - 知识通过体验传递
2. 文笔优美 - 每章有可背诵金句
3. 情感真实 - 细腻内心活动
4. 冒险有趣 - 游戏化世界观

**创作规范**:
- 10章三幕结构 (第一幕8000字/第二幕14000字/第三幕6000字)
- 单章字数: 2000-3500字
- 场景描写: 3种以上感官
- 内心活动: 每章3-5处斜体独白
- 本章金句: 2-4句

**项目档案结构**:
```
创作/《书名》/
├── 00_项目档案.md
├── 01_人物设定卡.md
├── 02_世界设定库.md
├── 03_故事大纲.md
├── 04_已完成章节摘要.md
└── 章节内容/
```

---

### 2.3 /洞察文件2.0 - 政策监测

**功能定位**: 新型工业化政策全流程监测分析

**数据源**:
- 国家级: 工信部、发改委、科技部
- 省级: 湖北省经信厅、发改委、科技厅

**分析维度 (16维)**:
1-8: 背景/目标/任务/AI亮点/产业影响/投资机会/联通匹配/要点总结
9-16: 量化指标/执行路径/风险评估/历史对比/区域分析/时间节点/竞品策略/可行性评估

**输出格式**:
- Markdown报告
- HTML可视化报告
- 政策截图存档
- 产品匹配评分

---

### 2.4 /样本分析 - 文档写作技能生成

**功能定位**: 分析文档样本，生成写作Skill

**分析维度**:
- 格式结构分析
- 内容架构分析
- 语言风格分析
- 应用场景分析
- 数据特征分析

**输出**: YAML格式的Skill文档

---

### 2.5 其他Commands

| 命令 | 功能 |
|------|------|
| 智能写作 | 汇报材料写作辅助 |
| 会议纪要 | 会议记录处理 |
| 套用格式 | 文档格式应用 |
| PPT样本分析 | PPT结构分析 |
| 格式采集 | 素材格式转换 |
| 每日任务 | 任务清单管理 |
| 汇报材料 | 汇报材料辅助 |

---

## 三、现有Skills分析

### 3.1 已有的Skills

| Skill名称 | 功能 | 状态 |
|-----------|------|------|
| pdf-processor | PDF深度处理 | YAML格式 |
| meeting-insights | 会议洞察分析 | YAML格式 |
| content-writer | 内容研究写手 | YAML格式 |
| document-converter | 文档格式转换 | YAML格式 |
| B站视频分析 | 视频内容分析 | YAML+MD |
| 抖音视频分析 | 短视频分析 | YAML+MD |
| 政策解读分析 | 政策写作 | YAML格式 |
| 企业调研报告 | 调研写作 | YAML格式 |
| 技术方案文档 | 方案写作 | YAML格式 |
| 省内通知公文 | 公文写作 | YAML格式 |

### 3.2 Skills目录结构
```
.claude/skills/
├── pdf-processor.yaml
├── meeting-insights.yaml
├── content-writer.yaml
├── document-converter.yaml
├── 视频分析相关/
└── 文档编写skills/
```

---

## 四、工作流与Skill匹配规划

### 4.1 学习管家Plus 需要的Skills

| 功能模块 | 需要Skill | 来源/新建 |
|---------|---------|----------|
| 图像OCR | mineru-ocr | 新建 |
| 视频分析 | video-analyzer | 参考现有B站/抖音 |
| 音频转录 | audio-transcription | 新建 |
| 智能分类 | content-classifier | 新建 |
| 任务提取 | task-extractor | 新建 |
| 归档路由 | file-router | 新建 |

### 4.2 书籍创作 需要的Skills

| 功能模块 | 需要Skill | 来源/新建 |
|---------|---------|----------|
| 世界设计 | world-builder | 新建 |
| 人物设定 | character-creator | 新建 |
| 章节规划 | chapter-planner | 新建 |
| 文风检查 | style-checker | 新建 |
| 金句生成 | quote-generator | 新建 |
| 一致性检查 | consistency-checker | 新建 |

### 4.3 洞察文件 需要的Skills

| 功能模块 | 需要Skill | 来源/新建 |
|---------|---------|----------|
| 政策扫描 | policy-scanner | 增强现有 |
| PDF解析 | pdf-processor | 已有，增强 |
| 16维分析 | policy-analyzer | 新建 |
| 可视化 | data-visualization | 新建 |
| 产品匹配 | product-matcher | 新建 |

### 4.4 样本分析 需要的Skills

| 功能模块 | 需要Skill | 来源/新建 |
|---------|---------|----------|
| 格式分析 | format-analyzer | 新建 |
| 结构提取 | structure-extractor | 新建 |
| 风格识别 | style-recognizer | 新建 |
| Skill生成 | skill-generator | 新建 |

---

## 五、自动化脚本分析

### 5.1 脚本分类 (65+)

|数量 | 示例 |
 类别 | |------|------|------|
| 网盘同步 | 15+ | quark_sync, alist, 115_organizer |
| 文档转换 | 10+ | md_to_word, pdf_form |
| 数据分析 | 10+ | enterprise_analysis, city_report |
| 书籍制作 | 5+ | book_layout_huaibiao |
| 系统监控 | 5+ | nas_check, monitor_nas |
| 视频处理 | 3+ | video_extractor |
| OCR处理 | 3+ | convert_pdf_mineru |

### 5.2 需要整合的脚本

可整合为独立Skills:
1. 网盘管理Skill (quark/alist/115)
2. 文档转换Skill (格式转换系列)
3. 数据分析Skill (报告生成系列)
4. 视频处理Skill

---

## 六、重构目标目录结构

```
/Users/agent/Documents/syzl8512/
├── skills/                          # 技能包
│   ├── ocr/                        # OCR识别
│   │   ├── mineru-ocr/
│   │   └── image-analyzer/
│   ├── content/                   # 内容处理
│   │   ├── content-classifier/
│   │   ├── task-extractor/
│   │   └── file-router/
│   ├── video/                     # 视频分析
│   │   └── video-analyzer/
│   ├── audio/                     # 音频处理
│   │   └── audio-transcription/
│   ├── document/                  # 文档处理
│   │   ├── pdf-processor/
│   │   ├── document-converter/
│   │   └── format-analyzer/
│   ├── writing/                   # 写作辅助
│   │   ├── content-writer/
│   │   ├── style-checker/
│   │   └── skill-generator/
│   ├── policy/                    # 政策分析
│   │   ├── policy-scanner/
│   │   └── policy-analyzer/
│   ├── book/                      # 书籍创作
│   │   ├── world-builder/
│   │   ├── character-creator/
│   │   └── chapter-planner/
│   └── storage/                   # 存储管理
│       ├── quark-sync/
│       ├── alist-manager/
│       └── nas-manager/
├── commands/                      # 自定义命令
│   ├── 学习管家.md
│   ├── 书籍创作.md
│   ├── 洞察文件.md
│   ├── 样本分析.md
│   └── ...
├── scripts/                        # 自动化脚本
│   ├── sync/
│   ├── convert/
│   └── analysis/
└── README.md
```

---

## 七、参考Skills库

### 7.1 awesome-openclaw-skills 重点参考

**PDF & Documents (67)**:
- pdf-processor (已有, 需增强)
- document-converter (已有)
- 寻找: OCR, 格式转换相关

**Search & Research (253)**:
- 寻找: 深度研究, 内容分析相关

**Productivity & Tasks (135)**:
- task-extractor (需新建)
- 寻找: 任务管理自动化

**Notes & PKM (100)**:
- 寻找: Obsidian相关技能

### 7.2 vercel-labs/skills 规范

**SKILL.md格式**:
```yaml
---
name: skill-name
description: 技能描述
---

# Skill内容
## When to Use
## Steps
```

**目录位置**:
- 项目: skills/
- 全局: ~/.openclaw/skills/

---

## 八、实施计划

### Phase 1: 核心Skills建设
1. 内容分类器 (content-classifier)
2. 任务提取器 (task-extractor)
3. 文件路由器 (file-router)

### Phase 2: 专业Skills建设
4. 书籍创作Skills套件
5. 政策分析Skills套件
6. 样本分析Skills

### Phase 3: 整合优化
7. 网盘管理Skills
8. 视频/音频处理Skills
9. 测试和优化
