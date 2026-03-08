#!/bin/bash

# 视频下载脚本
# 用法: ./download_video.sh [抖音链接|B站链接] [输出目录]

set -e

VIDEO_URL="$1"
OUTPUT_DIR="${2:-/tmp}"
VENV_PATH="/tmp/agent-reach-venv"

# 激活虚拟环境
source "$VENV_PATH/bin/activate"

# 检测视频平台
if echo "$VIDEO_URL" | grep -q "douyin.com\|douyin.com\|v.douyin.com"; then
    echo "检测到抖音视频..."
    PLATFORM="douyin"
elif echo "$VIDEO_URL" | grep -q "bilibili.com\|b23.tv"; then
    echo "检测到B站视频..."
    PLATFORM="bilibili"
else
    echo "不支持的视频平台"
    exit 1
fi

# 生成输出文件名
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="$OUTPUT_DIR/video_${TIMESTAMP}.mp4"

if [ "$PLATFORM" = "douyin" ]; then
    # 抖音视频下载
    VIDEO_INFO=$(mcporter call "douyin.parse_douyin_video_info(share_link: \"$VIDEO_URL\")")
    DOWNLOAD_URL=$(echo "$VIDEO_INFO" | jq -r '.download_url')

    echo "下载链接: $DOWNLOAD_URL"
    yt-dlp "$DOWNLOAD_URL" -o "$OUTPUT_FILE"

else
    # B站视频下载
    yt-dlp --cookies-from-browser chrome "$VIDEO_URL" -o "$OUTPUT_FILE"
fi

echo "视频已保存到: $OUTPUT_FILE"
echo "$OUTPUT_FILE"
