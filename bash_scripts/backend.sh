#!/bin/bash
# This script installs and configures MariaDB, sets up a database, and generates credentials.
# This is the backend DB instance for your frontend WordPress site. I'd recommend deploying on an ARM Ubuntu 24.04 instance to maximize cost saving and performance.
# You'll need to create an S3 bucket on AWS to securely store your creds.txt file, i.e., s3://your-bucket-name/

# Update the package lists for upgrades and install the latest available versions
apt -y update && apt -y upgrade

# Install the AWS CLI tool using Snap for managing AWS resources
snap install aws-cli --classic

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

# Uncomment to use your password and username using Github secrets. Replace DBPASSWORD and DBUSERNAME with your secret.
# password=DBPASSWORD
# username=DBUSERNAME

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

# Add the password and username to the wp-config.php file
sed -i "s/password_here/$password/g" /var/www/html/wp-config.php
sed -i "s/username_here/$username/g" /var/www/html/wp-config.php
sed -i "s/database_name_here/$username/g" /var/www/html/wp-config.php

# Upload the creds.txt file to the specified S3 bucket
# This securely stores the credentials file in AWS S3 for later use or backup
aws s3 cp /root/creds.txt s3://saxtonator

# Backup of my DB and stored on S3 for backup and security
mysqldump -u root -p --all-databases > /root/alldb.sql
aws s3 cp /root/alldb.sql s3://saxtonator

# Instructions to Create an IAM Role for EC2:
# ===========================================

# 1. Go to the IAM Service in the AWS Management Console.
# 2. Create Role:
#    - Click on "Create role."
# 3. Select EC2 as the Trusted Entity:
#    - Under "Select trusted entity," choose "AWS Service."
#    - Under "Use case," select "EC2."
#    - Click "Next."
# 4. Attach Policies:
#    - Select a predefined policy like "AmazonS3FullAccess" for S3 access 
#      or create a custom policy with the permissions you need.
#    - Click "Next."
# 5. Name the Role:
#    - Provide a name (e.g., "EC2S3AccessRole").
#    - Click "Create role."
# 6. Attach the Role to Your EC2 Instance
#    - After confirming the role is properly created and associated with EC2:
#    - Go to the EC2 Dashboard.
#    - Select your instance and click Actions > Security > Modify IAM Role.
#    - The role should now appear in the dropdown menu.

# Note: The IAM Role can be attached to an EC2 instance for access to AWS services 
# (e.g., S3) without hardcoding credentials into your scripts.
