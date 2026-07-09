#!/bin/bash

LAST_RUN_FILE="/tmp/login_monitor_last_run"
EMAIL="admin@example.com"
NOW=$(date +%s)

if [ ! -f "$LAST_RUN_FILE" ]; then
  date -d '5 minutes ago' +%s > "$LAST_RUN_FILE"
fi

LAST_RUN=$(cat "$LAST_RUN_FILE")
SINCE=$(date -d @"$LAST_RUN" '+%Y-%m-%d %H:%M:%S')

LOGINS=$(journalctl _SYSTEMD_UNIT=sshd.service --since "$SINCE" --no-pager | \
  grep "session opened for user")

if [ -n "$LOGINS" ]; then
  echo "$LOGINS" | mail -s "Login Activity: $HOSTNAME" "$EMAIL"
fi

echo "$NOW" > "$LAST_RUN_FILE"