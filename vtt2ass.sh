#!/bin/bash

echo "========================================="
echo "        VTT 批量转换为 ASS 字幕（增强版）"
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

# 统计并获取所有vtt文件列表
mapfile -t vtt_files < <(find "$target_dir" -maxdepth 1 -type f -iname "*.vtt")
vtt_count=${#vtt_files[@]}

if [ "$vtt_count" -eq 0 ]; then
    echo "⚠️  该目录下没有 .vtt 文件"
    exit 0
fi

echo "✅ 找到 $vtt_count 个 VTT 文件，开始转换..."
echo ""

# 序号从1开始
index=1

for vtt_file in "${vtt_files[@]}"; do
    # 生成带序号的文件名：001_文件名.ass
    filename=$(basename -- "$vtt_file")
    filename_noext="${filename%.*}"
    ass_file="${target_dir}/$(printf "%03d" "$index")_${filename_noext}.ass"

    echo "🔄 [$index/$vtt_count] 转换：$filename"

    # 执行转换
    ffmpeg -i "$vtt_file" "$ass_file" -hide_banner -loglevel error

    if [ -f "$ass_file" ]; then
        echo "✅ 成功：$(basename "$ass_file")"
    else
        echo "❌ 失败：$filename"
    fi

    index=$((index + 1))
    echo ""
done

echo "🎉 全部转换完成！总计处理 $vtt_count 个文件"