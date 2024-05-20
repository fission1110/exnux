#!/bin/bash
V_NVIM_URL=https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz
wget -O /nvim-linux64.tar.gz "${V_NVIM_URL}" \
    && mkdir /usr/local/src/nvim \
    && tar -I pigz -C /usr/local/src/nvim -xf /nvim-linux64.tar.gz \
    && cp -r /usr/local/src/nvim/nvim-linux64/* /usr/local/ \
    && rm /nvim-linux64.tar.gz
