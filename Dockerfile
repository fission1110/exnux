FROM ubuntu:focal AS base

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

RUN export http_proxy=$APT_PROXY \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get update -y \
    && dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y \
        apt-utils \
    && apt-get install -y \
        build-essential \
        ccache \
        cmake \
        curl \
        gdb \
        git \
        libtool \
        libtool-bin \
        linux-headers-generic \
        make \
        ninja-build \
        nodejs \
        npm \
        openssl \
        pigz \
        pixz \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        python3-requests \
        python3-setuptools \
        sudo \
        unzip \
        wget \
        zip \
    && unset http_proxy

ENV USERNAME=nonroot
RUN useradd -m $USERNAME \
    && usermod -a -G sudo $USERNAME \
    && echo "$USERNAME       ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0400 /etc/sudoers.d/$USERNAME

# Do some weird things with rbenv to get it to install to the /usr/local/src directory so it won't get
# overwritten by the home directory mount
ENV RBENV_ROOT /usr/local/src/rbenv/.rbenv
ENV RBENV_DIR $RBENV_ROOT
ENV PATH $RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/src/metasploit-framework:$PATH

# Don't put plugins in the home directory
ENV R2PM_PLUGDIR /usr/local/src/r2pm/plugins
ENV R2PM_BINDIR /usr/local/src/r2pm/prefix/bin
ENV R2PM_DBDIR /usr/local/src/r2pm/db
ENV R2PM_GITDIR /usr/local/src/r2pm/git
ENV SLEIGHHOME /usr/local/src/r2pm/plugins/r2ghidra_sleigh


################################################
#
#    aflpp-build
#
################################################
FROM base AS aflpp-build

RUN export http_proxy=$APT_PROXY \
    && apt-get install -y \
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
        autoconf \
        automake \
        pkg-config \
    && unset http_proxy

# build environment should be the newest the distro offers for afl
RUN mkdir -p /usr/local/src/AFLplusplus \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 20 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 20 \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-11 20 \
    && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-11 20 \
    && update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-11 20 \
    && git clone -b stable --depth 1 https://github.com/AFLplusplus/AFLplusplus /usr/local/src/AFLplusplus \
    && cd /usr/local/src/AFLplusplus \
    && make distrib \
    && mkdir ../build \
    && make DESTDIR=../build install \
    && rm -rf /usr/local/src/AFLplusplus


################################################
#
#    metasploit-build
#
################################################
FROM base AS metasploit-build

RUN export http_proxy=$APT_PROXY \
    && apt-get install -y \
        # metasploit
        autoconf \
        build-essential \
        git \
        libncurses-dev \
        libpcap-dev \
        libpq-dev \
        libsqlite3-dev \
        libxml2-dev \
        libyaml-dev \
        sqlite3 \
        libsqlite3-dev \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && unset http_proxy

RUN mkdir -p /usr/local/src/rbenv \
    && chown $USERNAME:$USERNAME /usr/local/src/rbenv \
    && wget -O /usr/local/src/rbenv/rbenv-installer https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer \
    && chmod +x /usr/local/src/rbenv/rbenv-installer \
    # change home directory to /usr/local/src/rbenv to get rbenv installer to write to a global directory
    && sudo -E -u $USERNAME "HOME=/usr/local/src/rbenv" /usr/local/src/rbenv/rbenv-installer \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "RBENV_ROOT=$RBENV_ROOT" "RBENV_DIR=$RBENV_DIR" rbenv install 3.0.2 \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "RBENV_ROOT=$RBENV_ROOT" "RBENV_DIR=$RBENV_DIR" rbenv global 3.0.2

RUN mkdir -p /usr/local/src/metasploit-framework \
    && chown $USERNAME:$USERNAME /usr/local/src/metasploit-framework \
    && sudo -u $USERNAME git clone -b 6.1.38 --recurse-submodules --depth 1 --shallow-submodules https://github.com/rapid7/metasploit-framework.git /usr/local/src/metasploit-framework && \
    # gem install and bundle install
    cd /usr/local/src/metasploit-framework \
    && sudo -E -u $USERNAME -s "PATH=$PATH" gem update --system \
    && sudo -E -u $USERNAME -s "PATH=$PATH" gem install --no-user-install bundler \
    && sudo -E -u $USERNAME -s "PATH=$PATH" bundle install --jobs=$(nproc)

################################################
#
#    radare2-build
#
################################################
FROM base AS radare2-build

RUN export http_proxy=$APT_PROXY \
    && apt-get install -y \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && unset http_proxy

# build r2 because for some reason all packaged versions segfault when debugging
RUN mkdir -p /usr/local/src/radare2 \
    && git clone -b 5.5.4 --recurse-submodules --depth 1 --shallow-submodules https://github.com/radareorg/radare2.git /usr/local/src/radare2 \
    && cd /usr/local/src/radare2 \
    && ./sys/debian.sh \
    && mkdir ../build \
    && cp ./*.deb ../build \
    && MAKE_JOBS=$(nproc) sys/install.sh --without-pull \
    && rm -r /usr/local/src/radare2

################################################
#
#    fzf-build
#
################################################
FROM base AS fzf-build
RUN mkdir -p /usr/local/src/fzf \
    && chown $USERNAME:$USERNAME /usr/local/src/fzf \
    && sudo -u $USERNAME git clone -b 0.30.0 --recurse-submodules --depth 1 --shallow-submodules https://github.com/junegunn/fzf.git /usr/local/src/fzf


################################################
#
#    pwndbg-build
#
################################################
FROM base AS pwndbg-build

RUN mkdir -p /usr/local/src/pwndbg \
    && chown $USERNAME:$USERNAME /usr/local/src/pwndbg \
    && sudo -u $USERNAME git clone -b 2022.01.05 --recurse-submodules --depth 1 --shallow-submodules https://github.com/pwndbg/pwndbg.git /usr/local/src/pwndbg

################################################
#
#    ghidra-build
#
################################################
FROM base AS ghidra-build

RUN mkdir -p /usr/local/src/ghidra \
    && cd /usr/local/src/ghidra \
    && wget -O ghidra.zip https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.1.2_build/ghidra_10.1.2_PUBLIC_20220125.zip \
    && unzip ./ghidra.zip \
    && rm ./ghidra.zip \
    && mv ghidra_*/** ./  \
    && chmod +x ghidraRun

################################################
#
#    base-extended Adds user tools
#
################################################
FROM base AS base-extended

# install random tools to make the image a full dev environment
RUN export http_proxy=$APT_PROXY \
    && apt-get update -y \
    && apt-get install -y \
        apktool \
        bash-completion \
        binutils \
        binwalk \
        byobu \
        dc \
        dnsutils \
        docker.io \
        expect \
        exuberant-ctags \
        hashcat \
        hashcat-nvidia \
        hydra \
        john \
        ophcrack \
        audacity \
        exiftool \
        foremost \
        sqlmap \
        burp \
        flake8 \
        git-gui \
        gitk \
        htop \
        iputils-ping \
        ldap-utils \
        ltrace \
        ncat \
        netcat-openbsd \
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
        xxd \
        zsh \
      # ghidra
        fontconfig \
        libc6-dbg \
        libc-dbg:i386 \
        libglib2.0-dev \
        libxi6 \
        libxrender1 \
        libxtst6 \
        openjdk-11-jdk \
        openjdk-11-jre \
        # iaito
        libgvc6 \
        libqt5svg5 \
        libuuid1 \
        qt5-default \
    && echo 'y\ny' | unminimize \
    && groupmod -g 999 docker \
    && usermod -aG docker $USERNAME \
    && chsh -s $(which zsh) $USERNAME \
    && pip3 install pwntools \
    && unset http_proxy

