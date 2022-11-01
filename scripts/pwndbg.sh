#!/bin/bash

V_PWNDBG_BRANCH=2022.08.30
mkdir -p /usr/local/src/pwndbg \
    && chown $USERNAME:$USERNAME /usr/local/src/pwndbg \
    && sudo -u $USERNAME git clone -b "${V_PWNDBG_BRANCH}" --recurse-submodules --depth 1 --shallow-submodules https://github.com/pwndbg/pwndbg.git /usr/local/src/pwndbg
