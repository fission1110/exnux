FROM ubuntu:focal AS base

ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

ARG APT_PROXY

ENV V_NODE_URL https://deb.nodesource.com/setup_14.x
ENV V_RBENV_URL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer
ENV V_AFLPP_BRANCH stable
ENV V_METASPLOIT_BRANCH 6.2.20
ENV V_FZF_BRANCH 0.34.0
ENV V_PWNDBG_BRANCH 2022.08.30
ENV V_GHIDRA_URL https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.1.5_build/ghidra_10.1.5_PUBLIC_20220726.zip
ENV V_JOHN_BRANCH bleeding-jumbo
ENV V_RADARE2_URL https://github.com/radareorg/radare2/releases/download/5.7.8/radare2_5.7.8_amd64.deb
ENV V_RADARE2_DEV_URL https://github.com/radareorg/radare2/releases/download/5.7.8/radare2-dev_5.7.8_amd64.deb
ENV V_IAITO_URL https://github.com/radareorg/iaito/releases/download/5.7.0/iaito_5.7.0_amd64.deb
ENV V_NVIM_URL https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb
ENV V_CODE_MINIMAP_URL https://github.com/wfxr/code-minimap/releases/download/v0.6.4/code-minimap_0.6.4_amd64.deb
ENV V_WEBSOCAT_URL https://github.com/vi/websocat/releases/download/v1.11.0/websocat.x86_64-unknown-linux-musl
ENV V_JD_GUI_URL https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6.deb
ENV V_PROCYON_URL https://github.com/mstrobel/procyon/releases/download/v0.6.0/procyon-decompiler-0.6.0.jar
ENV V_KALI_WORDLIST_URL https://github.com/3ndG4me/KaliLists/archive/refs/heads/master.tar.gz
ENV V_DOCKER_COMPOSE_URL https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-linux-x86_64
ENV V_BURPSUIT_URL https://portswigger-cdn.net/burp/releases/download?product=community&version=2022.8.5&type=Jar
ENV V_ZAP_URL https://github.com/zaproxy/zaproxy/releases/download/v2.11.1/ZAP_2.11.1_Linux.tar.gz
ENV V_LUA_LANGUAGE_SERVER_URL https://github.com/sumneko/lua-language-server/releases/download/3.5.6/lua-language-server-3.5.6-linux-x64.tar.gz
ENV V_BEEF_BRANCH v0.5.4.0
ENV V_GOLANG_URL https://go.dev/dl/go1.19.2.linux-amd64.tar.gz
ENV V_FFUF_URL https://github.com/ffuf/ffuf/releases/download/v1.5.0/ffuf_1.5.0_linux_amd64.tar.gz
ENV V_GOOGLE_CHROME_URL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

RUN export http_proxy=$APT_PROXY \
    && apt-get update -y \
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
        # Phpactor
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

ENV USERNAME=nonroot
RUN useradd -m $USERNAME \
    && usermod -a -G sudo $USERNAME \
    && echo "$USERNAME       ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0400 /etc/sudoers.d/$USERNAME


ENV PATH /home/$USERNAME/.rbenv/bin:/home/$USERNAME/.rbenv/shims:/usr/local/src/metasploit-framework:$PATH

RUN wget -O- "${V_RBENV_URL}" | sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" bash

################################################
#
#    aflpp-build
#
################################################
FROM base AS aflpp-build

RUN export http_proxy=$APT_PROXY \
    && apt-get update -y \
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
    && git clone -b "${V_AFLPP_BRANCH}" --depth 1 https://github.com/AFLplusplus/AFLplusplus /usr/local/src/AFLplusplus \
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
    && apt-get update -y \
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


