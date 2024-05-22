#!/bin/bash
V_LUA_LS_URL=https://github.com/LuaLS/lua-language-server/releases/download/3.9.1/lua-language-server-3.9.1-linux-x64.tar.gz
mkdir /usr/local/src/lua-language-server \
    && wget -O /usr/local/src/lua-language-server.tar.gz "${V_LUA_LS_URL}" \
    && tar -I pigz -C /usr/local/src/lua-language-server -xf /usr/local/src/lua-language-server.tar.gz \
    && sudo chown -R $USERNAME:$USERNAME /usr/local/src/lua-language-server \
    && ln -s /usr/local/src/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server \
    && rm /usr/local/src/lua-language-server.tar.gz
