Customize BBB
- Copy index.html to /var/www/bigbluebutton-default/index.html
- Copy favicon.ico to /var/www/bigbluebutton-default/images/favicon.ico and /var/www/bigbluebutton/client/favicon.ico
- Copy default.pdf to /var/www/bigbluebutton-default/default.pdf
- Change default welcome message in /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
- Edit /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
- Edit /var/bigbluebutton/playback/presentation/2.0/playback.js
- Copy logo.png to /var/bigbluebutton/playback/presentation/2.0/logo.png

Disable webcam sharing by default:
- Add this script /etc/bigbluebutton/bbb-conf/apply-config.sh
###########################################################
#!/bin/bash
# Pull in the helper functions for configuring BigBlueButton
source /etc/bigbluebutton/bbb-conf/apply-lib.sh

echo "  - Prevent viewers from sharing webcams"
sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
###########################################################

After all do: bbb-conf --restart