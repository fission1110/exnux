mkdir -p /usr/local/src/john \
    && git clone -b "${V_JOHN_BRANCH}" --recurse-submodules --depth 1 https://github.com/openwall/john.git /usr/local/src/john \
    && cd /usr/local/src/john/src \
    && ./configure \
    && make -s clean \
    && make DJOHN_SYSTEMWIDE=1 -sj$(nproc) \
    && chown -R $USERNAME:$USERNAME /usr/local/src/john
