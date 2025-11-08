#!/bin/bash

# setting custom issue file
mv scripts/issue /etc/issue
hostnamectl set-hostname --static zhhk
hostnamectl set-hostname --pretty zhhk
