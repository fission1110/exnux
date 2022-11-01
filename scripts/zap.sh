#!/bin/bash
V_ZAP_URL=https://github.com/zaproxy/zaproxy/releases/download/v2.11.1/ZAP_2.11.1_Linux.tar.gz
mkdir -p /usr/local/src/zap \
    && wget -O /usr/local/src/zap/zap.tar.gz "${V_ZAP_URL}" \
    && cd /usr/local/src/zap \
    && tar -I pigz -xf ./zap.tar.gz \
    && ln -s /usr/local/src/zap/ZAP_2.11.1/zap.sh /usr/local/bin/zap \
    && rm ./zap.tar.gz
