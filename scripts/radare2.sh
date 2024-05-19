#!/bin/bash
V_RADARE2_URL=https://github.com/radareorg/radare2/releases/download/5.7.8/radare2_5.7.8_amd64.deb
V_RADARE2_DEV_URL=https://github.com/radareorg/radare2/releases/download/5.7.8/radare2-dev_5.7.8_amd64.deb
mkdir -p /usr/local/src/radare2 \
    && wget -O /usr/local/src/radare2/radare2.deb "${V_RADARE2_URL}" \
    && wget -O /usr/local/src/radare2/radare2-dev.deb "${V_RADARE2_DEV_URL}" \
    && dpkg -i /usr/local/src/radare2/radare2.deb \
    && dpkg -i /usr/local/src/radare2/radare2-dev.deb \
    && rm -rf /usr/local/src/radare2 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 20 \
    && sudo -E -u $USERNAME "HOME=/home/$USERNAME" r2pm init \
    && sudo -E -u $USERNAME "HOME=/home/$USERNAME" r2pm update
`#    && r2pm -gi r2dec` \
    #&& sudo -E -u $USERNAME "HOME=/home/$USERNAME" r2pm -i r2ghidra
    #&& sudo -E -u $USERNAME "HOME=/home/$USERNAME" r2pm -i r2frida
