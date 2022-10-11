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
ENV V_NVIM_URL https://github.com/neovim/neovim/releases/download/v0.8.0/nvim-linux64.deb
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
ENV V_GOBUSTER_URL https://github.com/OJ/gobuster/releases/download/v3.2.0/gobuster_3.2.0_Linux_x86_64.tar.gz
ENV V_FRIDA_VERSION 15.2.2
ENV V_FRIDA_TOOLS_VERSION 11.0.0

COPY scripts/apt-base.sh /usr/local/src/scripts/apt-base.sh

RUN chmod +x /usr/local/src/scripts/apt-base.sh \
    && export http_proxy=$APT_PROXY \
    && /usr/local/src/scripts/apt-base.sh \
    && unset http_proxy \
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

COPY scripts/apt-aflpp.sh /usr/local/src/scripts/apt-aflpp.sh

RUN chmod +x /usr/local/src/scripts/apt-aflpp.sh \
    && export http_proxy=$APT_PROXY \
    && /usr/local/src/scripts/apt-aflpp.sh \
    && unset http_proxy

# build environment should be the newest the distro offers for afl
COPY scripts/aflpp.sh /usr/local/src/scripts/aflpp.sh
RUN chmod +x /usr/local/src/scripts/aflpp.sh \
    && /usr/local/src/scripts/aflpp.sh


################################################
#
#    metasploit-build
#
################################################
FROM base AS metasploit-build

COPY scripts/apt-metasploit.sh /usr/local/src/scripts/apt-metasploit.sh
RUN chmod +x /usr/local/src/scripts/apt-metasploit.sh \
    && export http_proxy=$APT_PROXY \
    && /usr/local/src/scripts/apt-metasploit.sh \
    && unset http_proxy

COPY scripts/metasploit.sh /usr/local/src/scripts/metasploit.sh
RUN chmod +x /usr/local/src/scripts/metasploit.sh \
    && /usr/local/src/scripts/metasploit.sh


################################################
#
#    fzf-build
#
################################################
FROM base AS fzf-build

COPY scripts/fzf.sh /usr/local/src/scripts/fzf.sh
RUN chmod +x /usr/local/src/scripts/fzf.sh \
    && /usr/local/src/scripts/fzf.sh

################################################
#
#    pwndbg-build
#
################################################
FROM base AS pwndbg-build

COPY scripts/pwndbg.sh /usr/local/src/scripts/pwndbg.sh
RUN chmod +x /usr/local/src/scripts/pwndbg.sh \
    && /usr/local/src/scripts/pwndbg.sh

################################################
#
#    ghidra-build
#
################################################
FROM base AS ghidra-build

COPY scripts/ghidra.sh /usr/local/src/scripts/ghidra.sh
RUN chmod +x /usr/local/src/scripts/ghidra.sh \
    && /usr/local/src/scripts/ghidra.sh

################################################
#
#    john-build
#
################################################
FROM base AS john-build

COPY scripts/apt-john.sh /usr/local/src/scripts/apt-john.sh

RUN chmod +x /usr/local/src/scripts/apt-john.sh \
    && export http_proxy=$APT_PROXY \
    && /usr/local/src/scripts/apt-john.sh \
    && unset http_proxy

COPY scripts/john.sh /usr/local/src/scripts/john.sh
RUN chmod +x /usr/local/src/scripts/john.sh \
    && /usr/local/src/scripts/john.sh

################################################
#
#    phpactor-build
#
################################################
FROM base AS phpactor-build

COPY scripts/phpactor.sh /usr/local/src/scripts/phpactor.sh
RUN chmod +x /usr/local/src/scripts/phpactor.sh \
    && /usr/local/src/scripts/phpactor.sh

################################################
#
#    base-extended Adds user tools
#
################################################
FROM base AS base-extended

COPY scripts/apt-base-extended.sh /usr/local/src/scripts/apt-base-extended.sh
RUN chmod +x /usr/local/src/scripts/apt-base-extended.sh \
    && export http_proxy=$APT_PROXY \
    && /usr/local/src/scripts/apt-base-extended.sh \
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

################################################
#
#    base-final Builds the final image
#
################################################
FROM base-extended AS base-final

# metasploit
COPY --from=metasploit-build --chown=$USERNAME /usr/local/src/metasploit-framework /usr/local/src/metasploit-framework
COPY --from=metasploit-build --chown=$USERNAME /home/$USERNAME/.rbenv /home/$USERNAME/.rbenv

# aflpp
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

COPY scripts/* /usr/local/src/scripts/
RUN chmod +x /usr/local/src/scripts/*.sh

# Single threaded because they rely on dpkg run lock
RUN /usr/local/src/scripts/radare2.sh \
    && /usr/local/src/scripts/iaito.sh \
    && /usr/local/src/scripts/nvim.sh \
    && /usr/local/src/scripts/google-chrome.sh

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
RUN /usr/local/src/scripts/gopls.sh \
    && /usr/local/src/scripts/lemonade.sh \
    && /usr/local/src/scripts/lazygit.sh

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
