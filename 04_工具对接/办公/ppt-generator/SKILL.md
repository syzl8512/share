# Skill: PPT Generator

## 描述
AI生成PPT，类似Gamma。输入主题或内容，自动生成演示文稿。

## 触发
用户说"生成PPT"、"做PPT"、"制作演示"、"做slides"。

## 工具
- exec: 调用外部API（如Gamma）
- AI: 生成PPT大纲和内容

## 流程
1. 获取用户需求（主题/内容/页数）
2. 生成PPT大纲
3. 调用Gamma API生成PPT（或提供手动操作指引）
4. 返回PPT链接

## 示例
```
用户: 帮我做一个"AI发展历史"的PPT
→ 生成大纲 → 调用API → 返回PPT链接

用户: 把这个文档转成PPT
→ 提取要点 → 生成PPT → 返回结果
```

## 注意
- 需要Gamma API Key
- 可以指定风格（商务/学术/创意等）
- 默认生成10页左右
