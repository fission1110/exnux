#!/bin/bash
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go install golang.org/x/tools/gopls@latest \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go clean --cache
