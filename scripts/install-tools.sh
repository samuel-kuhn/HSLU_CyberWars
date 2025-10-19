#!/bin/bash

#### Docker #### 

# Add Docker's official GPG key:
apt-get update
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

### Website (Phase 1) ###
apt-get update
apt-get install nginx gunicorn python3-flask -y

sudo mv website/zhhk /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/zhhk /etc/nginx/sites-enabled/
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default

sudo cp -r website/* /var/www/html
sudo rm /var/www/html/README.md

sudo systemctl restart nginx

sudo tee /etc/systemd/system/api_jubil.service >/dev/null <<'UNIT'
[Unit]
Description=api_jubil.service - Gunicorn service for Zur Hupenden Heckklappe API
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/var/www/html
ExecStart=/usr/bin/gunicorn --workers 3 --bind 127.0.0.1:8089 api_jubil:app
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
UNIT

# 2) Reload systemd
sudo systemctl daemon-reload

# 3) Enable and start
sudo systemctl enable --now api_jubil
 ### Phase 1 complete ###

#### Other tools ####

apt install zip unzip -y
