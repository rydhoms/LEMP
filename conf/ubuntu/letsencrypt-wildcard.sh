# Install LetsEncrypt
sudo apt update
sudo apt-get install letsencrypt

# Install Wildcard SSL
sudo certbot certonly --manual --preferred-challenges=dns --email webmaster@domain.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d domain.com -d *.domain.com

# dhparams generate
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
