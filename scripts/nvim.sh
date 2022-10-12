wget -O /neovim.deb "${V_NVIM_URL}" \
    && dpkg -i /neovim.deb \
    && rm /neovim.deb \
    && rm -r /lib/nvim \
    && ln -s /usr/bin/nvim /usr/local/bin/vim
