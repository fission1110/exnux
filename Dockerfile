FROM ubuntu:focal

ENV RADARE2_TAG=5.6.2
ENV PWNDBG_TAG=2022.01.05
ENV RETDEC_TAG=v4.0
ENV NEOVIM_TAG=v0.6.1
ENV IAITO_TAG=master
ENV GHIDRA_RELEASE_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.1.2_build/ghidra_10.1.2_PUBLIC_20220125.zip 

ENV USERNAME=nonroot

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Use an apt-cache-ng proxy as the http_proxy if you want to speed up fetching packages.
# docker run --name apt-cacher-ng --init -d --restart=always \
#    --publish 3142:3142 \
#    --volume /srv/docker/apt-cacher-ng:/var/cache/apt-cacher-ng \
#    sameersbn/apt-cacher-ng:3.3-20200524
# docker build -t exnux:v0.1 --build-arg=APT_PROXY="http://<IP>:3142" .
ARG APT_PROXY

# general
RUN export http_proxy=$APT_PROXY && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get update -y && \
    apt-get install -y \
        apt-utils && \
    apt-get install -y \
        sudo \
        pigz \
        gdb \
      # radare2
        build-essential \
        cmake \
        git \
        wget \
        ccache \
      # iaito
        qttools5-dev-tools \
        qtbase5-dev \
        qtchooser \
        qt5-qmake \
        qtbase5-dev-tools \
        libqt5svg5 \
        libqt5svg5-dev \
        qt5-default \
        zip \
        libgvc6 \
        qttools5-dev \
        make \
        linux-headers-generic \
        libuuid1 \
      # neovim
        ninja-build \
        gettext \
        libtool \
        libtool-bin \
        autoconf \
        automake \
        unzip \
        curl \
        nodejs \
        npm \
        doxygen \
      # retdec
        cmake \
        git \
        python3 \
        doxygen \
        graphviz \
        upx \
        openssl \
        libssl-dev \
        zlib1g-dev \
        autoconf \
        automake \
        pkg-config \
        m4 \
        libtool \
      # ghidra
        openjdk-11-jre \
        openjdk-11-jdk \
        fontconfig \
        libxrender1 \
        libxtst6 \
        libxi6 \
        python3-requests \
        gdb \
        python3-dev \
        python3-pip \
        python3-setuptools \
        libglib2.0-dev \
        libc6-dbg \
        git \
      # afl++
        flex \
        bison \
        libglib2.0-dev \
        libpixman-1-dev \
        python3-setuptools \
        lld-11 \
        llvm-11 \
        llvm-11-tools \
        llvm-11-dev \
        clang-11 \
        gcc-10 \
        g++-10 \
        gcc-10-plugin-dev \
        libstdc++-10-dev && \
      # pwndbg
    dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get -y install \
        libc-dbg:i386 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    unset http_proxy


RUN useradd -m $USERNAME && \
    usermod -a -G sudo $USERNAME && \
    echo "$USERNAME       ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0400 /etc/sudoers.d/$USERNAME

RUN mkdir -p /usr/local/src/retdec && \
    git clone -b $RETDEC_TAG --depth 1 --shallow-submodules https://github.com/avast/retdec.git /usr/local/src/retdec && \
    cd /usr/local/src/retdec && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_LIBRARY_PATH=/usr/lib/gcc/x86_64-linux-gnu/7/ && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -r /usr/local/src/retdec

RUN mkdir -p /usr/local/src/pwndbg && \
    git clone -b $PWNDBG_TAG --recurse-submodules --depth 1 --shallow-submodules https://github.com/pwndbg/pwndbg.git /usr/local/src/pwndbg && \
    cd /usr/local/src/pwndbg && \
    ./setup.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/src/neovim && \
    git clone -b $NEOVIM_TAG --recurse-submodules --depth 1 --shallow-submodules https://github.com/neovim/neovim.git /usr/local/src/neovim && \
    cd /usr/local/src/neovim && \
    make CMAKE_BUILD_TYPE=Release && \
    make install && \
    cd / && \
    rm -r /usr/local/src/neovim && \
    pip3 install neovim && \
    npm install -g neovim && \
    npm install -g typescript && \
    pip3 install libclang

