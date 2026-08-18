#!/bin/bash
V_NVIM_URL=https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
wget -O /nvim-linux-x86_64.tar.gz "${V_NVIM_URL}" \
    && mkdir /usr/local/src/nvim \
    && tar -I pigz -C /usr/local/src/nvim -xf /nvim-linux-x86_64.tar.gz \
    && cp -r /usr/local/src/nvim/nvim-linux-x86_64/* /usr/local/ \
    && rm /nvim-linux-x86_64.tar.gz
