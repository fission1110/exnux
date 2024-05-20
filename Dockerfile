FROM ubuntu:focal AS base

ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

ARG APT_PROXY

ENV V_RBENV_URL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer
WORKDIR /home/$USERNAME

COPY scripts/apt-base.sh /usr/local/src/scripts/apt-base.sh

RUN export http_proxy=$APT_PROXY \
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

RUN export http_proxy=$APT_PROXY \
    && /usr/local/src/scripts/apt-aflpp.sh \
    && unset http_proxy

# build environment should be the newest the distro offers for afl
COPY scripts/aflpp.sh /usr/local/src/scripts/aflpp.sh
RUN /usr/local/src/scripts/aflpp.sh


################################################
#
#    metasploit-build
#
################################################
FROM base AS metasploit-build

COPY scripts/apt-metasploit.sh /usr/local/src/scripts/apt-metasploit.sh
RUN export http_proxy=$APT_PROXY \
    && /usr/local/src/scripts/apt-metasploit.sh \
    && unset http_proxy

COPY scripts/metasploit.sh /usr/local/src/scripts/metasploit.sh
RUN /usr/local/src/scripts/metasploit.sh


################################################
#
#    fzf-build
#
################################################
FROM base AS fzf-build

COPY scripts/fzf.sh /usr/local/src/scripts/fzf.sh
RUN /usr/local/src/scripts/fzf.sh

################################################
#
#    pwndbg-build
#
################################################
FROM base AS pwndbg-build

COPY scripts/pwndbg.sh /usr/local/src/scripts/pwndbg.sh
RUN /usr/local/src/scripts/pwndbg.sh

################################################
#
#    ghidra-build
#
################################################
FROM base AS ghidra-build

COPY scripts/ghidra.sh /usr/local/src/scripts/ghidra.sh
RUN /usr/local/src/scripts/ghidra.sh

################################################
#
#    john-build
#
################################################
FROM base AS john-build

COPY scripts/apt-john.sh /usr/local/src/scripts/apt-john.sh

RUN export http_proxy=$APT_PROXY \
    && /usr/local/src/scripts/apt-john.sh \
    && unset http_proxy

COPY scripts/john.sh /usr/local/src/scripts/john.sh
RUN /usr/local/src/scripts/john.sh

################################################
#
#    phpactor-build
#
################################################
FROM base AS phpactor-build

COPY scripts/phpactor.sh /usr/local/src/scripts/phpactor.sh
RUN /usr/local/src/scripts/phpactor.sh

################################################
#
#    base-extended Adds user tools
#
################################################
FROM base AS base-extended

ENV PATH=$PATH:/home/$USERNAME/.cargo/bin
COPY scripts/apt-base-extended.sh /usr/local/src/scripts/apt-base-extended.sh
COPY scripts/rust.sh /usr/local/src/scripts/rust.sh
RUN export http_proxy=$APT_PROXY \
    && /usr/local/src/scripts/apt-base-extended.sh \
    && unset http_proxy \
    && /usr/local/src/scripts/rust.sh

RUN export http_proxy=$APT_PROXY \
    && apt-get update -y \
    && echo 'y\ny' | unminimize \
    && unset http_proxy \
    && usermod -aG docker $USERNAME \
    && ln -s $(which fdfind) /usr/local/bin/fd \
    && chsh -s $(which zsh) $USERNAME \
    && pip3 install pwntools \
    && pip3 install ipython \
    && pip3 install jedi \
    && pip3 install decompyle3

# nvim
RUN pip3 install neovim \
    && npm install -g neovim \
    && npm install -g typescript typescript-language-server bash-language-server @tailwindcss/language-server \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" cargo install tree-sitter-cli \
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
ENV PATH $PATH:/home/$USERNAME/go/bin

RUN mkdir -p /usr/local/src/scripts/

COPY scripts/cargo-binstall.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/cargo-binstall.sh

COPY scripts/gobuster.sh /usr/local/src/scripts/
COPY scripts/docker-compose.sh /usr/local/src/scripts/
COPY scripts/burpsuit.sh /usr/local/src/scripts/
COPY scripts/zap.sh /usr/local/src/scripts/
COPY scripts/ffuf.sh /usr/local/src/scripts/
COPY scripts/websocat.sh /usr/local/src/scripts/
COPY scripts/procyon.sh /usr/local/src/scripts/
COPY scripts/golang.sh /usr/local/src/scripts/
COPY scripts/chepy.sh /usr/local/src/scripts/
COPY scripts/wabt.sh /usr/local/src/scripts/
COPY scripts/dex2jar.sh /usr/local/src/scripts/
COPY scripts/luarocks.sh /usr/local/src/scripts/
COPY scripts/ai-tools.sh /usr/local/src/scripts/


# These are multi-threaded
RUN parallel --verbose --halt-on-error=2 ::: \
    /usr/local/src/scripts/gobuster.sh \
    /usr/local/src/scripts/docker-compose.sh \
    /usr/local/src/scripts/burpsuit.sh \
    /usr/local/src/scripts/zap.sh \
    /usr/local/src/scripts/ffuf.sh \
    /usr/local/src/scripts/websocat.sh \
    /usr/local/src/scripts/procyon.sh \
    /usr/local/src/scripts/golang.sh \
    /usr/local/src/scripts/chepy.sh \
    /usr/local/src/scripts/wabt.sh \
    /usr/local/src/scripts/dex2jar.sh \
    /usr/local/src/scripts/luarocks.sh \
    /usr/local/src/scripts/ai-tools.sh `# pip`

# dpkg
COPY scripts/radare2.sh /usr/local/src/scripts/
COPY scripts/iaito.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/radare2.sh \
    && /usr/local/src/scripts/iaito.sh

# cargo
COPY scripts/alacritty.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/alacritty.sh

# bundle
COPY scripts/beef.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/beef.sh

# apt, pip, npm, cargo, and go
COPY scripts/formatters.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/formatters.sh

COPY scripts/cli-rice.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/cli-rice.sh

# dpkg
COPY scripts/chromium.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/chromium.sh

# go
COPY scripts/lazygit.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/lazygit.sh

# cargo
COPY scripts/pwninit.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/pwninit.sh

# go
COPY scripts/gopls.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/gopls.sh

# dpkg
COPY scripts/nvim.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/nvim.sh

# go
COPY scripts/lemonade.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/lemonade.sh

# dpkg
COPY scripts/jd-gui.sh /usr/local/src/scripts/
RUN /usr/local/src/scripts/jd-gui.sh

#COPY scripts/vimb.sh /usr/local/src/scripts/
#RUN /usr/local/src/scripts/vimb.sh

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


RUN mkdir -p /run/user/1000 \
    && chown $USERNAME /run/user/1000

COPY scripts/entrypoint.sh /usr/local/src/scripts/
COPY scripts/postgres.sh /usr/local/src/scripts/

WORKDIR /home/$USERNAME
ENV HOME /home/$USERNAME
USER $USERNAME


# dotfiles
ENV PATH=$PATH:/home/$USERNAME/tools
COPY --chown=$USERNAME dotfiles /home/$USERNAME

RUN git clone https://github.com/zsh-users/zsh-autosuggestions /home/$USERNAME/.oh-my-zsh/plugins/zsh-autosuggestions

# nvim
RUN  mkdir -p ~/.config/nvim/ctags/mytags \
    && .config/nvim/bundle/nvim-typescript/install.sh \
    && nvim --headless +Helptags +qa \
    && nvim --headless +UpdateRemotePlugins +qa \
    && nvim --headless +TSUpdate +qa

CMD ["/usr/local/src/scripts/entrypoint.sh"]
