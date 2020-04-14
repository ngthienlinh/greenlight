*Install BBB

wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | sudo bash -s -- -v xenial-220 -s <domain> -e <email>

*Install docker

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

*Install docker-compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

*Pull greenlight

git clone https://github.com/ngthienlinh/greenlight.git
cd greenlight
git checkout perfectice-bbb
cp sample.env .env
docker run --rm bigbluebutton/greenlight:v2 bundle exec rake secret
bbb-conf --secret
vi .env

cat ./greenlight.nginx | sudo tee /etc/bigbluebutton/nginx/greenlight.nginx
service nginx restart

./update-greenlight.sh

vi /etc/nginx/sites-available/bigbluebutton

--add this to top and comment out 'listen 80' of old server block
###########################################################
server {
     listen 80;
     listen [::]:80;
     server_name <domain>;
     return 301 https://<domain>$request_uri;
}
###########################################################

--add this to the end of server block
###########################################################
location = / {
  return 307 /b;
}
###########################################################
service nginx reload

*Customize BBB
- navigate to greenlight/bigbluebutton
cp index.html /var/www/bigbluebutton-default/
cp favicon.ico /var/www/bigbluebutton-default/images/ 
cp favicon.ico /var/www/bigbluebutton/client/
cp default.pdf /var/www/bigbluebutton-default/
cp logo.png /var/bigbluebutton/playback/presentation/2.0/
- Change default welcome message in /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
vi /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
- Edit settings.yml and change bigbluebutton to whiteboard
vi /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
- Edit playback.js and change bigbluebutton to whiteboard
vi /var/bigbluebutton/playback/presentation/2.0/playback.js


*Disable webcam sharing by default:
- Add this script /etc/bigbluebutton/bbb-conf/apply-config.sh
###########################################################
#!/bin/bash
# Pull in the helper functions for configuring BigBlueButton
source /etc/bigbluebutton/bbb-conf/apply-lib.sh

echo "  - Prevent viewers from sharing webcams"
sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
###########################################################
chmod +x /etc/bigbluebutton/bbb-conf/apply-config.sh

*After all do: 
bbb-conf --restart

*Create admin account
docker exec greenlight-v2 bundle exec rake user:create["admin","admin@perfectice.com","welcom3","admin"]

*login to admin, customize logo with this one:
https://app.myperfectice.com/assets/images/logo1.png

*Edit /opt/freeswitch/conf/autoload_configs/conference.conf.xml
*Reduce energy-level if there is many sound cracking problem
