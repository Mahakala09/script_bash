#!/usr/bin
# 指定要检查的目录
TARGET_DIR="/var/log/nginx/"
ngdate=$(date +%Y%m%d)
times=$(date +%H:%M)
cdate=${ngdate}-${times}-${ngdate}
# 查找超过2GB的文件
find "$TARGET_DIR" -type f -size +2G | while read -r logfile; do
    # 将原文件内容追加到备份文件中
    cat "$logfile" > "${logfile}-${cdate}"
    
    # 清空原始文件
    cat /dev/null > "$logfile"
    
    # 压缩备份文件
    gzip "${logfile}-${cdate}"
    
    #echo "已处理文件: $logfile"
done
