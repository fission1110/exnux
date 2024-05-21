#!/bin/bash
V_KALI_WORDLIST_URL=https://github.com/3ndG4me/KaliLists/archive/refs/heads/master.tar.gz
V_GOBUSTER_URL=https://github.com/OJ/gobuster/releases/download/v3.6.0/gobuster_Linux_x86_64.tar.gz
mkdir -p /home/$USERNAME/Wordlists/ \
    && chown $USERNAME:$USERNAME /home/$USERNAME/Wordlists \
    && sudo -u $USERNAME wget -O /home/$USERNAME/Wordlists/kali-wordlists.tar.gz "${V_KALI_WORDLIST_URL}" \
    && mkdir -p /usr/local/src/gobuster \
    && cd /usr/local/src/gobuster \
    && wget -O gobuster.tar.gz "${V_GOBUSTER_URL}" \
    && tar -I pigz -xf gobuster.tar.gz \
    && rm gobuster.tar.gz \
    && ln -s /usr/local/src/gobuster/gobuster /usr/local/bin/gobuster


