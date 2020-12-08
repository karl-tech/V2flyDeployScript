#!/usr/bin/env sh

# optimizing system
sudo cp local.conf /etc/sysctl.d/local.conf
sudo sysctl --system
sudo cp setunnel_limits.conf /etc/security/limits.d/v2ray_limits.conf

# install package
export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt -y install debconf-utils
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
sudo apt -y upgrade
sudo apt install -y curl software-properties-common

# create new user for haproxy and v2ray
useradd proxy -s /usr/sbin/nologin

# install haproxy
add-apt-repository -y ppa:vbernat/haproxy-2.0
sudo apt update
sudo apt install -y haproxy=2.0.\*
cp haproxy.cfg /etc/haproxy/haproxy.cfg
mkdir /var/lib/haproxy/v2ray
chown proxy:root /var/lib/haproxy/v2ray

# install v2ray
curl -L -s https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh | bash
cp v2ray.conf /usr/local/etc/v2ray/config.json
chown -R proxy:root /usr/local/etc/v2ray/
mkdir /var/log/v2ray
chown -R proxy:root /var/log/v2ray
cp v2ray.service /etc/systemd/system/v2ray.service
cp v2ray.service /etc/systemd/system/v2ray@.service
systemctl daemon-reload
systemctl start v2ray

# install certbot
add-apt-repository -y universe
apt update
apt install -y certbot
# generate certbot and copy certs
sh certbot-cert.sh
# cp hook script to certbot
cp certbot-v2ray-renew-hook.sh /etc/letsencrypt/renewal-hooks/post/certbot-v2ray-renew-hook.sh
chmod 755 /etc/letsencrypt/renewal-hooks/post/certbot-v2ray-renew-hook.sh

# setup ufw
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable




