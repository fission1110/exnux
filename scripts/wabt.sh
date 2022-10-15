#!/bin/bash

mkdir -p /usr/local/src/wabt \
    && wget -O /usr/local/src/wabt/wabt.tar.gz ${V_WABT_URL} \
    && tar -xzf /usr/local/src/wabt/wabt.tar.gz -C /usr/local/src/wabt \
    && cp -rf /usr/local/src/wabt/wabt-*/* /usr/local/ \
    && rm -rf /usr/local/src/wabt

