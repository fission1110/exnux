#!/bin/bash
V_BINSTALL_URL=https://github.com/cargo-bins/cargo-binstall/releases/download/v1.6.8/cargo-binstall-x86_64-unknown-linux-gnu.tgz

mkdir /usr/local/src/cargo-binstall
wget -O /usr/local/src/cargo-binstall/cargo-binstall.tgz $V_BINSTALL_URL
tar -xzf /usr/local/src/cargo-binstall/cargo-binstall.tgz -C /usr/local/src/cargo-binstall
mv /usr/local/src/cargo-binstall/cargo-binstall /usr/local/bin/cargo-binstall
chmod +x /usr/local/bin/cargo-binstall
rm -rf /usr/local/src/cargo-binstall
