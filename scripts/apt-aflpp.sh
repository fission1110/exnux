#!/bin/bash
apt-get update -y \
    && apt-get install -y \
      `# afl++` \
        bison \
        clang-18 \
        flex \
        g++ \
        gcc \
        gcc-14-plugin-dev \
        libpixman-1-dev \
        libstdc++-14-dev \
        llvm-18 \
        llvm-18-dev \
        llvm-18-tools \
        autoconf \
        automake \
        pkg-config \
        `# nyx tools` \
        libgtk-3-dev \
        pax-utils \
        python3-msgpack \
        python3-jinja2 \
        libgtk-3-dev
