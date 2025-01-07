#!/bin/bash
apt -y update && apt -y upgrade
apt install mariadb-server mariadb-client -y
sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb

# Generate password for use in WP DB
password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 25)
username=$(tr -dc 'A-Za-z' < /dev/urandom | head -c 25)

echo $password > creds.txt
echo $username >> creds.txt

# sudo mariadb -u root
sudo mysql -e "CREATE DATABASE IF NOT EXISTS $username"
sudo mysql -e "CREATE USER IF NOT EXISTS $username@localhost identified by '$password'"
sudo mysql -e "GRANT ALL PRIVILEGES ON $username.* to $username@localhost"
sudo mysql -e "FLUSH PRIVILEGES"
