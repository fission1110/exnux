#!/bin/bash
V_LUAROCKS_URL=https://luarocks.org/releases/luarocks-3.9.1.tar.gz
mkdir -p /usr/local/src/luarocks \
    && cd /usr/local/src/luarocks \
    && wget -O /usr/local/src/luarocks/luarocks.tar.gz ${V_LUAROCKS_URL} \
    && tar -xzf luarocks.tar.gz \
    && cd luarocks-* \
    && ./configure \
    && make \
    && make install \
    && luarocks install https://raw.githubusercontent.com/kkharji/sqlite.lua/master/sqlite-master-0.rockspec
