#!/bin/bash

# ========== 这里改成你自己的配置 ==========
USER="root"
HOST="154.64.254.189"
REMOTE_DIR="/root/"   # 远程绝对目录
LOCAL_SAVE_DIR="./"            # 保存到本地当前目录
# ==========================================

# 提取目录名（用于本地判断）
DIR_NAME=$(basename "$REMOTE_DIR")
LOCAL_FULL_PATH="${LOCAL_SAVE_DIR}/${DIR_NAME}"

echo "===== 开始下载远程目录：$REMOTE_DIR ====="
# 执行sftp下载
sftp -b - $USER@$HOST <<EOF
lcd $LOCAL_SAVE_DIR
get -r $REMOTE_DIR
exit
EOF

# 判断本地是否下载成功（目录存在且不为空）
if [ -d "$LOCAL_FULL_PATH" ] && [ "$(ls -A $LOCAL_FULL_PATH)" ]; then
    echo "✅ 下载成功，准备删除远程目录..."
    # 下载成功才执行删除
    sftp $USER@$HOST <<EOF
rm -r $REMOTE_DIR
exit
EOF
    echo "✅ 远程目录已删除完成"
else
    echo "❌ 下载失败或目录为空，不执行删除！"
    exit 1
fi