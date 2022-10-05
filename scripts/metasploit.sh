mkdir -p /usr/local/src/metasploit-framework \
    && chown $USERNAME:$USERNAME /usr/local/src/metasploit-framework \
    && sudo -u $USERNAME git clone -b "${V_METASPLOIT_BRANCH}" --recurse-submodules --depth 1 --shallow-submodules https://github.com/rapid7/metasploit-framework.git /usr/local/src/metasploit-framework && \
    `# gem install and bundle install` \
    cd /usr/local/src/metasploit-framework \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" rbenv install 3.0.2 \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" rbenv install 2.7.2 \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" rbenv global 3.0.2 \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" gem update --system \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" gem install --no-user-install bundler \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" gem install --no-user-install wpscan \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" bundle install --jobs=$(nproc)
