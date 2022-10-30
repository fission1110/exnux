sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go install github.com/lemonade-command/lemonade@latest \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go clean --cache
