#!/bin/bash
BBB_CLEAN_A="/etc/cron.daily/bigbluebutton"
BBB_CLEAN_B="/etc/cron.daily/bbb-recording-cleanup"
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
