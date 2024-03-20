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

# Detect OS
if [[ -e /etc/almalinux-release ]]; then
	os="almalinux"
	os_version=$(grep -shoE '[0-9]+' /etc/almalinux-release | head -1)
	group_name="nobody"
else
	echo "This LEMP STACK installer only for Almalinux. 
	Use \"wget -qO- lemp.my.id | bash\" to install on other Supported OS:
	Debian 10+, Ubuntu 18+, Almalinux 9+, and Rocky Linux 9+"
	exit
fi

# Detect Supported OS Version
if [[ "$os" == "almalinux" && "$os_version" -lt 8 ]]; then
	echo "AlmaLinux 8 or higher is required to use this installer.
This version of Almalinux is too old and unsupported."
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

# firewall for http/https if exist
sudo firewall-cmd --permanent --add-service={http,https}
sudo firewall-cmd --reload

# update system
sudo dnf update -y

# install tools
sudo dnf install wget curl nano -y

# install Nginx
sudo dnf install nginx -y

# enable Nginx to run at boot time and start the Nginx service
sudo systemctl enable nginx
sudo systemctl start nginx

# install MariaDB Server
sudo dnf install mariadb-server -y

# enable MariaDB to run at boot time and start the MariaDB service
sudo systemctl enable mariadb
sudo systemctl start mariadb

# install php-fpm
sudo dnf install php-fpm php-mysqlnd php-gd php-cli php-curl php-mbstring php-bcmath php-zip php-opcache php-xml php-json php-intl -y

# replace php-fpm conf with Nginx support
# user = nginx
# group = nginx
sudo mv /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.bak
sudo wget https://raw.githubusercontent.com/rydhoms/LEMP/main/conf/almalinux/www.conf -O /etc/php-fpm.d/www.conf

# enable php-fpm to run at boot time and start the php-fpm service
sudo systemctl enable php-fpm
sudo systemctl start php-fpm

# write nginx config to conf.d/www
sudo wget https://raw.githubusercontent.com/rydhoms/LEMP/main/conf/almalinux/default.cof -O /etc/nginx/conf.d/default.conf

# remove default server block on nginx.conf
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
sudo wget https://raw.githubusercontent.com/rydhoms/LEMP/main/conf/almalinux/nginx.conf -O /etc/nginx/nginx.conf

# restart nginx
service nginx restart

# write php info
wget https://raw.githubusercontent.com/rydhoms/LEMP/main/conf/almalinux/info.php -O /usr/share/nginx/html/info.php

echo "Installation completed"
echo "You can access your web on your IP or domain pointing to your IP"
echo "you access php info on http://your-domain.com/info.php"
echo "after installation complete, you need to configure mariadb with this command:"
echo "mysql_secure_installation"