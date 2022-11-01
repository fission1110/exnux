#!/bin/bash
V_NVIM_URL=https://github.com/neovim/neovim/releases/download/v0.8.0/nvim-linux64.deb
wget -O /neovim.deb "${V_NVIM_URL}" \
    && dpkg -i /neovim.deb \
    && rm /neovim.deb \
    && rm -r /lib/nvim \
    && ln -s /usr/bin/nvim /usr/local/bin/vim
