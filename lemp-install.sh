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
elif [[ -e /etc/debian_version ]]; then
	os="debian"
	os_version=$(grep -oE '[0-9]+' /etc/debian_version | head -1)
	group_name="nogroup"
elif [[ -e /etc/almalinux-release ]]; then
	os="almalinux"
	os_version=$(grep -shoE '[0-9]+' /etc/almalinux-release | head -1)
	group_name="nobody"
elif [[ -e /etc/rocky-release ]]; then
	os="rocky-linux"
	os_version=$(grep -shoE '[0-9]+' /etc/rocky-release | head -1)
	group_name="nobody"
else
	echo "This installer seems to be running on an unsupported OS distribution.
Supported OS distros are Ubuntu, Debian, AlmaLinux, and Rocky Linux."
	exit
fi

# Detect Supported OS Version
if [[ "$os" == "ubuntu" && "$os_version" -lt 1804 ]]; then
	echo "Ubuntu 18.04 or higher is required to use this installer.
This version of Ubuntu is too old and unsupported."
	exit
fi

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

if [[ "$os" == "almalinux" && "$os_version" -lt 8 ]]; then
	echo "AlmaLinux 8 or higher is required to use this installer.
This version of Almalinux is too old and unsupported."
	exit
fi

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

# Install LEMP Stack

if [[ "$os" = "debian" ]]; then
		apt-get update
		apt-get install software-properties-common wget curl nano -y
		wget https://raw.githubusercontent.com/rydhoms/LEMP/main/src/debian-lemp.sh -O debian-lemp.sh && bash debian-lemp.sh
	elif [[ "$os" = "ubuntu" ]]; then
		apt-get update
		apt-get install software-properties-common wget curl nano -y
		wget https://raw.githubusercontent.com/rydhoms/LEMP/main/src/ubuntu-lemp.sh -O ubuntu-lemp.sh && bash ubuntu-lemp.sh
	elif [[ "$os" = "almalinux" ]]; then
		yum update
		yum install wget curl nano -y
		wget https://raw.githubusercontent.com/rydhoms/LEMP/main/src/almalinux-lemp.sh -O almalinux-lemp.sh && bash almalinux-lemp.sh
	else
		# Else, OS must be Rocky Linux
		yum update
		yum install wget curl nano -y
		wget https://raw.githubusercontent.com/rydhoms/LEMP/main/src/rocky-linux-lemp.sh -O rocky-linux-lemp.sh && bash rocky-linux-lemp.sh
fi
