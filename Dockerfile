FROM ubuntu:focal AS base

ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

ARG APT_PROXY

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
    && curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - \
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

RUN wget -O- 'https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer' | sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" bash

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
    && sudo -u $USERNAME git clone -b 6.1.38 --recurse-submodules --depth 1 --shallow-submodules https://github.com/rapid7/metasploit-framework.git /usr/local/src/metasploit-framework && \
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
    && git clone -b bleeding-jumbo --recurse-submodules --depth 1 https://github.com/openwall/john.git /usr/local/src/john \
    && cd /usr/local/src/john/src \
    && ./configure \
    && make -s clean \
    && make -sj$(nproc)

################################################
#
#    lua-lsp-build
#
################################################
FROM base AS lua-lsp-build
# lua-language-server
RUN mkdir /usr/local/src/lua-language-server \
    && git clone -b 3.2.3 --depth 1 --recurse-submodules https://github.com/sumneko/lua-language-server.git /usr/local/src/lua-language-server \
    && cd /usr/local/src/lua-language-server/ \
    && cd ./3rd/luamake \
    && ./compile/install.sh \
    && cd ../../ \
    && ./3rd/luamake/luamake rebuild

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
        #nodejs \
        libcurl4-openssl-dev \
        gcc-9-base \
        libgcc-9-dev \
      # large
        audacity \
        clangd \
        docker.io \
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
        libsndfile1-dev \
        ltrace \
        lz4 \
        lzip \
        lzop \
        nasm \
        ncat \
        netcat-openbsd \
        net-tools \
        nfs-common \
        nikto \
        openssh-client \
        openvpn \
        ophcrack \
        p0f \
        patchelf \
        postgresql-client \
        pv \
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

RUN mkdir -p /usr/local/src/radare2 \
    && wget -O /usr/local/src/radare2/radare2.deb https://github.com/radareorg/radare2/releases/download/5.7.8/radare2_5.7.8_amd64.deb \
    && wget -O /usr/local/src/radare2/radare2-dev.deb https://github.com/radareorg/radare2/releases/download/5.7.8/radare2-dev_5.7.8_amd64.deb \
    && dpkg -i /usr/local/src/radare2/radare2.deb \
    && dpkg -i /usr/local/src/radare2/radare2-dev.deb \
    && rm -rf /usr/local/src/radare2 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 20 \
    && sudo -E -u $USERNAME "HOME=/home/$USERNAME" r2pm init \
    && sudo -E -u $USERNAME "HOME=/home/$USERNAME" r2pm update \
#    && r2pm -gi r2dec \
    && sudo -E -u $USERNAME "HOME=/home/$USERNAME" r2pm -i r2ghidra \
    && sudo -E -u $USERNAME "HOME=/home/$USERNAME" r2pm -i r2frida

# iaito
RUN wget -O /iaito.deb https://github.com/radareorg/iaito/releases/download/5.7.0/iaito_5.7.0_amd64.deb \
    && dpkg -i /iaito.deb \
    && rm /iaito.deb

