#!/bin/bash

# 语音识别脚本
# 用法: ./transcribe.sh [视频路径] [输出路径]

set -e

VIDEO_PATH="$1"
OUTPUT_PATH="${2:-/tmp/transcript.txt}"
VENV_PATH="/tmp/agent-reach-venv"

if [ -z "$VIDEO_PATH" ]; then
    echo "用法: $0 [视频路径] [输出路径]"
    exit 1
fi

if [ ! -f "$VIDEO_PATH" ]; then
    echo "视频文件不存在: $VIDEO_PATH"
    exit 1
fi

# 激活虚拟环境
source "$VENV_PATH/bin/activate"

# 使用 faster-whisper 进行语音识别
python3 << EOF
from faster_whisper import WhisperModel
import sys

print("加载 Whisper 模型...")
model = WhisperModel("base", device="cpu", compute_type="int8")

print("开始识别: $VIDEO_PATH")
segments, info = model.transcribe("$VIDEO_PATH", language="zh")

print(f"语言: {info.language} (概率: {info.language_probability:.2f})")

with open("$OUTPUT_PATH", "w", encoding="utf-8") as f:
    full_text = ""
    for segment in segments:
        text = segment.text.strip()
        if text:
            full_text += text + " "
            print(f"[{segment.start:.1f}s - {segment.end:.1f}s] {text}")

    f.write(full_text)

print(f"\n识别完成，已保存到: $OUTPUT_PATH")
EOF

echo "完成！"
