#!/bin/bash

# ===================== 配置区域（你只需要改这里）=====================
# 你的下载目录（和你 yt-dlp 的 OUTPUT_DIR 保持一致）
Log_DIR="/root/logs/yt-dlp"

# 清理多少天以前的日志（这里是7天）
DAYS_TO_KEEP=7
# =====================================================================

# 检查目录是否存在
if [ ! -d "$Log_DIR" ]; then
    echo "错误：目录不存在 → $Log_DIR"
    exit 1
fi

echo "============================================="
echo "开始清理 $DAYS_TO_KEEP 天前的日志文件..."
echo "清理目录：$Log_DIR"
echo "============================================="

# 只删除 .log 结尾的文件，不会碰视频！
find "$Log_DIR" -maxdepth 1 -type f -name "*.log" -mtime +$DAYS_TO_KEEP -delete

echo "✅ 清理完成！已删除 $DAYS_TO_KEEP 天前的所有日志"