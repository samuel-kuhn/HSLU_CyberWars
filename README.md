# HSLU_CyberWars

<details> 
<summary>  Flags </summary>

1. kann über LFI in der Python API gefunden werden
2. gespeichert in der `employees.db` Datei im Docker Container
3. gespeichert in `.bash_aliases` als Bash Alias `flag` im Home Ordner vom Webadmin
4. gespeichert in der `.flag.txt` Datei im `root` Ordner
</details>


## Installation

### VM
Für das CTF sollte eine Ubuntu VM vorbereitet werden.
Die ISO-Datei kann hier heruntergeladen werden:
https://releases.ubuntu.com/24.04.2/ubuntu-24.04.2-live-server-amd64.iso 

Bei der Installation sollten folgende Einstellungen gesetzt werden:

- Language: English
- Base: Ubuntu Server (not minimized!)
- Install OpenSSH server: yes

### Setup Skript
Sobald das OS installiert ist, kann das Repo heruntergeladen werden. Die ZIP Datei muss zunächst mit einem Python File Server oder SFTP auf die VM kopiert werden in den /root Ordner.
Die Datei kann mit `apt install unzip && unzip HSLU_CyberWars.zip` entpackt werden. Dann muss nur noch das Skript `setup_script.sh` gestartet werden.
Das Skript muss unbedingt als `root` Benutzer ausgeführt werden!
Es nimmt dann alle nötigen Installationen / Konfigurationen vor, sodass die CTF Challenge bereit ist. Sobald alles fertig installiert/konfiguriert ist, fährt die VM herunter.

Danach ist die VM für das CTF bereit.

