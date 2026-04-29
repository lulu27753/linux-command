#!/bin/bash

echo "========================================="
echo "        VTT 批量转换为 ASS 字幕"
echo "========================================="

read -p "请输入文件夹路径 [默认当前文件夹]: " target_dir

if [ -z "$target_dir" ]; then
    target_dir="$(pwd)"
else
    target_dir=$(eval echo "$target_dir")
fi

if [ ! -d "$target_dir" ]; then
    echo "❌ 目录不存在：$target_dir"
    exit 1
fi

echo ""
echo "📂 处理目录：$target_dir"
echo "===================================================="
echo ""

vtt_count=$(find "$target_dir" -maxdepth 1 -type f -iname "*.vtt" | wc -l)

if [ "$vtt_count" -eq 0 ]; then
    echo "⚠️  该目录下没有 .vtt 文件"
    exit 0
fi

echo "✅ 找到 $vtt_count 个 VTT 文件，开始转换..."
echo ""

find "$target_dir" -maxdepth 1 -type f -iname "*.vtt" | while read -r vtt_file; do
    ass_file="${vtt_file%.vtt}.ass"
    echo "🔄 转换：$(basename "$vtt_file")"
    
    ffmpeg -i "$vtt_file" "$ass_file" -hide_banner -loglevel error
    
    if [ -f "$ass_file" ]; then
        echo "✅ 成功：$(basename "$ass_file")"
    else
        echo "❌ 失败"
    fi
    echo ""
done

echo "🎉 全部转换完成！"