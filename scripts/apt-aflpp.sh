apt-get update -y \
    && apt-get install -y \
      `# afl++` \
        bison \
        clang-11 \
        flex \
        g++-10 \
        gcc-10 \
        gcc-10-plugin-dev \
        libpixman-1-dev \
        libstdc++-10-dev \
        llvm-11 \
        llvm-11-dev \
        llvm-11-tools \
        autoconf \
        automake \
        pkg-config \
        `# nyx tools` \
        cargo \
        libgtk-3-dev \
        pax-utils \
        python3-msgpack \
        python3-jinja2 \
        libgtk-3-dev
