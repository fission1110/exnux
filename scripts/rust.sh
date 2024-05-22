#!/bin/bash

V_RUST_ANALYZER_URL=https://github.com/rust-lang/rust-analyzer/releases/download/2022-10-24/rust-analyzer-x86_64-unknown-linux-gnu.gz
# Install the latest version of rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" sh /tmp/rustup.sh -y
rm /tmp/rustup.sh
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" rustup component add rust-src

