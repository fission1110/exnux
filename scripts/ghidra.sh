#!/bin/bash
V_GHIDRA_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.0.3_build/ghidra_11.0.3_PUBLIC_20240410.zip
mkdir -p /usr/local/src/ghidra \
    && cd /usr/local/src/ghidra \
    && wget -O ghidra.zip "${V_GHIDRA_URL}"\
    && unzip ./ghidra.zip \
    && rm ./ghidra.zip \
    && mv ghidra_*/** ./  \
    && chmod +x ghidraRun
