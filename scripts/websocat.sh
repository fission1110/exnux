#!/bin/bash
V_WEBSOCAT_URL=https://github.com/vi/websocat/releases/download/v1.11.0/websocat.x86_64-unknown-linux-musl
wget -O /usr/local/bin/websocat "${V_WEBSOCAT_URL}" \
    && chmod +x /usr/local/bin/websocat
