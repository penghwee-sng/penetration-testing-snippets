#!/usr/bin/env bash
$schtasks_name = "/tmp/$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-scheduledtasks".txt
$syslogs_name = "/tmp/$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-syslogs".json
$pslist_name = "/tmp/$HOSTNAME-`date +"%Y%m%d-%H%M%S"`-processlist".txt

sudo journalctl --since "30 minutes ago" -o json-pretty > $syslogs_name
sudo ps aux > $pslist_name
sudo systemctl list-timers --all > $schtasks_name
for user in $(getent passwd | awk -F : '{print $1}'); do echo $user >> $schtasks_name; crontab -u $user -l >> $schtasks_name 2>&1; done

echo "Listing /etc/cron.d" >> $schtasks_name
cat /etc/cron.d/* >> $schtasks_name 2>/dev/null

echo "Listing /etc/crontab" >> $schtasks_name
cat /etc/crontab >> $schtasks_name 2>/dev/null

echo "Listing /etc/cron.hourly" >> $schtasks_name
cat /etc/cron.hourly/* >> $schtasks_name 2>/dev/null

echo "Listing /etc/cron.daily" >> $schtasks_name
cat /etc/cron.daily/* >> $schtasks_name 2>/dev/null

echo "Listing /etc/cron.weekly" >> $schtasks_name
cat /etc/cron.weekly/* >> $schtasks_name 2>/dev/null
 
echo "Listing /etc/cron.monthly" >> $schtasks_name
cat /etc/cron.monthly/* >> $schtasks_name 2>/dev/null

chmod 400 $schtasks_name
chmod 400 $syslogs_name
chmod 400 $pslist_name