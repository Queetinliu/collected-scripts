#!/bin/bash
BACKUP_DIR="/backup"
SOURCE_DIRS="/etc /var/www /home"
DATE=$(date +%F)
BACKUP_FILE="$BACKUP_DIR/backup-$DATE.tar.gz"
EMAIL="admin@example.com"

tar -czf $BACKUP_FILE $SOURCE_DIRS

if [ $? -eq 0 ]; then
  echo "Backup completed successfully: $BACKUP_FILE" | mail -s "Backup Success - $HOSTNAME" $EMAIL
else
  echo "Backup FAILED!" | mail -s "Backup Failed - $HOSTNAME" $EMAIL
fi