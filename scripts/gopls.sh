mkdir /home/$USERNAME/go \
    && chown $USERNAME:$USERNAME /home/$USERNAME/go \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go install golang.org/x/tools/gopls@latest
