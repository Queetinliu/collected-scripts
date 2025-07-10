#!/bin/bash
THRESHOLD=80
EMAIL="admin@example.com"

df -hP | grep -vE '^Filesystem|tmpfs|cdrom' | while read line; do
  USAGE=$(echo $line | awk '{print $5}' | sed 's/%//')
  MOUNTPOINT=$(echo $line | awk '{print $6}')
  
  if [ $USAGE -ge $THRESHOLD ]; then
    echo "Warning: High disk usage on $MOUNTPOINT ($USAGE%)" | mail -s "Disk Alert: $HOSTNAME" $EMAIL
  fi
done