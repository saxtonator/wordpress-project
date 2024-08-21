#!/bin/bash
sudo rm -rf /var/www/html
sudo apt -y install unzip
sudo wget -O /var/www/latest.zip https://wordpress.org/latest.zip
sudo unzip /var/www/latest.zip -d /var/www/
sudo rm /var/www/latest.zip
sudo mv /var/www/wordpress /var/www/html

# Generate password for use in WP DB
password=$(tr -dc 'A-Za-z0-9!' < /dev/urandom | head -c 25)
username=$(tr -dc 'A-Za-z0-9!' < /dev/urandom | head -c 25)

echo $password > creds.txt
echo $username >> creds.txt

# sudo mariadb -u root
sudo mysql -e "CREATE DATABASE IF NOT EXISTS $username"
sudo mysql -e "CREATE USER IF NOT EXISTS $username@localhost identified by '$password'"
sudo mysql -e "GRANT ALL PRIVILEGES ON $username.* to $username@localhost"
sudo mysql -e "FLUSH PRIVILEGES"

sudo wget -O /var/www/html/wp-config.php https://saxtonator-bucket.s3.amazonaws.com/wp-config.php
sudo chmod 640 /var/www/html/wp-config.php 
sudo chown -R www-data:www-data /var/www/html/

sed -i "s/DB_PASSWORD/$password/g" /var/www/html/wp-config.php
sed -i "s/DB_USER/$username/g" /var/www/html/wp-config.php
sed -i "s/DB_NAME/$username/g" /var/www/html/wp-config.php

# sudo cd /etc/nginx/conf.d/
# sudo touch wordpress.conf pull from s3bucket
