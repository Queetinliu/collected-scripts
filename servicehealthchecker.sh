#!/bin/bash

SERVICES=("apache2" "mysql" "ssh")
EMAIL="admin@example.com"

for SERVICE in "${SERVICES[@]}"; do
  if ! systemctl is-active --quiet "$SERVICE"; then
    systemctl start "$SERVICE"
    STATUS=$?
    if [ $STATUS -eq 0 ]; then
      echo "$SERVICE was down and has been restarted on $HOSTNAME" | \
        mail -s "Service Restarted: $SERVICE on $HOSTNAME" "$EMAIL"
    else
      echo "$SERVICE failed to restart on $HOSTNAME. Manual intervention needed." | \
        mail -s "Service FAILED to Restart: $SERVICE on $HOSTNAME" "$EMAIL"
    fi
  fi
done