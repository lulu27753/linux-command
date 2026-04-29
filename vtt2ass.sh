#!/bin/bash

# 标题
echo "========================================="
echo "        VTT 批量转换为 ASS 字幕"
echo "========================================="

# 询问文件夹路径，默认当前文件夹
read -p "请输入要处理的文件夹路径 [默认当前文件夹]: " target_dir

# 如果用户没输入，使用当前目录
if [ -z "$target_dir" ]; then
    target_dir="$(pwd)"
fi

# 检查目录是否存在
if [ ! -d "$target_dir" ]; then
    echo "❌ 目录不存在：$target_dir"
    exit 1
fi

echo ""
echo "📂 处理目录：$target_dir"
echo "===================================================="
echo ""

# 统计 vtt 文件数量
vtt_count=$(find "$target_dir" -maxdepth 1 -type f -iname "*.vtt" | wc -l)

if [ "$vtt_count" -eq 0 ]; then
    echo "⚠️  该目录下没有找到任何 .vtt 文件"
    exit 0
fi

echo "✅ 找到 $vtt_count 个 VTT 字幕文件，开始转换..."
echo ""

# 批量转换
find "$target_dir" -maxdepth 1 -type f -iname "*.vtt" | while read -r vtt_file; do
    ass_file="${vtt_file%.vtt}.ass"
    echo "🔄 转换：$(basename "$vtt_file")"
    
    ffmpeg -i "$vtt_file" "$ass_file" -hide_banner -loglevel error
    
    if [ -f "$ass_file" ]; then
        echo "✅ 成功：$(basename "$ass_file")"
    else
        echo "❌ 失败：$(basename "$vtt_file")"
    fi
    echo ""
done

echo "========================================="
echo "🎉 全部转换完成！"
echo "========================================="