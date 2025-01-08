#!/bin/bash

# Update the package lists for upgrades and install the latest available versions
apt -y update && apt -y upgrade

# Install MariaDB server and client packages without user interaction
apt install mariadb-server mariadb-client -y

# Modify the MariaDB configuration file to allow connections from any IP address
# This changes the bind-address setting to 0.0.0.0 (listen on all interfaces)
sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Restart the MariaDB service to apply the configuration changes
systemctl restart mariadb

# Generate a random password and username for the WordPress database
# 'tr -dc' removes unwanted characters, and 'head -c 25' limits output to 25 characters
password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 25)
username=$(tr -dc 'A-Za-z' < /dev/urandom | head -c 25)

# Save the generated credentials to a file for later use
# 'creds.txt' will contain the password and username on separate lines
echo $password > creds.txt
echo $username >> creds.txt

# Create a new database for WordPress
sudo mysql -e "CREATE DATABASE IF NOT EXISTS $username"

# Create a new MariaDB user with the generated username and password
sudo mysql -e "CREATE USER IF NOT EXISTS '$username'@'localhost' IDENTIFIED BY '$password'"

# Grant the new user full privileges on their database
sudo mysql -e "GRANT ALL PRIVILEGES ON $username.* TO '$username'@'localhost'"

# Refresh MariaDB privileges to apply changes immediately
sudo mysql -e "FLUSH PRIVILEGES"