#afl++
COPY --from=aflpp-build /usr/local/src/build /usr/local/src/AFLplusplus/build
RUN cp -rf /usr/local/src/AFLplusplus/build/* / \
    && rm -r /usr/local/src/AFLplusplus

# fzf for nvim zsh
COPY --from=fzf-build /usr/local/src/fzf /usr/local/src/fzf
RUN cd /usr/local/src/fzf \
    && ./install --bin

# nvim
RUN wget -O /neovim.deb https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb \
    && dpkg -i /neovim.deb \
    && rm /neovim.deb

# nvim minimap
RUN wget -O /code-minimap.deb https://github.com/wfxr/code-minimap/releases/download/v0.6.4/code-minimap-musl_0.6.4_amd64.deb \
    && dpkg -i /code-minimap.deb \
    && rm /code-minimap.deb

# websocat
RUN wget -O /usr/local/bin/websocat https://github.com/vi/websocat/releases/download/v1.9.0/websocat_linux64 \
    && chmod +x /usr/local/bin/websocat

# jd-gui
RUN wget -O /jd-gui.deb https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6.deb \
    && dpkg -i /jd-gui.deb \
	&& echo "java -Xms2G -Xmx5G -jar /opt/jd-gui/jd-gui-1.6.6-min.jar" > /usr/local/bin/jd-gui \
	&& chmod +x /usr/local/bin/jd-gui \
    && rm /jd-gui.deb

# procyon
RUN mkdir -p /usr/local/src/procyon \
    && wget -O /usr/local/src/procyon/procyon-decompiler.jar https://github.com/mstrobel/procyon/releases/download/v0.6.0/procyon-decompiler-0.6.0.jar \
	&& echo 'java -Xms2G -Xmx5G -jar /usr/local/src/procyon/procyon-decompiler.jar $@' > /usr/local/bin/procyon \
    && chmod +x /usr/local/bin/procyon

# gobuster
RUN mkdir -p /home/$USERNAME/Wordlists/ \
    && chown $USERNAME:$USERNAME /home/$USERNAME/Wordlists \
    && sudo -u $USERNAME wget -O /home/$USERNAME/Wordlists/kali-wordlists.tar.gz https://github.com/3ndG4me/KaliLists/archive/refs/heads/master.tar.gz

# docker
RUN curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# burpsuite
RUN mkdir -p /usr/local/src/burp/ \
    && wget -O /usr/local/src/burp/burp.jar "https://portswigger-cdn.net/burp/releases/download?product=community&version=2022.8.5&type=Jar" \
    && echo "java -Xms2G -Xmx5G -jar /usr/local/src/burp/burp.jar" > /usr/local/bin/burp \
    && chmod +x /usr/local/bin/burp

# zap
RUN mkdir -p /usr/local/src/zap \
    && wget -O /usr/local/src/zap/zap.tar.gz https://github.com/zaproxy/zaproxy/releases/download/v2.11.1/ZAP_2.11.1_Linux.tar.gz \
    && cd /usr/local/src/zap \
    && tar -I pigz -xf ./zap.tar.gz \
    && ln -s /usr/local/src/zap/ZAP_2.11.1/zap.sh /usr/local/bin/zap \
    && rm ./zap.tar.gz

# alacritty
RUN sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" cargo install alacritty
ENV PATH=$PATH:/home/$USERNAME/.cargo/bin

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

# lua-language-server
COPY --from=lua-lsp-build /usr/local/src/lua-language-server /usr/local/src/lua-language-server
RUN ln -s /usr/local/src/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server

# john
COPY --from=john-build /usr/local/src/john /usr/local/src/john
ENV PATH $PATH:/usr/local/src/john/run

# BeEF
RUN mkdir -p /usr/local/src/beef/ \
    && chown $USERNAME:$USERNAME /usr/local/src/beef \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" git clone -b v0.5.4.0 --depth 1 https://github.com/beefproject/beef.git /usr/local/src/beef \
    && cd /usr/local/src/beef/ \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" rbenv local 2.7.2 \
    && bundle install --jobs=$(nproc) \
    && echo -n '#!/bin/bash\ncd /usr/local/src/beef && ./beef' > /usr/local/bin/beef \
    && chmod +x /usr/local/bin/beef \
    && sed -i 's/user:\s*"beef"/user: "'"$USERNAME"'"/' /usr/local/src/beef/config.yaml \
    && sed -i 's/passwd:\s*"beef"/passwd: "changeme"/' /usr/local/src/beef/config.yaml

# golang
RUN mkdir -p /usr/local/src/golang \
    && wget -O /usr/local/src/golang/go.tar.gz https://go.dev/dl/go1.19.1.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf /usr/local/src/golang/go.tar.gz \
    && ln -s /usr/local/go/bin/go /usr/local/bin/go \
    && rm -r /usr/local/src/golang


# gopls
ENV PATH $PATH:/home/$USERNAME/go/bin
RUN mkdir /home/$USERNAME/go \
    && chown $USERNAME:$USERNAME /home/$USERNAME/go \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go install golang.org/x/tools/gopls@latest

# lemonade
RUN sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go install github.com/lemonade-command/lemonade@latest

# ffuf
RUN mkdir -p /usr/local/src/ffuf \
    && wget -O /usr/local/src/ffuf/ffuf.tar.gz https://github.com/ffuf/ffuf/releases/download/v1.4.1/ffuf_1.4.1_linux_amd64.tar.gz \
    && cd /usr/local/src/ffuf \
    && tar -I 'pigz' -xf ./ffuf.tar.gz \
    && ln -s /usr/local/src/ffuf/ffuf /usr/local/bin/ffuf \
    && rm /usr/local/src/ffuf/ffuf.tar.gz

# google-chrome
RUN wget -O /usr/local/src/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i /usr/local/src/google-chrome.deb \
    && rm /usr/local/src/google-chrome.deb

# fix ansible
RUN pip3 install markupsafe==2.0.1

# fix wireshark
RUN groupadd wireshark \
    && usermod -a -G wireshark $USERNAME \
    && chgrp wireshark /usr/bin/dumpcap \
    && chmod 750 /usr/bin/dumpcap \
    && setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

# fix sound
RUN usermod -a -G audio $USERNAME

# chepy
#RUN pip3 install chepy

WORKDIR /home/$USERNAME
ENV HOME /home/$USERNAME
USER $USERNAME


# dotfiles
ENV PATH=$PATH:/home/$USERNAME/tools
COPY --chown=$USERNAME dotfiles ./

# nvim
RUN  mkdir -p ~/.config/nvim/ctags/mytags \
    && .config/nvim/bundle/nvim-typescript/install.sh \
    && nvim --headless +UpdateRemotePlugins +qa \
    && nvim --headless +TSUpdate +qa

CMD ["/usr/bin/byobu"]
