#!/bin/bash

USERNAME="harald"
PASSWORD="TODO updatethispassword"
WWWDATAPASS="$y$j9T$Bidh099nK4M4Rq2DpXIGf0$DBG82KOer5GGQu8Cx62ybvnCXnn4lm0JAdgzGWoPa25"

# creating user
useradd -m $USERNAME

# changing password
echo "$USERNAME:$PASSWORD" | chpasswd

# copying docker files to home folder
cp -r "backend-api/Management API/Docker Compose" /home/$USERNAME/backend-api
chown -R $USERNAME:$USERNAME /home/$USERNAME/backend-api
echo "$PASSWORD" > /home/$USERNAME/backend-api/auth_password.txt

cd "backend-api/Management API/Docker"
zip -r --password " pussycatdolls" /home/$USERNAME/source.zip ./*
cd - > /dev/null 
chown $USERNAME:$USERNAME /home/$USERNAME/source.zip

# add flag to .bashrc
echo "alias flag='echo "flag{1t_1s_4lw4ys_w0rth_ch3ck1ng_h1dd3n_f1l3s}"'"> /home/$USERNAME/.bash_aliases

# set bash for www-data
sudo usermod -s /bin/bash www-data

sudo usermod --password '$y$j9T$Bidh099nK4M4Rq2DpXIGf0$DBG82KOer5GGQu8Cx62ybvnCXnn4lm0JAdgzGWoPa25' www-data
