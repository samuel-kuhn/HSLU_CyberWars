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

## Nutzung

Die Website sollte nach dem Neustart von Nginx unter der entsprechenden unter http://localhost erreichbar sein.

## Dokumentation

- To be continued
