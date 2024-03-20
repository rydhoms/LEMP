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
if [[ -e /etc/rocky-release ]]; then
	os="rocky-linux"
	os_version=$(grep -shoE '[0-9]+' /etc/rocky-release | head -1)
	group_name="nobody"
else
	echo "This LEMP STACK installer only for Rocky Linux. 
	Use \"wget -qO- lemp.my.id | bash\" to install on other Supported OS:
	Debian 10+, Ubuntu 18+, Almalinux 9+, and Rocky Linux 9+"
	exit
fi

# Detect Supported OS Version
if [[ "$os" == "rocky-linux" && "$os_version" -lt 8 ]]; then
	echo "Rocky Linux or higher is required to use this installer.
This version of Rocky Linux is too old and unsupported."
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

echo "Almalinux Installer in Progress ..."
