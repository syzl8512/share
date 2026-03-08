---
name: file-sender
description: 通过 OpenClaw CLI 发送文件到飞书。支持 PDF、图片、视频等附件发送。
metadata:
  {
    "openclaw": {
      "emoji": "📎",
      "requires": { "bins": ["openclaw"] },
      "os": ["darwin", "linux", "win32"]
    }
  }
---

# File Sender Skill

用于通过 OpenClaw CLI 发送本地文件到飞书。

## 使用场景

- 发送 PDF 报告给用户
- 发送图片给用户
- 发送文档给用户

## 发送文件的方法

### 方法一：使用 OpenClaw CLI（推荐）

```bash
openclaw message send \
  --channel feishu \
  --target "<飞书用户ID>" \
  --media "/文件/路径/文件名.pdf" \
  --message "这是文件"
```

### 参数说明

| 参数 | 说明 | 示例 |
|------|------|------|
| `--channel` | 消息渠道 | `feishu` |
| `--target` | 接收者 ID | `ou_xxxx` 或群聊 ID |
| `--media` | 文件本地路径 | `/Users/mia/Desktop/report.pdf` |
| `--message` | 附带的文字消息 | "请查收文件" |

### 示例命令

```bash
# 发送 PDF 文件
openclaw message send \
  --channel feishu \
  --target "ou_a345d7e0254f64397b130cd43fc0efe0" \
  --media "/Users/mia/.openclaw/workspace/report.pdf" \
  --message "这是您的报告"

# 发送图片
openclaw message send \
  --channel feishu \
  --target "ou_a345d7e0254f64397b130cd43fc0efe0" \
  --media "/Users/mia/photo.png"
```

### 方法二：使用 message 工具

在代码中调用时，可以使用 message 工具的 filePath 参数：

```javascript
{
  "tool": "message",
  "action": "send",
  "channel": "feishu",
  "target": "ou_xxxx",
  "message": "请查收文件",
  "filePath": "/path/to/file.pdf"
}
```

## 常见问题

### Q: 为什么发送失败？

A: 检查以下几点：

1. 文件路径是否正确（使用绝对路径）
2. 文件是否在白名单目录：
   - `~/.openclaw/workspace/`
   - `~/.openclaw/media/`
   - `~/.openclaw/agents/`
3. 飞书是否有 `im:resource` 权限

### Q: 如何获取用户 ID？

A: 用户 ID 通常是 `ou_` 开头，可以在飞书开发后台查看，或让用户给你的机器人发消息来获取。

### Q: 支持哪些文件类型？

A: 飞书支持：PDF、图片（PNG/JPG/GIF）、视频（MP4）、文档（Word/Excel）等。

## 完整示例

```bash
#!/bin/bash
# 发送报告的脚本

USER_ID="ou_a345d7e0254f64397b130cd43fc0efe0"
FILE_PATH="/Users/mia/.openclaw/workspace/report.pdf"

openclaw message send \
  --channel feishu \
  --target "$USER_ID" \
  --media "$FILE_PATH" \
  --message "您好，这是您需要的报告，请查收！"

if [ $? -eq 0 ]; then
  echo "文件发送成功"
else
  echo "文件发送失败"
fi
```

---

*创建时间：2026-03-01*
