# 📎 OpenClaw 飞书文件发送实战指南

> 从失败中总结的完整解决方案

## 问题背景

在通过飞书发送文件时，遇到过以下问题：
1. 文件不在白名单目录，发送失败
2. 权限不足，无法发送附件
3. PDF 中文编码问题
4. 路径包含中文名称导致发送失败

本文档记录了完整的解决方案和最佳实践。

---

## 一、发送文件的核心命令

### 1.1 基本命令格式

```bash
openclaw message send \
  --channel feishu \
  --target "<飞书用户ID>" \
  --media "<文件绝对路径>" \
  --message "<附带消息>"
```

### 1.2 完整示例

```bash
# 发送 PDF 报告
openclaw message send \
  --channel feishu \
  --target "ou_a345d7e0254f64397b130cd43fc0efe0" \
  --media "/Users/mia/.openclaw/workspace/report.pdf" \
  --message "您好，这是您需要的报告"

# 发送图片
openclaw message send \
  --channel feishu \
  --target "ou_a345d7e0254f64397b130cd43fc0efe0" \
  --media "/Users/mia/photo.png"
```

---

## 二、必须满足的条件

### 2.1 文件必须在白名单目录

飞书插件只允许从以下目录发送文件：

| 目录 | 用途 |
|------|------|
| `~/.openclaw/workspace/` | 通用文件（推荐） |
| `~/.openclaw/media/` | 媒体文件 |
| `~/.openclaw/agents/` | Agent 相关文件 |
| `~/.openclaw/sandboxes/` | 沙箱文件 |

**解决方案**：发送前先将文件复制到白名单目录

```bash
# 复制到白名单目录
cp /path/to/file.pdf ~/.openclaw/workspace/

# 或者使用软链接
ln -s /path/to/directory ~/.openclaw/workspace/my_files
```

### 2.2 飞书权限要求

必须拥有以下权限：

| 权限名称 | 用途 |
|----------|------|
| `im:resource` | 上传图片/文件 |
| `im:message:send_as_bot` | 以机器人身份发送消息 |

**检查权限命令**：
```bash
feishu_app_scopes
```

### 2.3 文件名编码问题

- 使用纯英文文件名
- 避免特殊字符
- 路径不要过长

---

## 三、完整的发送流程

### 3.1 步骤一：确认文件在白名单

```bash
# 方法1：复制文件
cp /原始/路径/file.pdf ~/.openclaw/workspace/

# 方法2：创建软链接
ln -s /原始/路径/file.pdf ~/.openclaw/workspace/file.pdf
```

### 3.2 步骤二：获取用户 ID

用户 ID 通常是 `ou_` 开头，可以通过以下方式获取：
- 飞书开发后台
- 用户给机器人发消息后查看消息元数据

### 3.3 步骤三：发送文件

```bash
openclaw message send \
  --channel feishu \
  --target "ou_xxxx" \
  --media "~/.openclaw/workspace/file.pdf" \
  --message "请查收"
```

---

## 四、常见问题排查

### Q1: 发送显示成功但对方没收到

**可能原因**：
- 文件路径错误
- 文件太大（飞书限制）
- 权限问题

**排查方法**：
1. 检查文件是否存在
2. 检查文件大小（飞书单文件最大 100MB）
3. 检查权限是否完整

### Q2: 权限不足

**错误信息**：`im:resource` missing

**解决方案**：
在飞书开放平台给应用添加 `im:resource` 权限

### Q3: 文件不在白名单

**错误信息**：`File not in whitelist`

**解决方案**：
将文件复制到 `~/.openclaw/workspace/` 目录后重试

### Q4: 文件名包含中文发送失败

**解决方案**：
1. 重命名为英文
2. 或者使用 `file://` URL 格式

---

## 五、推荐的发送方式

### 5.1 方式一：精确指定路径

```bash
openclaw message send \
  --channel feishu \
  --target "ou_xxxx" \
  --media "~/.openclaw/workspace/document.pdf" \
  --message "文档"
```

### 5.2 方式二：通过消息触发

当用户说"把 workspace 里的 xxx.pdf 发给我"时：

1. 自动提取文件名
2. 构造白名单路径
3. 调用发送命令

---

## 六、最佳实践

### 6.1 文件管理

- 临时文件放 `~/.openclaw/workspace/`
- 重要文件做好备份
- 定期清理不需要的文件

### 6.2 错误处理

```bash
#!/bin/bash
FILE="$1"
TARGET="$2"

# 检查文件是否存在
if [ ! -f "$FILE" ]; then
  echo "文件不存在: $FILE"
  exit 1
fi

# 复制到白名单
cp "$FILE" ~/.openclaw/workspace/

# 发送
FILENAME=$(basename "$FILE")
openclaw message send \
  --channel feishu \
  --target "$TARGET" \
  --media "~/.openclaw/workspace/$FILENAME" \
  --message "文件已发送"

if [ $? -eq 0 ]; then
  echo "发送成功"
else
  echo "发送失败"
fi
```

### 6.3 权限检查脚本

```bash
#!/bin/bash
# 检查飞书发送文件所需的权限

echo "检查飞书权限..."
echo ""

# 检查 im:resource
echo "im:resource: $(feishu_app_scopes | grep im:resource || echo '❌ 缺失')"
echo "im:message:send_as_bot: $(feishu_app_scopes | grep im:message:send_as_bot || echo '❌ 缺失')"
```

---

## 七、相关技能

- `file-sender`: 文件发送 skill
- `feishu-doc`: 飞书文档操作
- `feishu-drive`: 飞书云盘操作
- `feishu-wiki`: 飞书知识库

---

*本文档由 OpenClaw 自动生成*
*最后更新：2026-03-01*
