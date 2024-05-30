#!/bin/bash
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go install github.com/lemonade-command/lemonade@latest \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" go clean --cache \
    && echo "#!/bin/bash" > /usr/local/bin/ssh_connected \
    && echo 'touch ~/.ssh_connected' >> /usr/local/bin/ssh_connected \
    && chmod +x /usr/local/bin/ssh_connected \
    && echo "#!/bin/bash" > /usr/local/bin/ssh_disconnected \
    && echo 'rm -f ~/.ssh_connected' >> /usr/local/bin/ssh_disconnected \
    && chmod +x /usr/local/bin/ssh_disconnected

