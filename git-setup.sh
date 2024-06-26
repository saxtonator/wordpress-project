#!/bin/bash
sudo apt -y install git
sudo git clone https://github.com/saxtonator/wordpress-project.git wordpress-project
sudo chmod -R 755 wordpress-project
sudo bash wordpress-project/lemp-setup.sh
