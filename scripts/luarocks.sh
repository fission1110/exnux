mkdir -p /usr/local/src/luarocks \
    && cd /usr/local/src/luarocks \
    && wget -o /usr/local/src/luarocks/luarocks.tar.gz ${LUAROCKS_URL} \
    && tar -xzf luarocks.tar.gz \
    && cd luarocks-* \
    && ./configure \
    && make \
    && make install \
    && luarocks install https://raw.githubusercontent.com/kkharji/sqlite.lua/master/sqlite-master-0.rockspec
