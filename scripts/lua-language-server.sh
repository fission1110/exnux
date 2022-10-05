mkdir /usr/local/src/lua-language-server \
    && wget -O /usr/local/src/lua-language-server.tar.gz "${V_LUA_LANGUAGE_SERVER_URL}" \
    && tar -I pigz -xvf /usr/local/src/lua-language-server.tar.gz -C /usr/local/src/lua-language-server \
    && ln -s /usr/local/src/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server \
    && chown -R $USERNAME:$USERNAME /usr/local/src/lua-language-server \
    && rm /usr/local/src/lua-language-server.tar.gz
