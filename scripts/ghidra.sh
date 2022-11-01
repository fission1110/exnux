#!/bin/bash
V_GHIDRA_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.1.5_build/ghidra_10.1.5_PUBLIC_20220726.zip
mkdir -p /usr/local/src/ghidra \
    && cd /usr/local/src/ghidra \
    && wget -O ghidra.zip "${V_GHIDRA_URL}"\
    && unzip ./ghidra.zip \
    && rm ./ghidra.zip \
    && mv ghidra_*/** ./  \
    && chmod +x ghidraRun
