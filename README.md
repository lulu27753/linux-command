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