# /ppt制作 - 智能PPT生成助手

## 核心功能

**根据逐字稿或参考PPT，自动生成高质量乔布斯风格PPT演示文稿。**

## 触发条件

- 用户说"做PPT"、"生成PPT"、"帮我做个PPT"
- 用户输入 `/ppt制作`
- 用户提供逐字稿并要求生成PPT

---

## 引用Skill

**必须引用** `skills/ppt-generator/SKILL.md` 中的所有规范

---

## 使用方式

### 方式一：基于逐字稿生成

```yaml
输入:
  - 逐字稿/讲稿内容（必填）
  - PPT主题/标题（可选）
  - 目标受众/汇报场景（必填）

示例:
  /ppt制作 请基于以下逐字稿生成PPT，今天汇报对象是鄂钢办公室领导
  [附上逐字稿内容]
```

### 方式二：基于参考PPT调整

```yaml
输入:
  - 参考PPT文件路径（必填）
  - 调整需求说明（必填）
  - 目标受众（必填）

示例:
  /ppt制作 请调整这个PPT，今天汇报对象是鄂钢办公室相关领导
  [附上PPT文件]
```

---

## 工作流程

### Step 1: 接收输入

根据使用方式分别处理：
- **逐字稿**：完整接收用户提供的文字内容
- **参考PPT**：使用 `claude-commands/PPT样本分析.md` 分析现有PPT结构

### Step 2: 分析输入内容

**逐字稿分析要点：**
1. 识别章节/段落结构
2. 提取核心观点和关键信息
3. 梳理逻辑关系（对比、因果、递进）
4. 识别数据、时间节点、关键词

**参考PPT分析：**
调用 `claude-commands/PPT样本分析.md` 命令进行深度分析

### Step 3: 生成乔布斯式标题

遵循 `skills/ppt-generator/SKILL.md` 中的标题生成规则：

| 类型 | 公式 | 示例 |
|------|------|------|
| 对比式 | A是X，Y是B | 不是在做PPT，是在讲故事 |
| 比喻式 | X就像Y | 想法像种子，需要PPT浇水 |
| 问题式 | 为什么.../到底... | 观众到底想听什么？ |
| 断言式 | 直接给出结论 | 把复杂留给自己，把简单留给观众 |
| 递进式 | 从X到Y | 从干巴巴的稿子到惊艳的演示 |

### Step 4: 修正讲稿口语化（仅逐字稿模式）

```yaml
修正要点:
  1. 加入开场5秒"钩子"
  2. 使用"你"、"咱们"代替"用户"
  3. 添加 [停顿]、(放慢) 节奏标记
  4. 加入互动问句"你也..."、"对吧"
  5. 添加场景化表达
```

### Step 5: 生成PPT文件

使用 Vue 3 + TailwindCSS 语法，生成HTML格式PPT：

**技术规范（来自 `skills/ppt-generator/SKILL.md`）：**
- 格式：单个HTML文件
- 技术栈：Vue 3 + TailwindCSS
- 比例：9:16 竖屏
- 效果：深色渐变底色 + 模糊浮动光斑 + 缓慢动画

**字体规范（大屏演示版）：**
- 标题：6xl-9xl（text-6xl 到 text-9xl）
- 正文：3xl-4xl（text-3xl 到 text-4xl）
- 重点数字：9xl（text-9xl）
- 副标题/标签：4xl（text-4xl）

**底色选择规则：**
| 颜色系 | 内容类型 |
|--------|----------|
| 紫色系 via-purple-900 | 重点讲解 |
| 蓝色系 via-blue-900 | 时间线/故事 |
| 青色系 via-cyan-900 | MCP/技术 |
| 黄色系 via-yellow-900 | 案例/数据 |
| 红色系 via-red-900 | 痛点/警示 |
| 绿色系 via-green-900 | 转折/成长 |
| 橙色系 via-orange-900 | 核心理念 |
| 靛蓝系 via-indigo-900 | Skill体系 |

**页面结构规范：**
```html
<div class="slide active bg-gradient-to-br from-slate-900 via-[颜色]-900 to-slate-900">
  <div class="max-w-4xl px-8">
    [大字体内容]
  </div>
</div>
```

**交互代码：**
```html
<style>
  .slide { min-height: 100vh; display: none; align-items: center; justify-content: center; cursor: pointer; position: relative; }
  .slide.active { display: flex; }
  .slide::after { content: '点击屏幕切换下一页 →'; position: absolute; bottom: 30px; left: 50%; transform: translateX(-50%); color: rgba(255,255,255,0.3); font-size: 14px; }
</style>

<script>
  let currentSlide = 0;
  const slides = document.querySelectorAll('.slide');

  document.addEventListener('click', function() {
    slides[currentSlide].classList.remove('active');
    currentSlide = (currentSlide + 1) % slides.length;
    slides[currentSlide].classList.add('active');
  });

  document.addEventListener('keydown', function(e) {
    if (e.key === 'ArrowRight' || e.key === ' ') {
      slides[currentSlide].classList.remove('active');
      currentSlide = (currentSlide + 1) % slides.length;
      slides[currentSlide].classList.add('active');
    } else if (e.key === 'ArrowLeft') {
      slides[currentSlide].classList.remove('active');
      currentSlide = (currentSlide - 1 + slides.length) % slides.length;
      slides[currentSlide].classList.add('active');
    }
  });
</script>
```

### Step 6: 目录结构建议（40页）

1. 封面（1页）
2. 目录（1页）
3. 痛点/开场（2页）
4. 故事/时间线（5-8页）
5. 知识点讲解（4-6页）
6. 核心概念（3-4页）
7. 案例展示（4-6页）
8. 核心理念（2-3页）
9. 总结/行动（3-4页）
10. 结尾（1页）

---

## 使用的Skill和工具

| 类型 | 名称 | 用途 |
|------|------|------|
| Skill | `skills/ppt-generator/SKILL.md` | PPT生成规范（标题、颜色、字体） |
| Command | `claude-commands/PPT样本分析.md` | 参考PPT的深度分析 |
| MCP | `mcp__chrome-devtools__*` | 网页PPT截图（如需要） |

---

## 输出要求

- **格式**：单个HTML文件
- **页数**：最少30页，内容充实

---

## 使用示例

### 示例1：基于逐字稿
```
用户：/ppt制作
（附上逐字稿内容，今天汇报对象是鄂钢办公室领导）

AI：好的，我将：
1. 分析您的逐字稿内容
2. 生成乔布斯式标题
3. 适配鄂钢办公室汇报场景
4. 生成30+页高质量PPT
```

### 示例2：基于参考PPT调整
```
用户：/ppt制作
请调整这个PPT，今天汇报对象是鄂钢办公室相关领导
[附上PPT文件]

AI：
1. 先使用PPT样本分析深度分析现有PPT结构
2. 识别需要调整的内容模块
3. 根据汇报对象进行场景适配
4. 生成调整后的PPT
```

---

## 注意事项

1. **目标受众**：必须确认汇报对象（如：鄂钢办公室领导）
2. **场景适配**：根据汇报场景调整语言风格（正式/培训/交流）
3. **内容充实**：每页要有足够内容，避免空洞
4. **交互测试**：生成后建议用浏览器打开测试交互效果
