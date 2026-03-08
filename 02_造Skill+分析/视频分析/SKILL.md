# ClaudeCode Skill: 视频学习笔记助手

## Skill 定义

```yaml
name: video-learning-assistant
description: 一键分析抖音/B站视频，自动提取口播内容、生成学习笔记、保存视频文件
version: 1.1.0
author: syzl8512
```

## 触发指令

### 模式一：快速总结（不含图像分析）

```
帮我分析这个视频 + [视频链接]
```

或

```
请你帮我分析总结这个视频 + [视频链接]
```

**工作流程**：
1. 视频解析（抖音/B站）
2. 下载视频
3. Whisper语音识别 → 逐字稿
4. 生成学习笔记（不含图像分析）

---

### 模式二：完整分析（含图像分析）

```
请你逐帧分析总结这个视频 + [视频链接]
```

**工作流程**：
1. 视频解析（抖音/B站）
2. 下载视频
3. Whisper语音识别 → 逐字稿
4. ffmpeg提取关键帧（每30秒1帧）
5. MiniMax图像理解分析
6. 生成完整学习笔记（含视觉分析）
7. 可选：生成讲解稿

## 工作流详解

### 第一步：视频解析

1. **抖音视频**
   - 使用 mcporter 调用 douyin.parse_douyin_video_info 获取视频信息
   - 获取下载链接

2. **B站视频**
   - 使用 yt-dlp --dump-json 获取视频元信息
   - 使用 yt-dlp 下载视频（需要登录获取字幕）

### 第二步：视频下载

```bash
# 抖音
mcporter call 'douyin.parse_douyin_video_info(share_link: "链接")'
yt-dlp "下载链接" -o /tmp/video.mp4

# B站
yt-dlp --cookies-from-browser chrome "视频URL" -o /tmp/video.mp4
```

### 第三步：语音识别（两种模式都需要）

使用 faster-whisper 进行语音转文字：

```bash
# 安装
uv pip install faster-whisper

# 识别
python -c "
from faster_whisper import WhisperModel
model = WhisperModel('base', device='cpu', compute_type='int8')
segments, info = model.transcribe('视频路径', language='zh')
for segment in segments:
    print(segment.text)
"
```

### 第四步：生成笔记（两种模式都需要）

1. 整理口播内容（逐字稿）
2. 提取关键要点
3. 生成结构化笔记
4. 保存到指定目录

### 第五步：视觉分析（仅模式二）

```bash
# 提取关键帧
ffmpeg -i video.mp4 -vf "fps=1/30" frames/frame_%04d.jpg

# 使用 MiniMax 视觉理解分析
mcp__minimax__understand_image
```

## 文件结构

```
video-learning-skill/
├── SKILL.md              # 本技能定义
├── README.md             # 操作说明
├── scripts/
│   ├── extract_video.sh  # 视频下载脚本
│   └── transcribe.sh     # 语音识别脚本
└── templates/
    └── note_template.md   # 笔记模板
```

## 依赖工具

| 工具 | 安装方式 | 用途 |
|------|----------|------|
| yt-dlp | pip install yt-dlp | 视频下载 |
| faster-whisper | pip install faster-whisper | 语音识别 |
| browser-cookie3 | pip install browser-cookie3 | 提取Cookie |
| ffmpeg | brew install ffmpeg | 视频处理 |
| mcporter | npm install -g mcporter | MCP工具 |
| DashScope API | 阿里云百炼 | 抖音MCP解析 |

## 配置说明

### 环境变量

在 `.env` 文件中添加：

```bash
# 阿里云百炼（抖音MCP需要）
DASHSCOPE_API_KEY=sk-xxxx
```

### Cookie 配置

B站和抖音需要登录Cookie：

```bash
# 自动从浏览器提取
agent-reach configure --from-browser chrome

# 手动配置
# 使用 Cookie-Editor 插件导出
```

## 使用示例

### 示例1：快速总结（不含图像分析）

```
用户：帮我分析这个视频 https://www.bilibili.com/video/BVxxx

助手：
1. 下载视频 → 2. Whisper语音识别 → 3. 生成学习笔记
→ 4. 保存到 03_生活/学习记录/

输出：
- 逐字稿
- 内容总结
- 关键要点
```

### 示例2：完整分析（含图像分析）

```
用户：请你逐帧分析总结这个视频 https://www.bilibili.com/video/BVxxx

助手：
1. 下载视频 → 2. Whisper语音识别 → 3. 提取关键帧
→ 4. 图像理解分析 → 5. 生成完整笔记
→ 6. 保存到 03_生活/学习记录/

输出：
- 逐字稿
- 内容总结
- 关键要点
- 视觉设计分析
- 关键帧截图
- 讲解稿（可选）
```

## 输出产物

### 模式一（快速总结）

- 视频文件：`attachments/抖音视频/` 或 `attachments/B站视频/`
- 学习笔记：`03_生活/学习记录/YYYYMMDD_标题.md`

### 模式二（完整分析）

- 视频文件：`attachments/抖音视频/` 或 `attachments/B站视频/`
- 学习笔记：`03_生活/学习记录/YYYYMMDD_标题.md`
- 视觉分析报告：`03_生活/学习记录/YYYYMMDD_标题_视觉分析报告.md`
- 讲解稿（如需要）：`03_生活/学习记录/YYYYMMDD_标题_讲解稿.md`
- 关键帧截图：`attachments/抖音视频/frames/` 或 `attachments/B站视频/frames/`

## 注意事项

1. 抖音视频需要 DashScope API Key（阿里云百炼）
2. B站字幕需要登录获取Cookie
3. 语音识别使用 faster-whisper，模型下载需要网络
4. 视频文件较大，建议定期清理 /tmp 目录
5. 模式二会提取大量关键帧，磁盘空间需求更大
