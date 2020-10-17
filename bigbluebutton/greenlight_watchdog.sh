#!/bin/bash
BBB_CLEAN_A="/etc/cron.daily/bigbluebutton"
BBB_CLEAN_B="/etc/cron.daily/bbb-recording-cleanup"
echo $(date +"%m-%d-%Y %H:%M:%S")
# remove log file older than 3 days
find /var/log -maxdepth 1 -name greenlight.log -type f -mtime +3 -delete
status=$(curl --connect-timeout 30 -s --head -w %{http_code} https://whiteboard.eupheus.in/b -o /dev/null)
if [ "$status" == "200" ]; then
    echo "greenlight is working!"
else
    echo "greenlight is unreachable! Clean up some spaces and restarting..."
    "$BBB_CLEAN_A"
    "$BBB_CLEAN_B"
    docker-compose -f /home/ubuntu/greenlight/docker-compose.yml down
    docker-compose -f /home/ubuntu/greenlight/docker-compose.yml up -d
fi

# to install the file, copy it to another folder and make it executable 'sudo chmod +x /path/to/greenlight_watchdog.sh'
# set a cron job to execute it every 5 min: 'sudo crontab -e' 
# add this line:
# */5 * * * * /home/ubuntu/greenlight_watchdog.sh >> /var/log/greenlight.log 2>&1