RUN mkdir -p /usr/local/src/metasploit-framework \
    && chown $USERNAME:$USERNAME /usr/local/src/metasploit-framework \
    && sudo -u $USERNAME git clone -b "${V_METASPLOIT_BRANCH}" --recurse-submodules --depth 1 --shallow-submodules https://github.com/rapid7/metasploit-framework.git /usr/local/src/metasploit-framework && \
    # gem install and bundle install
    cd /usr/local/src/metasploit-framework \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" rbenv install 3.0.2 \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" rbenv install 2.7.2 \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" rbenv global 3.0.2 \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" gem update --system \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" gem install --no-user-install bundler \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" gem install --no-user-install wpscan \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" bundle install --jobs=$(nproc)


################################################
#
#    fzf-build
#
################################################
FROM base AS fzf-build
RUN mkdir -p /usr/local/src/fzf \
    && chown $USERNAME:$USERNAME /usr/local/src/fzf \
    && sudo -u $USERNAME git clone -b "${V_FZF_BRANCH}" --recurse-submodules --depth 1 --shallow-submodules https://github.com/junegunn/fzf.git /usr/local/src/fzf


################################################
#
#    pwndbg-build
#
################################################
FROM base AS pwndbg-build

RUN mkdir -p /usr/local/src/pwndbg \
    && chown $USERNAME:$USERNAME /usr/local/src/pwndbg \
    && sudo -u $USERNAME git clone -b "${V_PWNDBG_BRANCH}" --recurse-submodules --depth 1 --shallow-submodules https://github.com/pwndbg/pwndbg.git /usr/local/src/pwndbg

################################################
#
#    ghidra-build
#
################################################
FROM base AS ghidra-build

