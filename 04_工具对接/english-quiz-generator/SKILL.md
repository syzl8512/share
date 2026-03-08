---
name: english-quiz-generator
description: 儿童英语听力Quiz生成器 - 通过用户描述/图片识别动画集数，搜索情节，生成20道Quiz并部署上网
tags: [english, quiz, education, kids, interactive, bluey, animation]
---

# English Quiz Generator Skill

将儿童英语动画转换为交互式Quiz网页

## 核心原则

- **不做视频分析** - 太麻烦！
- **只做内容识别 + 搜索 + 生成**
- **先比对确认再生成题目**

## 完整业务流程

```
用户输入（文字/图片） → 识别集数 → 搜索情节 → 生成20道Quiz → 生成网页 → 部署上线
```

## 使用方法

### 用户提供信息（任选一种）

**方式A：文字描述**
> "Bluey第一季第三集，爸爸机器人"

**方式B：图片**
> [发送一张剧照图片]

**方式C：口述**
> "就是那一集爸爸假装是机器人的"

### 我的工作

1. **识别集数**：根据文字/图片确定是哪一集
2. **搜索情节**：上网搜索该集的具体情节描述
3. **内容比对**：确认搜索到的情节与用户描述一致
4. **生成Quiz**：基于情节生成20道选择题
5. **生成网页**：生成交互式HTML页面
6. **部署上线**：部署到群晖Web服务器

## Quiz题目设计原则

### 题目类型（各占50%）

1. **情节理解题** - 关于故事主线、人物、事件
   - What is the name of this episode?
   - What lesson does Bluey learn?

2. **对话场景题** - 关于英语日常对话
   - 场景：某人说了一句什么话
   - 选项：几种可能的回复（都是英语）
   - 例如：
     > Q: Bluey says "No, it's my turn!" When does she say this?
     > A: When Bingo asks for a turn with the xylophone

### 语言要求

- 全英文题目
- 简单易懂的词汇
- 适合儿童理解

## 技术实现

### 部署位置

- 群晖路径：`/var/services/web/tools-yinan/`
- 访问地址：`http://ximi.space:5050/tools-yinan/`

### 文件结构

```
tools-yinan/
├── index.html          # Quiz列表主页
├── quiz-index.html    # Quiz列表（带成绩显示）
├── bluey-quiz.html   # Bluey Quiz答题页
└── [其他quiz].html   # 后续Quiz
```

### 功能特性

1. **答题界面**
   - 显示题目和选项
   - 即时反馈（对错）
   - 进度条
   - 中英文双语

2. **结果页面**
   - 显示得分
   - 答题统计（每题对错）
   - 正确率计算
   - 重新测试按钮
   - 返回列表按钮

3. **成绩保存**
   - 使用localStorage保存成绩
   - 列表页显示上次成绩

## 触发方式

用户说：
- "出题目"
- "生成Quiz"
- "这一集考考你"
- "帮我做测试"
- "英语听力测试"
- "英语quiz"
- [发送动画相关图片]

## 添加新Quiz步骤

1. 用户提供动画信息
2. 搜索情节，确认集数
3. 生成20道题目（10情节+10对话）
4. 生成HTML文件
5. 上传到群晖
6. 更新quiz-index.html添加新条目

## 示例

用户输入：
> "Bluey第一季第三集，爸爸假装成机器人那一集"

我执行：
1. 识别：Bluey Season 1 Episode 3 - Daddy Robot
2. 搜索：找到该集情节（爸爸假装机器人...）
3. 比对：确认是这一集
4. 生成：20道选择题（情节+对话）
5. 生成：HTML网页
6. 部署：告诉用户访问地址

## 相关经验

- 连接群晖前先检查 ~/.ssh/config
- Web Station目录：/volume1/@appconf/WebStation/personal_web/
- 用户目录：/var/services/web/tools-yinan/
- SSH连接：ssh synology-wan
