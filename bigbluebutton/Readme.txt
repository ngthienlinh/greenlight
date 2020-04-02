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

--add this to the end
###########################################################
location = / {
  return 307 /b;
}
###########################################################
service nginx reload

*Customize BBB
- Copy index.html to /var/www/bigbluebutton-default/index.html
- Copy favicon.ico to /var/www/bigbluebutton-default/images/favicon.ico and /var/www/bigbluebutton/client/favicon.ico
- Copy default.pdf to /var/www/bigbluebutton-default/default.pdf
- Change default welcome message in /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
- Edit /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
- Edit /var/bigbluebutton/playback/presentation/2.0/playback.js
- Copy logo.png to /var/bigbluebutton/playback/presentation/2.0/logo.png

*Disable webcam sharing by default:
- Add this script /etc/bigbluebutton/bbb-conf/apply-config.sh
###########################################################
#!/bin/bash
# Pull in the helper functions for configuring BigBlueButton
source /etc/bigbluebutton/bbb-conf/apply-lib.sh

echo "  - Prevent viewers from sharing webcams"
sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
###########################################################

*After all do: 
bbb-conf --restart

*Create admin account
docker exec greenlight-v2 bundle exec rake user:create["admin","admin@perfectice.com","welcom3","admin"]