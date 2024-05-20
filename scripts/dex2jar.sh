#!/bin/bash

V_DEX2JAR_URL=https://github.com/pxb1988/dex2jar/releases/download/v2.4/dex-tools-v2.4.zip
mkdir -p /usr/local/src/dex2jar \
    && wget -O /usr/local/src/dex2jar/dex2jar.zip ${V_DEX2JAR_URL} \
    && cd /usr/local/src/dex2jar \
    && unzip dex2jar.zip \
    && rm dex2jar.zip \
    && ln -s /usr/local/src/dex2jar/**/d2j-dex2jar.sh /usr/local/bin/dex2jar \
    && ln -s /usr/local/src/dex2jar/**/d2j-jar2dex.sh /usr/local/bin/jar2dex
