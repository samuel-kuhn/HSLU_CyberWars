#!/bin/bash

### Website (Phase 1) ###

mv website/zhhk /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/zhhk /etc/nginx/sites-enabled/
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default

cp -r website/. website/* /var/www/html
rm /var/www/html/README.md

chown -R www-data:www-data /var/www/html/

systemctl restart nginx

tee /etc/systemd/system/api_jubil.service >/dev/null <<'UNIT'
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
systemctl daemon-reload

# 3) Enable and start
systemctl enable --now api_jubil

# hint for second challenge
echo "- create backups like we did for the Management API" > /var/www/todos.txt
chown www-data:www-data /var/www/todos.txt