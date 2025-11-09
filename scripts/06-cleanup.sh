#!/bin/bash

# cleaning up root folder
find /root -mindepth 1 \
  ! -name '.bashrc' \
  ! -name '.flag.txt' \
  ! -name '.profile' \
  -delete

# removing default user
DEFAULT_USER=$(id -nu 1000 2>/dev/null)

echo "Removing user: $DEFAULT_USER"

userdel -r -f "$DEFAULT_USER"
delgroup "$DEFAULT_USER"

# clear bash history
history -c

# power off
poweroff
