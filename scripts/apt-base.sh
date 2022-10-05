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
        python3 \
        python3-dev \
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
    && pip3 install frida \
    && pip3 install frida-tools \
    && npm install frida
