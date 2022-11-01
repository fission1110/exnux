#!/bin/bash

sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" cargo install exa bat procs tokei \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" cargo cache -a

# btop++
mkdir -p /usr/local/src/btop
wget -O /usr/local/src/btop/btop-musl.tbz https://github.com/aristocratos/btop/releases/download/v1.2.12/btop-x86_64-linux-musl.tbz
tar -xvf /usr/local/src/btop/btop-musl.tbz -C /usr/local/src/btop
rm /usr/local/src/btop/btop-musl.tbz
cd /usr/local/src/btop
/usr/local/src/btop/install.sh
