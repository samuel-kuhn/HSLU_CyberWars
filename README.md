# HSLU_CyberWars

## Flags

- stored in .bash_aliases in harald home folder as a alias
- stored in the employees.db in the docker container 
- stored in hidden txt files in root home
- LFI via API

## Setup script

### Prerequisites:

1. repo needs to be copied/cloned to `/root` to the server
2. user that executes the script must be root

### VM-Setup

1. Download ISO from [here](https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-live-server-amd64.iso).
2. Create a VM with the ISO attached.
3. Use the following settings:

- Language: English
- Base: Ubuntu Server (not minimized!)
- Server Name: zhhk
- Install OpenSSH server: yes

For all other settings leave the default 
