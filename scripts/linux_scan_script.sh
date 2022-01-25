#!/bin/usr/env bash

sudo journalctl --since "30 minutes ago" -o json-pretty > "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-syslogs".json
sudo ps aux > "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-processlist".txt
sudo systemctl list-timers --all > "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt
for user in $(getent passwd | awk -F : '{print $1}'); do echo $user >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt; crontab -u $user -l >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt 2>&1; done

echo "Listing /etc/cron.d" >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt
cat /etc/cron.d/* >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt 2>/dev/null

echo "Listing /etc/crontab" >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt
cat /etc/crontab >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt 2>/dev/null

echo "Listing /etc/cron.hourly" >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt
cat /etc/cron.hourly/* >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt 2>/dev/null

echo "Listing /etc/cron.daily" >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt
cat /etc/cron.daily/* >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt 2>/dev/null

echo "Listing /etc/cron.weekly" >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt
cat /etc/cron.weekly/* >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt 2>/dev/null
 
echo "Listing /etc/cron.monthly" >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt
cat /etc/cron.monthly/* >> "$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt 2>/dev/null
