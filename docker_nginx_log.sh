#!/bin/bash

# Nginx 與 Docker log 主目錄
NGINX_LOG_DIR="/var/log/nginx"
DOCKER_LOG_DIR="/var/lib/docker/containers"

# 時間戳記
TIMESTAMP=$(date +"%Y%m%d-%H%M")

echo "🚀 啟動 log 清理腳本：$TIMESTAMP"

##################################
# 📦 處理 NGINX LOGS
##################################
echo "▶️ 處理 Nginx logs..."
find "$NGINX_LOG_DIR" -type f -size +2G | while read -r logfile; do
    echo "📁 處理: $logfile"
    cp "$logfile" "${logfile}-${TIMESTAMP}"
    : > "$logfile"
    gzip "${logfile}-${TIMESTAMP}" && echo "✅ 壓縮完成"
done

##################################
# 🐳 處理 DOCKER JSON LOGS
##################################
echo "▶️ 處理 Docker container logs..."

find "$DOCKER_LOG_DIR" -type f -name "*-json.log" -size +100M | while read -r dockerlog; do
    echo "📦 壓縮 Docker log: $dockerlog"
    cp "$dockerlog" "${dockerlog}-${TIMESTAMP}"
    : > "$dockerlog"
    gzip "${dockerlog}-${TIMESTAMP}" && echo "✅ 壓縮完成"
done

##################################
# 🧹 清理所有超過 7 天的 .gz 壓縮檔
##################################
echo "🧽 清理 7 天前的壓縮檔案..."

find "$NGINX_LOG_DIR" "$DOCKER_LOG_DIR" -type f -name "*.gz" -mtime +7 -exec rm -f {} \; && echo "✅ 舊壓縮檔已刪除"

echo "✅ 所有清理任務完成：$(date)"
