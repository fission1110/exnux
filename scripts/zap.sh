#!/bin/bash
V_ZAP_URL=https://github.com/zaproxy/zaproxy/releases/download/v2.15.0/ZAP_2.15.0_Linux.tar.gz
mkdir -p /usr/local/src/zap \
    && wget -O /usr/local/src/zap/zap.tar.gz "${V_ZAP_URL}" \
    && cd /usr/local/src/zap \
    && tar -I pigz -xf ./zap.tar.gz \
    && ln -s /usr/local/src/zap/**/zap.sh /usr/local/bin/zap \
    && rm ./zap.tar.gz
