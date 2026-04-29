#!/bin/bash

# 默认配置
DEFAULT_OUTPUT_DIR="/root/aria2_download"
DEFAULT_BASE_URL="https://www.youtube.com/watch?v="

clear
echo "========================================"
echo " 🎬 YouTube 交互式下载工具"
echo "========================================"
echo ""

# 1. 输入视频ID
read -p "👉 输入视频ID（多个用空格分隔）：" ID_INPUT
if [ -z "$ID_INPUT" ]; then
    echo "❌ 请输入视频ID！"
    exit 1
fi

# 2. 是否使用默认 BASE_URL
read -p "🌐 使用默认YouTube地址？(Y/n) " use_base
if [[ "$use_base" =~ ^[Nn]$ ]]; then
    read -p "✏️ 自定义 BASE_URL：" BASE_URL
else
    BASE_URL="$DEFAULT_BASE_URL"
fi

# 3. 是否使用默认输出目录
read -p "📂 使用默认目录($DEFAULT_OUTPUT_DIR)? (Y/n) " use_dir
if [[ "$use_dir" =~ ^[Nn]$ ]]; then
    read -p "✏️ 自定义输出目录：" OUTPUT_DIR
else
    OUTPUT_DIR="$DEFAULT_OUTPUT_DIR"
fi

# 判断输出目录是否存在，不存在则创建
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "📂 输出目录不存在，正在创建..."
    mkdir -p "$OUTPUT_DIR"
fi

# 转为数组
VIDEO_IDS=($ID_INPUT)

# 开始下载
echo -e "\n🚀 开始下载..."
echo "📂 输出目录：$OUTPUT_DIR"
echo ""

for ID in "${VIDEO_IDS[@]}"; do
    URL="${BASE_URL}${ID}"
    echo "========================================"
    echo "🎬 下载：$URL"
    echo "========================================"
    # 下载最高清视频 + 音频
    # 合并为 MP4
    # 下载中文 + 英文字幕（手动 + 自动）
    # 内嵌 SRT 字幕进视频（所有播放器都能显示）
    # 同时保存 ASS 字幕文件（美观、可编辑）
    # yt-dlp -f bestvideo+bestaudio \
    #     --merge-output-format mp4 \
    #     --write-sub \
    #     --write-auto-sub \
    #     --embed-subs \
    #     --sub-format srt \
    #     --convert-subtitles ass \
    #     --sub-langs zh-Hans,en \
    #     -o "${OUTPUT_DIR}/%(title)s.%(ext)s" \
    #     "$URL"
    # 只要 ASS，不内嵌
    yt-dlp -f bestvideo+bestaudio \
    --merge-output-format mp4 \
    --write-auto-sub \
    --sub-format ass \
    --sub-langs zh-Hans \
    --sleep-subtitles 20 \
    --sleep-interval 10 \
    --ignore-errors \
    -o "${OUTPUT_DIR}/%(title)s.%(ext)s" \
    "$URL"
done

echo -e "\n🎉 全部下载完成！"