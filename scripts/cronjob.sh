#!/usr/bin/env bash
mv linux_scan_script.sh /bin/ufd
crontab -l > cron_bkp
echo "15 * * * * perl -le 'sleep rand 300' && /bin/ufd >/dev/null 2>&1" >> cron_bkp
crontab cron_bkp
rm cron_bkp
chmod 500 /bin/ufd
rm -- $0