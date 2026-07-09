#!/bin/bash

LOGFILE="/var/log/auth.log"
LAST_RUN_FILE="/tmp/login_monitor_last_run"
EMAIL="admin@example.com"
NOW=$(date +%s)

if [ ! -f "$LAST_RUN_FILE" ]; then
  date -d '5 minutes ago' +%s > "$LAST_RUN_FILE"
fi

LAST_RUN=$(cat "$LAST_RUN_FILE")

# 下面是awk，这是 awk 的模式（pattern），只处理包含字符串 session opened for user 的行
# 这是 /var/log/auth.log 中表示用户登录事件的标准日志格式，比如：
#   Jul  8 10:23:45 myserver sshd[1234]: session opened for user bob by (uid=0)
# ② 日志行的字段
#对于上面这行日志，awk 默认按空白符分割：
#$1 = "Jul"
#$2 = "8"
#$3 = "10:23:45"
#cmd = "date -d \""$1" "$2" "$3" $(date +%Y)\" +%s 2>/dev/null"
#这是在拼接一个 shell 命令字符串，实际展开后类似：
#date -d "Jul 8 10:23:45 $(date +%Y)" +%s 2>/dev/null
#为什么要拼接 $(date +%Y)？
#因为 /var/log/auth.log 里的时间戳只包含月、日、时间，没有年份：
#Jul  8 10:23:45
#所以用 $(date +%Y) 补上当前年份（比如 2026），构成完整的日期字符串 Jul 8 10:23:45 2026，然后交给 date -d 解析成时间戳。
#- cmd | getline t：执行 cmd 这个 shell 命令，把它的输出读到 awk 变量 t 中
#- close(cmd)：关闭管道，避免内存/文件描述符泄漏

#执行后 t 的值就是该日志行的时间戳（如 1751443425）
#t+0
# 含义: 把字符串 t 强制转成数字（awk 的惯用写法）
#print $0
#含义: 满足条件就输出整行

LOGINS=$(awk '/session opened for user/ {
  cmd = "date -d \""$1" "$2" "$3" $(date +%Y)\" +%s 2>/dev/null"
  cmd | getline t
  close(cmd)
  if (t+0 >= '"$LAST_RUN"'+0 && t+0 <= '"$NOW"'+0) print $0 }' "$LOGFILE") 
  if [ -n "$LOGINS" ]; then 
  echo "$LOGINS" | mail -s "Login Activity: $HOSTNAME" "$EMAIL" 
  fi 
  echo "$NOW" > "$LAST_RUN_FILE"