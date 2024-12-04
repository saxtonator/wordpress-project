#!/bin/bash
apt -y update && apt -y upgrade
apt install mariadb-server mariadb-client -y
sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb
