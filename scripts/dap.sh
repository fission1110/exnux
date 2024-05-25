#!/bin/bash

mkdir -p /usr/local/src/debugpy \
    && python3 -m venv /usr/local/src/debugpy \
    && /usr/local/src/debugpy/bin/pip install --upgrade pip \
    && /usr/local/src/debugpy/bin/pip install debugpy

sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go install github.com/go-delve/delve/cmd/dlv@latest
