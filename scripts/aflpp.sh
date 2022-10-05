mkdir -p /usr/local/src/AFLplusplus \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 20 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 20 \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 20 \
    && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 20 \
    && update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-11 20 \
    && git clone -b "${V_AFLPP_BRANCH}" --depth 1 https://github.com/AFLplusplus/AFLplusplus /usr/local/src/AFLplusplus \
    && cd /usr/local/src/AFLplusplus \
    && make distrib \
    && mkdir ../build \
    && make DESTDIR=../build install \
    && rm -rf /usr/local/src/AFLplusplus
