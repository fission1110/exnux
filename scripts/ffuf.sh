#!/bin/bash
V_FFUF_URL=https://github.com/ffuf/ffuf/releases/download/v1.5.0/ffuf_1.5.0_linux_amd64.tar.gz
mkdir -p /usr/local/src/ffuf \
    && wget -O /usr/local/src/ffuf/ffuf.tar.gz "${V_FFUF_URL}" \
    && cd /usr/local/src/ffuf \
    && tar -I 'pigz' -xf ./ffuf.tar.gz \
    && ln -s /usr/local/src/ffuf/ffuf /usr/local/bin/ffuf \
    && rm /usr/local/src/ffuf/ffuf.tar.gz
