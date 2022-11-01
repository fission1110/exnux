#!/bin/bash
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" cargo binstall --no-confirm alacritty
