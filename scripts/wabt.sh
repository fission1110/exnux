#!/bin/bash

V_WABT_URL=https://github.com/WebAssembly/wabt/releases/download/1.0.35/wabt-1.0.35-ubuntu-20.04.tar.gz
mkdir -p /usr/local/src/wabt \
    && wget -O /usr/local/src/wabt/wabt.tar.gz ${V_WABT_URL} \
    && tar -xzf /usr/local/src/wabt/wabt.tar.gz -C /usr/local/src/wabt \
    && cp -rf /usr/local/src/wabt/wabt-*/* /usr/local/ \
    && rm -rf /usr/local/src/wabt

