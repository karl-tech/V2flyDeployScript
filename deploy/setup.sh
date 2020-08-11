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
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt -y upgrade
sudo apt install -y curl iptables iptables-persistent xtables-addons-common software-properties-common

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

# config nginx
apt install -y nginx
service nginx stop
rm /etc/nginx/sites-available/*
rm /etc/nginx/sites-enabled/*
cp nginx-v2ray-site.conf /etc/nginx/sites-available/nginx-v2ray-site.conf
ln -s /etc/nginx/sites-available/nginx-v2ray-site.conf /etc/nginx/sites-enabled/nginx-v2ray-site.conf
service nginx start

# setup ufw
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable

# block BT
iptables -A INPUT -m string --string "BitTorrent" --algo bm -j DROP
iptables -A INPUT -m string --string "BitTorrent protocol" --algo bm -j DROP
iptables -A INPUT -m string --string "peer_id=" --algo bm -j DROP
iptables -A INPUT -m string --string ".torrent" --algo bm -j DROP
iptables -A INPUT -m string --string "announce.php?passkey=" --algo bm -j DROP
iptables -A INPUT -m string --string "torrent" --algo bm -j DROP
iptables -A INPUT -m string --string "announce" --algo bm -j DROP
iptables -A INPUT -m string --string "info_hash" --algo bm -j DROP
iptables -A INPUT -m string --string "tracker" --algo bm -j DROP
iptables -A INPUT -m string --string "get_peers" --algo bm -j DROP
iptables -A INPUT -m string --string "announce_peer" --algo bm -j DROP
iptables -A INPUT -m string --string "find_node" --algo bm -j DROP
iptables -A INPUT -m ipp2p --edk --kazaa --gnu --bit --apple --dc --soul --winmx --ares -j DROP
# IPv6
ip6tables -A INPUT -m string --string "BitTorrent" --algo bm -j DROP
ip6tables -A INPUT -m string --string "BitTorrent protocol" --algo bm -j DROP
ip6tables -A INPUT -m string --string "peer_id=" --algo bm -j DROP
ip6tables -A INPUT -m string --string ".torrent" --algo bm -j DROP
ip6tables -A INPUT -m string --string "announce.php?passkey=" --algo bm -j DROP
ip6tables -A INPUT -m string --string "torrent" --algo bm -j DROP
ip6tables -A INPUT -m string --string "announce" --algo bm -j DROP
ip6tables -A INPUT -m string --string "info_hash" --algo bm -j DROP
ip6tables -A INPUT -m string --string "tracker" --algo bm -j DROP
ip6tables -A INPUT -m string --string "get_peers" --algo bm -j DROP
ip6tables -A INPUT -m string --string "announce_peer" --algo bm -j DROP
ip6tables -A INPUT -m string --string "find_node" --algo bm -j DROP

netfilter-persistent save
netfilter-persistent reload

sudo reboot



