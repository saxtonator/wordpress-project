#!/bin/bash
sudo touch /root/testing.txt # this file will contain the output of our LEMP stack unit tests
sudo apt -y install nginx
sudo systemctl start nginx && sudo systemctl enable nginx # this starts and enables nginx on a server reboot. The 2nd command will only run if the first command is successful
sudo systemctl status nginx > /root/testing.txt
sudo apt -y install mariadb-server
sudo systemctl start mariadb && sudo systemctl enable mariadb
systemctl status mariadb >> /root/testing.txt
sudo apt -y install php php-cli php-common php-imap php-fpm php-snmp php-xml php-zip php-mbstring php-curl php-mysqli php-gd php-intl
sudo php -v >> /root/testing.txt
sudo systemctl stop apache2 # stops apache because we're aleady using nginx
sudo systemctl disable apache2 # disables apache from starting on a server reboot
# command to fully remove apache2
# sudo apt remove --purge apache2
sudo mv /var/www/html/index.html /var/www/html/index.html.old # rename apache testing page
sudo mv /root/wordpress-project/nginx.conf /etc/nginx/conf.d/nginx.conf

# dns_record=$(curl -s icanhazip.com | sed 's/^/ec2-/; s/\./-/g; s/$/.compute-1.amazonaws.com/')
my_domain=wordpress.danhavercroft.co.uk
elastic_ip=$(curl -s icanhazip.com)

CF_API=
CF_ZONE_ID=

curl --request POST \
  --url https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $CF_API" \
  --data '{
  "content": "'"$elastic_ip"'",
  "name": "'"$my_domain"'",
  "proxied": true,
  "type": "A",
  "comment": "Automatically adding A record",
  "tags": [],
  "ttl": 3600
}'

sed -i "s/SERVERNAME/$my_domain/g" /etc/nginx/conf.d/nginx.conf
nginx -t && systemctl reload nginx # this will only reload nginx if the test is successful
# sudo bash /root/wordpress-project/certbot-ssl-install.sh
