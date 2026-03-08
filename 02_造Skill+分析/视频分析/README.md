# OpenClaw 实战经验库

> 记录我们使用 OpenClaw/ClaudeCode 进行 AI 自动化工作的实战经验

## 目录

- [视频学习笔记助手](#视频学习笔记助手)
- [环境配置](#环境配置)
- [工具安装](#工具安装)
- [常见问题](#常见问题)

---

## 视频学习笔记助手

一键分析抖音/B站视频，自动提取口播内容、生成学习笔记、保存视频文件。

### 功能特性

| 功能 | 说明 |
|------|------|
| 视频解析 | 自动获取抖音/B站视频信息 |
| 语音识别 | 使用 Whisper 提取口播内容 |
| 笔记生成 | 结构化整理学习要点 |
| 视觉分析 | 可选：提取关键帧并进行图片分析 |
| 讲解稿生成 | 可选：生成完整讲解稿 |

### 使用方法

#### 1. 基础使用

```
帮我分析这个视频 + [视频链接]
```

助手会自动完成：
1. 解析视频信息
2. 下载视频
3. 语音识别提取口播
4. 生成学习笔记
5. 保存到指定目录

#### 2. 完整分析（含视觉分析）

```
帮我分析这个视频 + [视频链接]，做图片抽样和视觉分析
```

额外生成：
- 视频关键帧截图
- 页面设计分析报告

#### 3. 生成讲解稿

```
帮我分析这个视频 + [视频链接]，生成讲解稿
```

额外生成：
- 完整讲解稿
- 记忆点提炼

---

## 环境配置

### Python 环境

我们使用 `uv` 管理 Python 环境：

```bash
# 创建虚拟环境
uv venv /tmp/agent-reach-venv --python 3.11

# 激活环境
source /tmp/agent-reach-venv/bin/activate
```

### 必需工具安装

```bash
# 1. 安装 agent-reach
uv pip install https://github.com/Panniantong/agent-reach/archive/main.zip

# 2. 安装视频处理工具
uv pip install yt-dlp faster-whisper browser-cookie3

# 3. 安装 MCP 工具
npm install -g mcporter

# 4. 安装 ffmpeg（macOS）
brew install ffmpeg
```

### 环境变量配置

在项目 `.env` 文件中添加：

```bash
# 阿里云百炼（抖音MCP需要）
DASHSCOPE_API_KEY=sk-你的APIKey
```

---

## 工具安装详解

### 1. Agent Reach 安装

Agent Reach 是我们的核心工具集成了：

- yt-dlp：视频下载
- Exa Search：全网搜索
- Jina Reader：网页读取
- GitHub CLI：代码操作

```bash
# 安装
uv pip install https://github.com/Panniantong/agent-reach/archive/main.zip

# 初始化配置
agent-reach install --env=auto

# 检查状态
agent-reach doctor
```

### 2. 抖音 MCP 配置

抖音视频解析需要：

1. **获取 DashScope API Key**
   - 访问 https://bailian.console.aliyun.com/
   - 开通阿里云百炼（免费100万tokens）
   - 创建 API Key

2. **启动 Douyin MCP**
   ```bash
   # 安装
   uv pip install douyin-mcp-server

   # 启动（设置API Key）
   export DASHSCOPE_API_KEY="sk-xxx"
   python -c "
   from douyin_mcp_server.server import mcp
   mcp.settings.host = '127.0.0.1'
   mcp.settings.port = 18070
   mcp.run(transport='streamable-http')
   "

   # 注册到 mcporter
   mcporter config add douyin http://localhost:18070/mcp
   ```

3. **使用**
   ```bash
   mcporter call 'douyin.parse_douyin_video_info(share_link: "抖音链接")'
   ```

### 3. B站视频下载

B站视频下载需要登录Cookie：

```bash
# 方法1：自动从浏览器提取
agent-reach configure --from-browser chrome

# 方法2：手动导出Cookie
# 1. 打开B站并登录
# 2. 使用 Cookie-Editor 插件导出
# 3. 保存Cookie文件
```

下载命令：
```bash
# 带Cookie下载
yt-dlp --cookies-from-browser chrome "视频URL" -o /tmp/video.mp4

# 提取信息
yt-dlp --dump-json "视频URL"
```

### 4. 语音识别

我们使用 faster-whisper 进行本地语音识别：

```bash
# 安装
uv pip install faster-whisper

# 基础用法
python -c "
from faster_whisper import WhisperModel
model = WhisperModel('base', device='cpu', compute_type='int8')
segments, info = model.transcribe('video.mp4', language='zh')
for segment in segments:
    print(segment.text)
"

# 参数说明
# model: 'tiny', 'base', 'small', 'medium', 'large'
# device: 'cpu' 或 'cuda'
# compute_type: 'int8', 'float16', 'float32'
```

### 5. 视频关键帧提取

```bash
# 安装 ffmpeg
brew install ffmpeg

# 提取关键帧（每30秒一帧）
ffmpeg -i video.mp4 -vf "fps=1/30" frames/frame_%04d.jpg

# 提取单帧
ffmpeg -i video.mp4 -ss 00:01:00 -vframes 1 frame.jpg
```

### 6. 图片分析

使用 MiniMax 视觉理解：

```bash
mcp__minimax__understand_image(
    image_source="图片路径或URL",
    prompt="详细分析这张图片..."
)
```

---

## 常见问题

### Q1: 抖音视频下载失败

**问题**：ERROR: Fresh cookies needed

**解决**：
1. 确保已设置 DASHSCOPE_API_KEY
2. 或使用 Cookie-Editor 导出最新Cookie

### Q2: B站字幕无法下载

**问题**： Subtitles are only available when logged in

**解决**：
```bash
yt-dlp --cookies-from-browser chrome --write-subs "视频URL"
```

### Q3: Whisper 识别结果不准确

**解决**：
1. 使用更大的模型（如 small、medium）
2. 检查视频音频是否清晰
3. 手动校正关键段落

### Q4: MCP 服务连接失败

**解决**：
1. 检查服务是否启动：`curl http://localhost:18070/mcp`
2. 重启服务：`pkill -f douyin && 重启`
3. 检查端口是否被占用

### Q5: 视频文件太大

**解决**：
1. 定期清理 /tmp 目录
2. 压缩保存的视频
3. 只保存关键帧而非完整视频

---

## 目录结构

```
项目目录/
├── 03_生活/
│   └── 学习记录/
│       ├── YYYYMMDD_标题.md          # 学习笔记
│       ├── YYYYMMDD_标题_视觉分析.md  # 视觉分析报告
│       ├── YYYYMMDD_标题_讲解稿.md   # 讲解稿
│       └── attachments/
│           ├── 抖音视频/
│           └── B站视频/
├── .env                              # 环境变量
└── scripts/                          # 工具脚本
```

---

## 经验总结

### 1. 抖音视频分析流程

```
抖音链接
    ↓
mcporter 获取视频信息
    ↓
获取下载链接
    ↓
yt-dlp 下载视频
    ↓
faster-whisper 语音识别
    ↓
生成学习笔记
    ↓
保存到目录
```

### 2. B站视频分析流程

```
B站链接
    ↓
yt-dlp --dump-json 获取信息
    ↓
Cookie验证
    ↓
下载视频/字幕
    ↓
faster-whisper 语音识别
    ↓
生成笔记
```

### 3. 视觉分析流程

```
视频文件
    ↓
ffmpeg 提取关键帧
    ↓
选择代表性帧（5-10张）
    ↓
MiniMax 视觉理解分析
    ↓
整合分析报告
```

---

## 更新日志

### 2026-03-02
- 初始版本
- 完成视频分析工作流
- 完成语音识别集成
- 完成笔记生成功能
- 完成视觉分析功能
- 完成讲解稿生成功能

---

## 贡献指南

欢迎提交 Issue 和 PR！

1. Fork 本仓库
2. 创建功能分支
3. 提交更改
4. 发起 Pull Request

---

## 许可证

MIT License
