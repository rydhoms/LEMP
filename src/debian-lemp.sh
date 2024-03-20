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
if [[ -e /etc/debian_version ]]; then
	os="debian"
	os_version=$(grep -oE '[0-9]+' /etc/debian_version | head -1)
	group_name="nogroup"
else
	echo "This LEMP STACK installer only for Debian. 
	Use \"wget -qO- lemp.my.id | bash\" to install on other Supported OS:
	Debian 10+, Ubuntu 18+, Almalinux 9+, and Rocky Linux 9+"
	exit
fi

# Detect Supported OS Version
if [[ "$os" == "debian" ]]; then
	if grep -q '/sid' /etc/debian_version; then
		echo "Debian Testing and Debian Unstable are unsupported by this installer."
		exit
	fi
	if [[ "$os_version" -lt 10 ]]; then
		echo "Debian 10 or higher is required to use this installer.
This version of Debian is too old and unsupported."
		exit
	fi
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
apt install software-properties-common wget curl nano lsb-release apt-transport-https ca-certificates gnupg gnupg2 gnupg1 -y
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131

# get gpg for ppa nginx and php
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
wget -O /etc/apt/trusted.gpg.d/nginx.gpg https://packages.sury.org/php/nginx.gpg

# remove apache2 from machine
apt purge apache2* -y

# remove unused files
apt autoremove -y

# add nginx and php repository
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
echo "deb https://packages.sury.org/nginx/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nginx.list

# update repository
apt update

# install nginx latest version
apt install nginx -y

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
wget https://raw.githubusercontent.com/rydhoms/LEMP/main/conf/default.conf -O /etc/nginx/sites-available/default.conf

# link downloaded nginx config to sites-enabled
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/

# restart nginx
service nginx restart

# restart php-fpm
service php7.4-fpm restart

# restart mariadb
service mariadb restart

# write php info
wget https://raw.githubusercontent.com/rydhoms/LEMP/main/conf/info.php -O /var/www/html/info.php

echo "Installation completed"
echo "You can access your web on your IP or domain pointing to your IP"
echo "you access php info on http://your-domain.com/info.php"
echo "after installation complete, you need to configure mariadb with this command:"
echo "mysql_secure_installation"
