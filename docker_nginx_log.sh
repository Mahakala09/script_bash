#!/bin/bash

# 📂 要檢查的目錄
TARGET_DIR="/var/log/nginx"

# 🕒 時間標記
cdate=$(date +"%Y%m%d-%H%M")

# 🔍 查找超過 2GB 的 log 檔案並備份壓縮
find "$TARGET_DIR" -type f -size +2G | while read -r logfile; do
    echo "📁 處理檔案: $logfile"

    # 備份副本檔名
    backup_file="${logfile}-${cdate}"

    # 拷貝備份
    cp "$logfile" "$backup_file"

    # 清空原始 log（不刪除）
    : > "$logfile"

    # 壓縮備份檔案
    gzip "$backup_file" && echo "✅ 已壓縮: ${backup_file}.gz" || echo "❌ 壓縮失敗: $backup_file"

    echo "-------------------------------------------"
done

# 🧹 清理 7 天前的 .gz 備份
echo "🧼 清理超過 7 天的壓縮檔案..."
find "$TARGET_DIR" -type f -name "*.gz" -mtime +7 -exec rm -f {} \; && echo "✅ 清理完成"
