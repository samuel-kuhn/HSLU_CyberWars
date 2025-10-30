#!/bin/bash
mv Song/notizen.txt /home/haraldl/notizen.txt
mv Song/zhhk.mp3 /home/haraldl/zhhk.mp3

chown -R haraldl:haraldl /home/haraldl/notizen.txt
chown -R haraldl:haraldl /home/haraldl/zhhk.mp3
chmod 770 /home/haraldl/notizen.txt
chmod 770 /home/haraldl/zhhk.mp3
