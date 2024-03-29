#!/bin/bash
# Copyright (c) 2024 Ridho Muhammad. Licensed under the MIT License.
#
# This file is part of the LEMP STACK installation script.
#
# LEMP stands for Linux + Nginx + MySQL / MariaDB + PHP.
# With this bash script you can install a web server quickly
# and very easily on your Linux Server, which includes
# Nginx as a web server, MySQL / MariaDB as a database,
# and PHP as a web programming language processing.
#
# Description : Install LEMP Stack (Linux + Nginx + MySQL / MariaDB + PHP)
# Supported OS Distro : Debian 10+, Ubuntu 18+, Almalinux 8+, and Rocky Linux 8+
# Supported Software : Nginx,MariDB, and PHP
# Website : https://lemp.my.id
# Github : https://github.com/rydhoms/LEMP
# Bugs Report : hello@ridho.id or Github Issues https://github.com/rydhoms/LEMP
#
# Version 0.1.0

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
	echo 'This installer needs to be run with "bash", not "sh".'
	exit
fi

# Detect OS
if grep -qs "ubuntu" /etc/os-release; then
	os="ubuntu"
	os_version=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2 | tr -d '.')
	group_name="nogroup"
else
	echo "This LEMP STACK installer only for Ubuntu. 
	Use \"wget -qO- lemp.my.id | bash\" to install on other Supported OS:
	Debian 10+, Ubuntu 18+, Almalinux 9+, and Rocky Linux 9+"
	exit
fi

# Detect Supported OS Version
if [[ "$os" == "ubuntu" && "$os_version" -lt 1804 ]]; then
	echo "Ubuntu 18.04 or higher is required to use this installer.
This version of Ubuntu is too old and unsupported."
	exit
fi

# Detect environments where $PATH does not include the sbin directories
if ! grep -q sbin <<< "$PATH"; then
	echo '$PATH does not include sbin. Try using "su -" instead of "su".'
	exit
fi

if [[ "$EUID" -ne 0 ]]; then
	echo "This installer needs to be run with superuser privileges."
	exit
fi

# update system
apt update

# install sudo
apt install sudo -y

# install tools
apt install software-properties-common wget curl nano -y

# remove apache2 from machine
apt purge apache2* -y

# remove unused files
apt autoremove -y

# add nginx repository
sudo add-apt-repository ppa:ondrej/nginx -y

# update repository
apt update

# install nginx latest version
apt install nginx -y

# add php repository
sudo add-apt-repository ppa:ondrej/php -y

# install php 7.4
apt install php7.4-fpm php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-redis php7.4-soap php7.4-zip php7.4-mailparse php7.4-gmp -y

# install mariadb server
apt install mariadb-server -y

# manual setup mariadb
# sudo mysql_secure_installation

# unlink the default configuration file from the /sites-enabled/ directory
unlink /etc/nginx/sites-enabled/default

# backup default nginx config
mv /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default.bak

# download nginx config
wget https://raw.githubusercontent.com/rydhoms/LEMP/main/conf/ubuntu/default.conf -O /etc/nginx/sites-available/default.conf

# link downloaded nginx config to sites-enabled
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/

# restart nginx
service nginx restart

# restart php-fpm
service php7.4-fpm restart

# restart mariadb
service mariadb restart

# write php info
wget https://raw.githubusercontent.com/rydhoms/LEMP/main/conf/ubuntu/info.php -O /var/www/html/info.php

# Retrieve the IP address
ip_address=$(wget -qO- ifconfig.me/ip)

echo "##################################################################"
echo "| LEMP Stack Successfully Installed								"
echo "|																	"
echo "| Access Website : http://$ip_address/							"
echo "|	  																"
echo "| PHP Info : http://$ip_address/info.php							"
echo "|	  																"
echo "| Public HTML : /var/www/html										"
echo "|			   														"
echo "| Nginx Config : /etc/nginx/sites-available						"
echo "|		 															"
echo " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "|																	"
echo "| Description : Install LEMP Stack (Linux + Nginx + MySQL			"
echo "| / MariaDB + PHP)												"
echo "|				 													"
echo "| Supported OS Distro : Debian 10+, Ubuntu 18+, Almalinux 8+,		"
echo "| and Rocky Linux 8+												"
echo "|																	"
echo "| Supported Software : Nginx,MariDB, and PHP						"
echo "|	 																"
echo "| Website : https://lemp.my.id									"	
echo "|		   															"
echo "| Github : https://github.com/rydhoms/LEMP						"
echo "|	  																"
echo "| Bugs Report : hello@ridho.id or Github Issues					"
echo "| https://github.com/rydhoms/LEMP									"
echo "|		  															"
echo "| Version 0.1.0													"
echo "|		  															"
echo " #################################################################"
echo
echo "after installation complete, you need to configure mariadb with this command:"
echo "mysql_secure_installation"