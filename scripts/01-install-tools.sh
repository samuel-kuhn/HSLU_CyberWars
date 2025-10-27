#!/bin/bash

echo "Installing tools and dependencies..."

#### General Tools #### 
apt-get update > /dev/null
apt-get install -y ca-certificates curl nginx gunicorn python3-flask zip unzip sqlite3 > /dev/null


#### Docker #### 
# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update > /dev/null
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin > /dev/null