RUN pip3 install neovim \
    && npm install -g neovim \
    && npm install -g typescript \
    && pip3 install libclang

FROM base-extended AS base-final
# general
#RUN export http_proxy=$APT_PROXY \
#    && apt-get update -y \
#    && apt-get install -y \
#      # neovim
#        autoconf \
#        automake \
#        curl \
#        doxygen \
#        gettext \
#        libtool \
#        libtool-bin \
#        ninja-build \
#        nodejs \
#        npm \
#        unzip \
      # retdec
#        autoconf \
#        automake \
#        cmake \
#        doxygen \
#        git \
#        graphviz \
#        libssl-dev \
#        libtool \
#        m4 \
#        openssl \
#        pkg-config \
#        python3 \
#        upx \
#        zlib1g-dev \
#    && unset http_proxy

COPY --from=metasploit-build --chown=$USERNAME /usr/local/src/rbenv /usr/local/src/rbenv
COPY --from=metasploit-build --chown=$USERNAME /usr/local/src/metasploit-framework /usr/local/src/metasploit-framework

COPY --from=radare2-build /usr/local/src/build/*.deb /usr/local/src/radare2/
RUN cd /usr/local/src/radare2 \
    && dpkg -i ./radare2*.deb \
    && rm -r /usr/local/src/radare2 \
    && mkdir /usr/local/src/r2pm \
    && chown $USERNAME:$USERNAME /usr/local/src/r2pm \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 20 \
    && sudo -E -u $USERNAME r2pm init \
    && sudo -E -u $USERNAME r2pm update \
#    && r2pm -gi r2dec \
    && sudo -E -u $USERNAME "HOME=/home/$USERNAME" r2pm -gi r2ghidra \
    && mv /home/$USERNAME/.local/share/radare2/plugins/r2ghidra_sleigh /usr/local/src/r2pm/plugins/r2ghidra_sleigh 

RUN wget -O /iaito.deb https://github.com/radareorg/iaito/releases/download/5.5.0-beta/iaito_5.5.0_amd64.deb \
    && dpkg -i /iaito.deb \
    && rm /iaito.deb

COPY --from=aflpp-build /usr/local/src/build /usr/local/src/AFLplusplus/build
RUN cp -rf /usr/local/src/AFLplusplus/build/* / \
    && rm -r /usr/local/src/AFLplusplus

COPY --from=fzf-build /usr/local/src/fzf /usr/local/src/fzf
RUN cd /usr/local/src/fzf \
    && ./install --bin

RUN wget -O /neovim.deb https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb \
    && dpkg -i /neovim.deb \
    && rm /neovim.deb

#RUN mkdir -p /usr/local/src/retdec \
#    && cd /usr/local/src/retdec \
#    && wget -O retdec.tar.xz https://github.com/avast/retdec/releases/download/v4.0/retdec-v4.0-ubuntu-64b.tar.xz \
#    && tar -I pixz -xvf retdec.tar.xz \
#    && rm retdec.tar.xz \
#    && cp -r ./retdec/* /usr/local \
#    && cd / \
#    && rm -r /usr/local/src/retdec

COPY --from=pwndbg-build --chown=$USERNAME /usr/local/src/pwndbg /usr/local/src/pwndbg
RUN cd /usr/local/src/pwndbg \
    && sudo -u $USERNAME ./setup.sh

COPY --from=ghidra-build /usr/local/src/ghidra /usr/local/src/ghidra
RUN ln -s /usr/local/src/ghidra/ghidraRun /usr/local/bin/ghidraRun

# Set home and change user before zsh configuration to keep correct permissions in the $USERNAME home dir
WORKDIR /home/$USERNAME
ENV HOME /home/$USERNAME
USER $USERNAME

#ohmyzsh stomps over .zshrc so do this last
RUN nvim --headless +UpdateRemotePlugins +qa

CMD ["/usr/bin/byobu"]
