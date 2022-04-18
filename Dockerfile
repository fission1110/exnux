FROM ubuntu:focal

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
    apt-get install -y \
        apt-utils && \
    dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y \
        gdb \
        pigz \
        pixz \
        sudo \
      # radare2
        build-essential \
        ccache \
        cmake \
        git \
        wget \
      # iaito
        libgvc6 \
        libqt5svg5 \
        libqt5svg5-dev \
        libuuid1 \
        linux-headers-generic \
        make \
        qt5-default \
        qt5-qmake \
        qtbase5-dev \
        qtbase5-dev-tools \
        qtchooser \
        qttools5-dev \
        qttools5-dev-tools \
        zip \
      # neovim
        autoconf \
        automake \
        curl \
        doxygen \
        gettext \
        libtool \
        libtool-bin \
        ninja-build \
        nodejs \
        npm \
        unzip \
      # retdec
        autoconf \
        automake \
        cmake \
        doxygen \
        git \
        graphviz \
        libssl-dev \
        libtool \
        m4 \
        openssl \
        pkg-config \
        python3 \
        upx \
        zlib1g-dev \
      # ghidra
        fontconfig \
        gdb \
        git \
        libc6-dbg \
        libc-dbg:i386 \
        libglib2.0-dev \
        libxi6 \
        libxrender1 \
        libxtst6 \
        openjdk-11-jdk \
        openjdk-11-jre \
        python3-dev \
        python3-pip \
        python3-requests \
        python3-setuptools \
      # afl++
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
        python3-setuptools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    unset http_proxy


ENV USERNAME=nonroot
RUN useradd -m $USERNAME && \
    usermod -a -G sudo $USERNAME && \
    echo "$USERNAME       ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0400 /etc/sudoers.d/$USERNAME

RUN mkdir -p /usr/local/src/retdec && \
    cd /usr/local/src/retdec && \
    wget -O retdec.tar.xz https://github.com/avast/retdec/releases/download/v4.0/retdec-v4.0-ubuntu-64b.tar.xz && \
    tar -I pixz -xvf retdec.tar.xz && \
    cp -r ./retdec/* /usr/local && \
    cd / && \
    rm -r /usr/local/src/retdec

RUN mkdir -p /usr/local/src/pwndbg && \
    chown $USERNAME:$USERNAME /usr/local/src/pwndbg && \
    sudo -u $USERNAME git clone -b 2022.01.05 --recurse-submodules --depth 1 --shallow-submodules https://github.com/pwndbg/pwndbg.git /usr/local/src/pwndbg && \
    cd /usr/local/src/pwndbg && \
    sudo -u $USERNAME ./setup.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/src/neovim && \
    cd /usr/local/src/neovim && \
    wget -O neovim.deb https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb && \
    dpkg -i neovim.deb && \
    pip3 install neovim && \
    npm install -g neovim && \
    npm install -g typescript && \
    pip3 install libclang && \
    rm -r /usr/local/src/neovim

RUN mkdir -p /usr/local/src/ghidra && \
    cd /usr/local/src/ghidra && \
    wget -O ghidra.zip https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.1.2_build/ghidra_10.1.2_PUBLIC_20220125.zip && \
    unzip ./ghidra.zip && \
    rm ./ghidra.zip && \
    mv ghidra_*/** ./  && \
    chmod +x ghidraRun && \
    ln -s /usr/local/src/ghidra/ghidraRun /usr/local/bin/ghidraRun

# build environment should be the newest the distro offers for afl
RUN mkdir -p /usr/local/src/AFLplusplus && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 20 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 20 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 20 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 20 && \
    update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-11 20 && \
    git clone https://github.com/AFLplusplus/AFLplusplus /usr/local/src/AFLplusplus && \
    cd /usr/local/src/AFLplusplus && \
    make distrib && \
    make install

# Don't put plugins in the home directory
ENV R2PM_PLUGDIR /usr/local/src/radare2/r2pm/plugins
ENV R2PM_BINDIR /usr/local/src/radare2/r2pm/prefix/bin
ENV R2PM_DBDIR /usr/local/src/radare2/r2pm/db
ENV R2PM_GITDIR /usr/local/src/radare2/r2pm/git
ENV SLEIGHHOME /usr/local/src/radare2/r2pm/plugins/r2ghidra_sleigh
# build r2 because for some reason all packaged versions segfault when debugging
RUN mkdir -p /usr/local/src/radare2 && \
    git clone -b 5.5.4 --recurse-submodules --depth 1 --shallow-submodules https://github.com/radareorg/radare2.git /usr/local/src/radare2 && \
    cd /usr/local/src/radare2 && \
    sys/install.sh && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 20 && \
    sudo -u $USERNAME r2pm init && \
    sudo -u $USERNAME r2pm update && \
    r2pm -gi r2dec && \
	r2pm -gi r2ghidra && \
	mv ~/.local/share/radare2/plugins/r2ghidra_sleigh /usr/local/src/radare2/r2pm/plugins/r2ghidra_sleigh

RUN mkdir -p /usr/local/src/iaito && \
    cd /usr/local/src/iaito && \
    wget -O iaito.deb https://github.com/radareorg/iaito/releases/download/5.5.0-beta/iaito_5.5.0_amd64.deb && \
    dpkg -i iaito.deb && \
    rm -r /usr/local/src/iaito

# install random tools to make the image a full dev environment
RUN export http_proxy=$APT_PROXY && \
    apt-get update -y && \
    apt-get install -y \
        apktool \
        bash-completion \
        binutils \
        binwalk \
        byobu \
        clang \
        dnsutils \
        exuberant-ctags \
        htop \
        ltrace \
        nmap \
        openssh-client \
        p0f \
        php \
        php-cli \
        snmp \
        strace \
        tcpdump \
        tmux \
        virt-manager \
        wireshark \
        x2goclient \
        xclip \
        zsh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    chsh -s $(which zsh) $USERNAME && \
    pip3 install pwntools && \
    unset http_proxy

# Set home and change user before zsh configuration to keep correct permissions in the $USERNAME home dir
WORKDIR /home/$USERNAME
ENV HOME /home/$USERNAME
USER $USERNAME

#ohmyzsh stomps over .zshrc so do this last
RUN nvim --headless +UpdateRemotePlugins +qa

CMD ["/usr/bin/byobu"]
