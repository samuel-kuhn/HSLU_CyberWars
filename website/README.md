# Website Dokumentation Zur Hupenden Heckklappe

Dieses Repository enthält die Dokumentation und den Quellcode für die Website zur "Hupenden Heckklappe". 

## Installation
1. Git installieren
   ```bash
    apt update && apt install git
    ```
2. Repository klonen:
    ```bash
    git clone https://github.com/samuel-kuhn/HSLU_CyberWars.git
    ```
3. In das Verzeichnis wechseln:
    ```bash
    cd HSLU_CyberWars/website
    ```
4. NGINX installieren (falls noch nicht installiert):
    ```bash
    sudo apt update
    sudo apt install nginx
    ```
    
5. Server konfigurieren (z.B. Nginx):
    - Konfigurationsdatei unter `/etc/nginx/sites-available/zhhk` erstellen.
    - Symbolischen Link in `/etc/nginx/sites-enabled/` setzen.
    - Nginx neu starten:
    ```bash
    sudo ln -s /etc/nginx/sites-available/zhhk /etc/nginx/sites-enabled/
    sudo systemctl restart nginx
    ```

6. Files nach /var/www/html kopieren:
    ```bash
    cp -r * /var/www/html
    ```
7. Flask installieren für API Aufruf
   ```bash
   sudo apt install python3-pip && sudo apt install python3-flask python3-gunicorn gunicorn
   ```
8. Service erstellen für API Jubiläum
   ```bash
   sudo vim /etc/systemd/syystem/api_jubil.service
   ### Content for File:
   "
   [Unit]
   Description=Gunicorn service for Zur Hupenden Heckklappe API
   After=network.target
   
   [Service]
   # Path to your project
   WorkingDirectory=/var/www/html
   # The command to start gunicorn
   ExecStart=/usr/bin/gunicorn --workers 3 --bind 127.0.0.1:8089 api_jubil:app
   
   # User to run under (change if needed)
   User=www-data
   Group=www-data
   
   Restart=always
   RestartSec=5
   KillSignal=SIGQUIT
   TimeoutStopSec=20
   
   [Install]
   WantedBy=multi-user.target
   "
   ```
9. After this the Web-App should be working propperly. 


## Nutzung

Die Website sollte nach dem Neustart von Nginx unter der entsprechenden unter http://10.0.2.15 erreichbar sein.

## Dokumentation

- Es gibt ein Flag unter "/var/www/html/CrYpt1cF1L3t4t15n0T5u5p1c10U5"
- Das Ziel ist es, dass der Benutzer das Passwort von www-data mittels hashcat cracken chan. Danach ist er im Benutzer-Kontext von www-data und geht über zu Phase2. 
