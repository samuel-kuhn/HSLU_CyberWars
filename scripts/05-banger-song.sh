#!/bin/bash
mv Song/notizen.txt /home/haraldl/notizen.txt
mv Song/zhhk.mp3 /home/haraldl/zhhk.mp3

chown -R haraldl:haraldl /home/haraldl/notizen.txt
chown -R haraldl:haraldl /home/haraldl/zhhk.mp3
chmod 770 /home/haraldl/notizen.txt
chmod 770 /home/haraldl/zhhk.mp3

touch /root/.flag.txt
echo "flag{D4s_si3ht_ab3r_g4r_n1cht_guT_au$}" > /root/.flag.txt
