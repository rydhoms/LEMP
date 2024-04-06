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
#
# From Official Nginx Repo for Ubuntu
# Site: https://nginx.org/en/linux_packages.html#Ubuntu

# Install the prerequisites:
sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring -y

# Import an official nginx signing key so apt could verify the packages authenticity. Fetch the key:
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# Verify that the downloaded file contains the proper key:
gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg

# The output should contain the full fingerprint 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 as follows:
# pub   rsa2048 2011-08-19 [SC] [expires: 2024-06-14]
#       573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
# uid                      nginx signing key <signing-key@nginx.com>
# If the fingerprint is different, remove the file.

# To set up the apt repository for stable nginx packages, run the following command:
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

# If you would like to use mainline nginx packages, run the following command instead:
# echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
# http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
#    | sudo tee /etc/apt/sources.list.d/nginx.list

# Set up repository pinning to prefer our packages over distribution-provided ones:
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx

# To install nginx, run the following commands:
sudo apt update
sudo apt install nginx