RUN mkdir -p /usr/local/src/ghidra && \
    cd /usr/local/src/ghidra && \
    wget -O ghidra.zip $GHIDRA_RELEASE_URL && \
    unzip ./ghidra.zip && \
    rm ./ghidra.zip && \
    mv ghidra_*/** ./  && \
    chmod +x ghidraRun && \
    ln -s /usr/local/src/ghidra/ghidraRun /usr/local/bin/ghidraRun

# build environment should be the newest the distro offers for ifl
RUN mkdir -p /usr/local/src/AFLplusplus && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 20 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 20 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 20 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 20 && \
    git clone https://github.com/AFLplusplus/AFLplusplus /usr/local/src/AFLplusplus && \
    cd /usr/local/src/AFLplusplus && \
    make distrib && \
    make install

RUN mkdir -p /usr/local/src/radare2 && \
    git clone -b $RADARE2_TAG --depth 1 --shallow-submodules https://github.com/radareorg/radare2.git /usr/local/src/radare2 && \
    cd /usr/local/src/radare2 && \
    ./sys/install.sh && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 20 && \
    sudo -u $USERNAME r2pm init && \
    sudo -u $USERNAME r2pm update && \
    sudo -u $USERNAME r2pm install r2ghidra && \
    sudo -u $USERNAME r2pm install r2dec

# iaito needs google breakpad to compile
# iaito needs specific r2 version so build r2 in the submodule it's linked to.
RUN mkdir -p /usr/local/src/depot_tools && \
    git clone --recurse-submodules --depth 1 --shallow-submodules https://chromium.googlesource.com/chromium/tools/depot_tools.git /usr/local/src/depot_tools && \
    mkdir -p /usr/local/src/breakpad && \
    cd /usr/local/src/breakpad && \
    PATH=/usr/local/src/depot_tools:$PATH fetch breakpad && \
    cd src && \
    ./configure && \
    make && \
    make install && \

    mkdir -p /usr/local/src/iaito && \
    git clone -b $IAITO_TAG --depth 1 --recurse-submodules --shallow-submodules https://github.com/radareorg/iaito.git /usr/local/src/iaito && \

    #cd /usr/local/src/iaito/radare2 && \
    #./sys/install.sh --disable-thread && \
    #update-alternatives --install /usr/bin/python python /usr/bin/python3 20 && \
    #r2pm init && \
    #r2pm update && \
    #r2pm install r2ghidra && \
    #r2pm install r2dec && \

    cd /usr/local/src/iaito && \
    ./configure && \
    CMAKE_FLAGS="-j$(nproc) " make && \
    make install && \
    rm -r /usr/local/src/depot_tools



# install random tools to make the image a full dev environment
RUN export http_proxy=$APT_PROXY && \
    apt-get update -y && \
    apt-get install -y \
    bash-completion \
    tmux \
    byobu \
    exuberant-ctags \
    virt-manager \
    xclip \
    snmp \
    wireshark \
    tcpdump \
    nmap \
    dnsutils \
    p0f \
    php \
    php-cli \
    x2goclient \
    openssh-client \
    clang \
    binutils \
    apktool \
    strace \
    ltrace \
    binwalk \
    zsh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    chsh -s $(which zsh) $USERNAME && \
    unset http_proxy


# Set home and change user before zsh configuration to keep correct permissions in the $USERNAME home dir
WORKDIR /home/$USERNAME
ENV HOME /home/$USERNAME
USER $USERNAME
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    byobu-enable

#ohmyzsh stomps over .zshrc so do this last
COPY --chown=$USERNAME:$USERNAME dotfiles /home/$USERNAME

ENTRYPOINT ["/usr/bin/byobu"]
