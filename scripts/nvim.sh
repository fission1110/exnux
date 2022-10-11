wget -O /neovim.deb "${V_NVIM_URL}" \
    && dpkg -i /neovim.deb \
    && rm /neovim.deb \
    && rm -r /lib/nvim