RUN mkdir -p /usr/local/src/ghidra \
    && cd /usr/local/src/ghidra \
    && wget -O ghidra.zip "${V_GHIDRA_URL}"\
    && unzip ./ghidra.zip \
    && rm ./ghidra.zip \
    && mv ghidra_*/** ./  \
    && chmod +x ghidraRun

################################################
#
#    john-build
#
################################################
FROM base AS john-build

RUN export http_proxy=$APT_PROXY \
    && apt-get update -y \
    && apt-get install -y \
      # john
        build-essential \
        libssl-dev \
        git \
        zlib1g-dev \
        yasm \
        libgmp-dev \
        libpcap-dev \
        pkg-config \
        libbz2-dev \
        nvidia-opencl-dev \
        ocl-icd-opencl-dev \
        opencl-headers \
        ocl-icd-opencl-dev \
        opencl-headers \
        pocl-opencl-icd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && unset http_proxy

# john
RUN mkdir -p /usr/local/src/john \
    && git clone -b "${V_JOHN_BRANCH}" --recurse-submodules --depth 1 https://github.com/openwall/john.git /usr/local/src/john \
    && cd /usr/local/src/john/src \
    && ./configure \
    && make -s clean \
    && make -sj$(nproc)

################################################
#
#    phpactor-build
#
################################################
FROM base AS phpactor-build
# composer
RUN cd /usr/local/bin \
    && wget -O composer-setup.php https://getcomposer.org/installer \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Phpactor
RUN mkdir /usr/local/src/phpactor \
    && chown $USERNAME:$USERNAME /usr/local/src/phpactor \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" git clone --depth 1 https://github.com/phpactor/phpactor /usr/local/src/phpactor \
    && cd /usr/local/src/phpactor \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" composer update \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" composer install

################################################
#
#    base-extended Adds user tools
#
################################################
FROM base AS base-extended
RUN export http_proxy=$APT_PROXY \
    && apt-get update -y \
    && apt-get install -y \
      # ghidra
        fontconfig \
        libc-dbg:i386 \
        libc6-dbg \
        libglib2.0-dev \
        libxi6 \
        libxrender1 \
        libxtst6 \
        openjdk-17-jdk \
        openjdk-17-jre \
       # iaito
        libgvc6 \
        libqt5svg5 \
        libuuid1 \
        qt5-default \
      # alacritty
        cargo \
        cmake \
        libfontconfig1-dev \
        libfreetype6-dev \
        libxcb-xfixes0-dev \
        libxkbcommon-dev \
        pkg-config \
        python3 \
      # BeEF
        curl \
        git \
        build-essential \
        openssl \
        libreadline6-dev \
        zlib1g \
        zlib1g-dev \
        libssl-dev \
        libyaml-dev \
        libsqlite3-0 \
        libsqlite3-dev \
        sqlite3 \
        libxml2-dev \
        libxslt1-dev \
        autoconf \
        libc6-dev \
        libncurses5-dev \
        automake \
        libtool \
        bison \
       # nodejs \
        libcurl4-openssl-dev \
        gcc-9-base \
        libgcc-9-dev \
      # pwninit
        liblzma-dev \
      # gimp
        gtk2-engines-pixbuf \
        libcanberra-gtk-module \
      # large
        audacity \
        clangd \
        docker.io \
        firefox \
        gimp \
        hashcat \
        hashcat-nvidia \
        inkscape \
        mysql-client \
        nmap \
        okular \
        smbclient \
        sqlmap \
        wireshark \
    && unset http_proxy

# install random tools to make the image a full dev environment
RUN export http_proxy=$APT_PROXY \
    && add-apt-repository ppa:ansible/ansible \
    && apt-get update -y \
    && apt-get install -y \
        alsa-base \
        alsa-utils \
        ansible \
        apktool \
        apulse \
        autopsy \
        bash-completion \
        binutils \
        binwalk \
        byobu \
        cpio \
        dc \
        dialog \
        dnsutils \
        elfutils \
        exiftool \
        expect \
        exuberant-ctags \
        fd-find \
        ffmpeg \
        flake8 \
        fonts-beng \
        fonts-dejavu \
        fonts-deva \
        fonts-freefont-ttf \
        fonts-gujr \
        fonts-guru \
        fonts-indic \
        fonts-knda \
        fonts-liberation \
        fonts-mlym \
        fonts-noto-cjk \
        fonts-noto-color-emoji \
        fonts-opensymbol \
        fonts-orya \
        fonts-smc \
        fonts-taml \
        fonts-telu \
        fonts-ubuntu \
        fonts-ubuntu-console \
        fonts-ubuntu-title \
        foremost \
        ftp \
        git-gui \
        gitk \
        gobuster \
        htop \
        hydra \
        iputils-ping \
        ldap-utils \
        libclang-9-dev \
        libgl1-mesa-dri \
        libgl1-mesa-glx \
        libsndfile1-dev \
        ltrace \
        lz4 \
        lzip \
        lzop \
        nasm \
        ncat \
        net-tools \
        netcat-openbsd \
        nfs-common \
        nikto \
        openssh-client \
        openvpn \
        ophcrack \
        p0f \
        parallel \
        patchelf \
        postgresql-client \
        pv \
        python3-venv \
        ripgrep \
        sleuthkit \
        snmp \
        socat \
        strace \
        tcpdump \
        tmux \
        virt-manager \
        x2goclient \
        xclip \
        xxd \
        zsh \
    && unset http_proxy

RUN export http_proxy=$APT_PROXY \
    && apt-get update -y \
    && echo 'y\ny' | unminimize \
    && unset http_proxy \
    && usermod -aG docker $USERNAME \
    && ln -s $(which fdfind) /usr/local/bin/fd \
    && chsh -s $(which zsh) $USERNAME \
    && pip3 install pwntools \
    && pip3 install ipython \
    && pip3 install jedi

# nvim
RUN pip3 install neovim \
    && npm install -g neovim \
    && npm install -g typescript typescript-language-server bash-language-server @tailwindcss/language-server \
    && pip3 install libclang \
    && pip3 install pyright

FROM base-extended AS base-final

# metasploit
COPY --from=metasploit-build --chown=$USERNAME /usr/local/src/metasploit-framework /usr/local/src/metasploit-framework
COPY --from=metasploit-build --chown=$USERNAME /home/$USERNAME/.rbenv /home/$USERNAME/.rbenv
COPY ./scripts /usr/local/src/scripts

#afl++
COPY --from=aflpp-build /usr/local/src/build /usr/local/src/AFLplusplus/build
RUN cp -rf /usr/local/src/AFLplusplus/build/* / \
    && rm -r /usr/local/src/AFLplusplus

# fzf for nvim zsh
COPY --from=fzf-build /usr/local/src/fzf /usr/local/src/fzf
RUN cd /usr/local/src/fzf \
    && ./install --bin

# pwndbg for gdb
COPY --from=pwndbg-build --chown=$USERNAME /usr/local/src/pwndbg /usr/local/src/pwndbg
RUN cd /usr/local/src/pwndbg \
    && sudo -u $USERNAME ./setup.sh

# ghidra
COPY --from=ghidra-build /usr/local/src/ghidra /usr/local/src/ghidra
RUN ln -s /usr/local/src/ghidra/ghidraRun /usr/local/bin/ghidraRun

# Phpactor
COPY --from=phpactor-build /usr/local/bin/composer.phar /usr/local/bin/composer.phar
COPY --from=phpactor-build /usr/local/src/phpactor /usr/local/src/phpactor
RUN ln -s /usr/local/bin/composer.phar /usr/local/bin/composer \
    && ln -s /usr/local/src/phpactor/bin/phpactor /usr/local/bin/phpactor

# john
COPY --from=john-build /usr/local/src/john /usr/local/src/john

ENV PATH $PATH:/usr/local/src/john/run
ENV PATH=$PATH:/home/$USERNAME/.cargo/bin
ENV PATH $PATH:/home/$USERNAME/go/bin

RUN chmod +x /usr/local/src/scripts/*.sh

# Single threaded because they rely on dpkg run lock
RUN /usr/local/src/scripts/radare2.sh
RUN /usr/local/src/scripts/iaito.sh
RUN /usr/local/src/scripts/nvim.sh
RUN /usr/local/src/scripts/code-minimap.sh
RUN /usr/local/src/scripts/google-chrome.sh

# These are multi-threaded
RUN parallel --verbose ::: /usr/local/src/scripts/jd-gui.sh \
    /usr/local/src/scripts/gobuster.sh \
    /usr/local/src/scripts/docker-compose.sh \
    /usr/local/src/scripts/burpsuit.sh \
    /usr/local/src/scripts/zap.sh \
    /usr/local/src/scripts/lua-language-server.sh \
    /usr/local/src/scripts/ffuf.sh \
    /usr/local/src/scripts/websocat.sh \
    /usr/local/src/scripts/procyon.sh \
    /usr/local/src/scripts/golang.sh \
    /usr/local/src/scripts/chepy.sh \
    /usr/local/src/scripts/alacritty.sh \
    /usr/local/src/scripts/beef.sh

# Single threaded because they rely on go install
RUN /usr/local/src/scripts/gopls.sh
RUN /usr/local/src/scripts/lemonade.sh

# fix ansible
RUN pip3 install markupsafe==2.0.1

# fix wireshark
RUN groupadd wireshark \
    && usermod -a -G wireshark $USERNAME \
    && chgrp wireshark /usr/bin/dumpcap \
    && chmod 750 /usr/bin/dumpcap \
    && setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

# fix sound and video
RUN usermod -a -G audio $USERNAME \
    && usermod -a -G video $USERNAME


# pwninit
RUN sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" cargo install pwninit

WORKDIR /home/$USERNAME
ENV HOME /home/$USERNAME
USER $USERNAME


# dotfiles
ENV PATH=$PATH:/home/$USERNAME/tools
COPY --chown=$USERNAME dotfiles ./

# nvim
RUN  mkdir -p ~/.config/nvim/ctags/mytags \
    && .config/nvim/bundle/nvim-typescript/install.sh \
    && nvim --headless +Helptags +qa \
    && nvim --headless +UpdateRemotePlugins +qa \
    && nvim --headless +TSUpdate +qa

CMD ["/usr/bin/byobu"]
