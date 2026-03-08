# Skill: Writing Assistant

## 描述
AI写作润色助手，类似Quillbot。提供语法检查、改写、风格调整等功能。

## 触发
用户说"润色"、"改写"、"语法检查"、"翻译"、"正式"、"口语"等。

## 工具
- AI: 用MiniMax进行写作处理

## 功能
1. **语法检查** - 找出语法错误并解释
2. **智能改写** - 调整句式、语气、风格
3. **中英翻译** - 中英互译，学术/口语风格
4. **学术润色** - 使文章更正式、学术化

## 示例
```
用户: 帮我检查语法 "I goes to school yesterday"
→ 指出错误: goes→went, 解释原因

用户: 帮我改成学术风格 "This thing is very important"
→ This matter is of significant importance
```

## 提示词模板
```
请检查以下文本的语法错误，如果有请指出并修正：
---
{text}
---

请将以下文本改写成{风格}风格：
---
{text}
---
```
