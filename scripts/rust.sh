#!/bin/bash

# Install the latest version of rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" sh /tmp/rustup.sh -y
rm /tmp/rustup.sh
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" rustup component add rust-src

mkdir /usr/local/src/rust-analyzer \
    && cd /usr/local/src/rust-analyzer \
    && wget -O /usr/local/src/rust-analyzer/rust-analyzer.gz ${V_RUST_ANALYZER_URL} \
    && gunzip /usr/local/src/rust-analyzer/rust-analyzer.gz \
    && chmod +x /usr/local/src/rust-analyzer/rust-analyzer \
    && ln -s /usr/local/src/rust-analyzer/rust-analyzer /usr/local/bin/rust-analyzer
