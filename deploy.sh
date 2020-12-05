#!/usr/bin/env sh
# Usage: sh server-deplyo.sh domain

domain=$1
echo "domain: $domain"

cp deploy/certbot-cert.sh.tample deploy/certbot-cert.sh
sed -i "s/DOMAIN_NAME/$domain/g" deploy/certbot-cert.sh

cp deploy/certbot-v2ray-renew-hook.sh.tample deploy/certbot-v2ray-renew-hook.sh
sed -i "s/DOMAIN_NAME/$domain/g" deploy/certbot-v2ray-renew-hook.sh

cd deploy
sh setup.sh
