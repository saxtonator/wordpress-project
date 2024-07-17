#!/bin/bash

# Log file path
LOG_FILE="/var/log/script_execution.log"

# Function to check the exit status of the last executed command
check_exit_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed." | tee -a $LOG_FILE
        exit 1
    else
        echo "$1 succeeded." | tee -a $LOG_FILE
    fi
}

# Clear the log file at the beginning of the script
> $LOG_FILE

# Update package lists
echo "Running apt update..." | tee -a $LOG_FILE
sudo apt -y update
check_exit_status "apt update"

# Upgrade installed packages
echo "Running apt upgrade..." | tee -a $LOG_FILE
sudo apt -y upgrade
check_exit_status "apt upgrade"

# Clone the GitHub repository
echo "Cloning GitHub repository..." | tee -a $LOG_FILE
sudo git clone https://github.com/saxtonator/wordpress-project.git /root/wordpress-project
check_exit_status "git clone"

# Change permissions of the cloned repository
echo "Changing permissions of the cloned repository..." | tee -a $LOG_FILE
sudo chmod -R 755 /root/wordpress-project
check_exit_status "chmod"

# Run the setup script
echo "Running lemp-setup.sh script..." | tee -a $LOG_FILE
sudo bash /root/wordpress-project/lemp-setup.sh
check_exit_status "lemp-setup.sh script"
