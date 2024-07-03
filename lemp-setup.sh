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
sudo mv /var/www/html/index.html /var/www/html/index.html.old # rename apache testing page
sudo mv /root/wordpress-project/nginx.conf /etc/nginx/conf.d/nginx.conf
dns_record=$(curl -s icanhazip.com | sed 's/^/ec2-/; s/\./-/g; s/$/.compute-1.amazonaws.com/')
sed -i "s/SERVERNAME/$dns_record/g" /etc/nginx/conf.d/nginx.conf
sudo bash /root/wordpress-project/wordpress-install.sh
