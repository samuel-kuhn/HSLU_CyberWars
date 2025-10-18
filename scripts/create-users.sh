#!/bin/bash

USERNAME="harald"
PASSWORD="TODO updatethispassword"

# creating user
useradd -m $USERNAME

#changing password
echo "$USERNAME:$PASSWORD" | chpasswd

# copying docker files to home folder
cp -r "backend-api/Management API/Docker Compose" /home/$USERNAME/backend-api
chown -R $USERNAME:$USERNAME /home/$USERNAME/backend-api
echo "$PASSWORD" > /home/$USERNAME/backend-api/auth_password.txt

cd "backend-api/Management API/Docker"
zip -r --password " pussycatdolls" /home/$USERNAME/source.zip ./*
cd - > /dev/null 
chown $USERNAME:$USERNAME /home/$USERNAME/source.zip
