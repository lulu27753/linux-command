#!/bin/bash

# 默认配置
DEFAULT_OUTPUT_DIR="/root/aria2_download"
Log_DIR="/root/logs/yt-dlp"
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
# 判断日志目录是否存在，不存在则创建
if [ ! -d "$Log_DIR" ]; then
    echo "📂 日志目录不存在，正在创建..."
    mkdir -p "$Log_DIR"
fi

# 转为数组
VIDEO_IDS=($ID_INPUT)
LOG_FILE="${Log_DIR}/download-$(date +%Y%m%d-%H%M%S).log"

# 开始下载
echo -e "\n🚀 开始后台下载，日志将保存到：${LOG_FILE}"
echo "📂 输出目录：$OUTPUT_DIR"
echo ""

# 记录后台进程PID，方便等待
pids=()

for ID in "${VIDEO_IDS[@]}"; do
    URL="${BASE_URL}${ID}"
    echo "========================================"
    echo "🎬 已加入下载队列：$URL"
    echo "========================================"

    # 后台下载，重定向日志（日志文件会自动创建）
    yt-dlp -f bestvideo+bestaudio \
        --retries 10 \
        --fragment-retries 10 \
        --concurrent-fragments 2 \
        --merge-output-format mp4 \
        --write-sub \
        --quiet --no-warnings \
        -o "${OUTPUT_DIR}/%(title)s.%(ext)s" \
        "$URL" >> "${LOG_FILE}" 2>&1 &

    # 保存进程ID
    pids+=("$!")
done

# 等待所有后台下载完成
echo -e "\n⌛ 等待所有下载任务完成..."
wait "${pids[@]}"

echo -e "\n🎉 全部下载任务处理完成！"
echo "📄 下载日志：${LOG_FILE}"