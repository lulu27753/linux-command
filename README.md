# 先给init加权限，再执行
```
chmod +x init.sh
/root/code/linux-command/init.sh
```

## yt_mp4_only.sh
```
/root/code/linux-command/yt_mp4_only.sh "1a2b3c 4d5e6f"
/root/code/linux-command/yt_mp4_only.sh "https://www.bilibili.com/video/BV" "1a2b3c 4d5e6f"
```

## yt_sub_only.sh
```
/root/code/linux-command/yt_sub_only.sh "1a2b3c 4d5e6f"
/root/code/linux-command/yt_sub_only.sh "https://www.bilibili.com/video/BV" "1a2b3c 4d5e6f"
```

## vtt2ass.sh
```
/root/code/linux-command/vtt2ass.sh
```

## clean_old_logs.sh
```
crontab -e
0 2 * * * /root/code/linux-command/clean_old_logs.sh >> /root/logs/yt-dlp/clean_log_cron.log 2>&1
```

## yt-dlp日志
打开日志文件，搜索这些关键词：
- Error
- Failed
- HTTP
- Forbidden
- Unable to merge
就能立刻知道原因：
- 403 Forbidden = IP 被限制
- Unable to merge = 格式不兼容
- Fragment missing = 网络波动
- Unsupported URL = 网站不支持