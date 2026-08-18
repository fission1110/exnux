#!/bin/bash
V_FZF_BRANCH=v0.74.2
mkdir -p /usr/local/src/fzf \
    && chown $USERNAME:$USERNAME /usr/local/src/fzf \
    && sudo -u $USERNAME git clone -b "${V_FZF_BRANCH}" --recurse-submodules --depth 1 --shallow-submodules https://github.com/junegunn/fzf.git /usr/local/src/fzf \
    && sudo -u $USERNAME /usr/local/src/fzf/install --bin

