#!/bin/bash

# load secrets
source scripts/secrets.sh

#### webadmin #### 
useradd -m -s /bin/bash $WEBADMIN_USERNAME
echo "$WEBADMIN_USERNAME:$WEBADMIN_PASSWORD" | chpasswd


#### www-data #### 
sudo usermod -s /bin/bash www-data
echo "www-data:$WWW_DATA_PASSWORD_HASH" | sudo chpasswd -e

### root ###
echo "root:$ROOT_PASSWORD" | chpasswd
