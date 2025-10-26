#!/bin/bash

# load secrets
source scripts/secrets.sh

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

#### Docker Steps #### 
docker build -t backend-api "backend-api/Management API/Docker/"
docker compose -f /home/harald/backend-api/docker-compose.yml up -d

# add flag to sqlite in docker container
docker exec -it Management_API sh -c "sqlite3 /usr/src/api/data/employees.db \"CREATE TABLE IF NOT EXISTS flags (ctf_flag TEXT);\""
docker exec -it Management_API sh -c "sqlite3 /usr/src/api/data/employees.db \"INSERT INTO flags (ctf_flag) VALUES ('flag{n3v3r_f0rg3t_t0_ch3ck_all_tabl3s}');\""
