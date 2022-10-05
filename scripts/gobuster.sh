mkdir -p /home/$USERNAME/Wordlists/ \
    && chown $USERNAME:$USERNAME /home/$USERNAME/Wordlists \
    && sudo -u $USERNAME wget -O /home/$USERNAME/Wordlists/kali-wordlists.tar.gz "${V_KALI_WORDLIST_URL}"
