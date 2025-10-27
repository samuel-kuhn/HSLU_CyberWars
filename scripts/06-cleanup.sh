#!/bin/bash

# cleaning up root folder
find /root -mindepth 1 \
  ! -name '.bashrc' \
  ! -name '.profile' \
  -delete

# removing default user
DEFAULT_USER=$(id -nu 1000 2>/dev/null)

echo "Removing user: $USER_TO_DELETE"

deluser --remove-home "$USER_TO_DELETE"
delgroup "$USER_TO_DELETE"

# power off
poweroff