#!/bin/bash

# load secrets
source scripts/secrets.sh

# creating webadmin user
useradd -m $WEBADMIN_USERNAME
echo "$WEBADMIN_USERNAME:$WEBADMIN_PASSWORD" | chpasswd

# copying docker files to home folder
cp -r "backend-api/Management API/Docker Compose" /home/$WEBADMIN_USERNAME/backend-api
chown -R $WEBADMIN_USERNAME:$WEBADMIN_USERNAME /home/$WEBADMIN_USERNAME/backend-api
echo "$WEBADMIN_PASSWORD" > /home/$WEBADMIN_USERNAME/backend-api/auth_password.txt

cd "backend-api/Management API/Docker"
zip -r --password $ZIP_PASSWORD /var/backups/source.zip ./*
cd - > /dev/null 
chown $WEBADMIN_USERNAME:$WEBADMIN_USERNAME /var/backups/source.zip

# add flag to .bashrc
echo "alias flag='echo "flag{1t_1s_4lw4ys_w0rth_ch3ck1ng_h1dd3n_f1l3s}"'"> /home/$WEBADMIN_USERNAME/.bash_aliases

# set bash for www-data
sudo usermod -s /bin/bash www-data

echo "www-data:$WWW_DATA_PASSWORD_HASH" | sudo chpasswd -e
