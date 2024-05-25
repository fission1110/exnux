#!/bin/bash

# Install debugpy for Python
mkdir -p /usr/local/src/debugpy \
    && python3 -m venv /usr/local/src/debugpy \
    && /usr/local/src/debugpy/bin/pip install --upgrade pip \
    && /usr/local/src/debugpy/bin/pip install debugpy

# Install delve for Go
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go install github.com/go-delve/delve/cmd/dlv@latest

# Install lldb for C/C++/Rust
apt-get -y install lldb-9

# Install vscode-php-debug for PHP
git clone https://github.com/xdebug/vscode-php-debug.git /usr/local/src/vscode-php-debug \
    && cd /usr/local/src/vscode-php-debug \
    && npm install && npm run build
