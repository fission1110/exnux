#!/bin/bash
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" cargo install alacritty \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" cargo cache -a
