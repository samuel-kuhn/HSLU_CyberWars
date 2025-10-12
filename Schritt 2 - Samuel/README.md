## Schritt 2 - Management API

## Story
Diese API ist nur intern erreichbar und ist nur für Manager/Mitarbeiter. In der Datenbank hinter der API werden vor allem Mitarbeiter Daten abgespeichert. 

Über die API können Mitarbeiter hinzugefügt, bearbeitet oder gelöscht werden. 

Unter einem Endpoint der noch nicht richtig implementiert ist, kann der Webadmin ein Backup von der Datenbank mit einem bash script ausführen. 

## Backend API Code Backup
Der `www-data` nutzer findet auf dem System ein mit passwort verschlüsseltes zip Archiv. Dieses kann man mit `zip2john` und `john` relativ einfach knacken.  
Darin findet man folgendes:
 - eine flag in einem `.bashrc` file
 - den source code von der Management API
 - ein Postman collection export der API

Im Dockerfile sieht man, dass eine Environment Variable im Container zu finden ist. 


## Exploit
Der Admin Hash ist in der Datenbank ist:

`0e731198061491163073197128363787`

Beim Type Juggling wird dies als mathematischer Ausdruck gewertet und evaluiert zu `0`.

Jeder String der mit `0e` beginnt und danach nur Zahlen hat wird genau gleich gewertet. 

Um die Type Juggling Vulnerability auszunützen können folgende Inputs verwendet werden: 

https://www.programmersought.com/article/20249285296/

Jeder dieser Werte kann genutzt werden, um die Authentication zu umgehen, da sie im Type Juggling zu `0` werden. 
Im Code wird also schlussendlich `0 == 0` ausgewertet und der Input wird als richtiges Passwort behandelt. 

## Links:

[Docker Secret](https://docs.docker.com/compose/how-tos/use-secrets/)

[Docker PHP](https://hub.docker.com/_/php)

[Type Juggling #1](https://haymiz.dev/security/2024/06/13/type-juggling-vulnerability/)

[Type Juggling #2](https://secops.group/php-type-juggling-simplified/)

[PHP v7.4](https://www.centron.de/tutorial/php-7-4-auf-ubuntu-24-04-installieren-und-konfigurieren-eine-umfassende-anleitung/)


