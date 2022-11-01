#!/bin/bash
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" cargo install pwninit
