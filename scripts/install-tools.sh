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
apt-get install nginx -y

sudo mv "${GIT_LOCATION}"/website/zhhk /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/zhhk /etc/nginx/sites-enabled/

sudo cp -r "${GIT_LOCATION}"/website/* /var/www/html
sudo rm /var/www/html/README.md

sudo systemctl restart nginx
 ### Phase 1 complete ###

#### Other tools ####

apt install zip unzip -y
