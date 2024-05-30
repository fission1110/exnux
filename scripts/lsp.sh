#!/bin/bash

# go
# gopls
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go install golang.org/x/tools/gopls@latest \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go clean --cache

# lua-language-server
V_LUA_LS_URL=https://github.com/LuaLS/lua-language-server/releases/download/3.9.1/lua-language-server-3.9.1-linux-x64.tar.gz
mkdir /usr/local/src/lua-language-server \
    && wget -O /usr/local/src/lua-language-server.tar.gz "${V_LUA_LS_URL}" \
    && tar -I pigz -C /usr/local/src/lua-language-server -xf /usr/local/src/lua-language-server.tar.gz \
    && sudo chown -R $USERNAME:$USERNAME /usr/local/src/lua-language-server \
    && ln -s /usr/local/src/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server \
    && rm /usr/local/src/lua-language-server.tar.gz

# rust-analyzer
V_RUST_ANALYZER_URL=https://github.com/rust-lang/rust-analyzer/releases/download/2022-10-24/rust-analyzer-x86_64-unknown-linux-gnu.gz
mkdir /usr/local/src/rust-analyzer \
    && cd /usr/local/src/rust-analyzer \
    && wget -O /usr/local/src/rust-analyzer/rust-analyzer.gz ${V_RUST_ANALYZER_URL} \
    && gunzip /usr/local/src/rust-analyzer/rust-analyzer.gz \
    && chmod +x /usr/local/src/rust-analyzer/rust-analyzer \
    && ln -s /usr/local/src/rust-analyzer/rust-analyzer /usr/local/bin/rust-analyzer

# npm
# typescript-language-server, bash-language-server, vscode-langservers-extracted (html, cssls, eslint), ansible-language-server
npm install -g typescript typescript-language-server bash-language-server vscode-langservers-extracted @ansible/ansible-language-server eslint@8.57.0 prettier-eslint prettier-eslint-cli

# pip apt
# ansible, ansible-lint
# Python is too old in Ubuntu 20.04, so we need to install Python 3.10
add-apt-repository ppa:deadsnakes/ppa \
 && add-apt-repository ppa:ansible/ansible \
    && apt-get update -y \
    && apt-get install -y \
        python3.10 \
        python3.10-dev \
        python3.10-venv

# ansible conflicts with python3-yaml, so we need to install ansible and ansible-lint in a venv
# Then we need to create symlinks to the binaries in /usr/local/bin
python3.10 -m venv --upgrade-deps /usr/local/src/ansible \
    && /usr/local/src/ansible/bin/pip install --upgrade pip \
    && /usr/local/src/ansible/bin/pip install ansible ansible-dev-tools

# pyright
pip3 install pyright
