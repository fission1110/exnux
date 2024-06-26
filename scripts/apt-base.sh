#!/bin/bash
V_NODE_URL=https://deb.nodesource.com/setup_20.x
V_FRIDA_VERSION=16.0.2
V_FRIDA_TOOLS_VERSION=12.3.0

apt-get update -y \
    && apt-get upgrade -y \
    && apt-get update -y \
    && dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y \
        locales \
        apt-utils \
    && locale-gen en_US.UTF-8 \
    && apt-get install -y \
        build-essential \
        ccache \
        cmake \
        curl \
        gdb \
        git \
        libssl-dev \
        libtool \
        libtool-bin \
        linux-headers-generic \
        make \
        ninja-build \
        openssl \
        pigz \
        pixz \
        pkg-config \
        python3.9 \
        python3.9-dev \
        python3.9-venv \
        python3-pip \
        python3-requests \
        python3-setuptools \
        software-properties-common \
        sudo \
        unzip \
        wget \
        zip \
        `# Phpactor` \
        php \
        php-cli \
        php-curl \
        php-gd \
        php-mbstring \
        php-xml \
    && curl -sL "${V_NODE_URL}" | sudo -E bash - \
    && sudo apt-get install -y nodejs \
    && unset http_proxy \
    && pip3 install --upgrade pip \
    && pip3 install frida==$V_FRIDA_VERSION \
    && pip3 install frida-tools==$V_FRIDA_TOOLS_VERSION \
    && npm install frida
