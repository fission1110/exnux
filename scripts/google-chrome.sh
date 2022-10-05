wget -O /usr/local/src/google-chrome.deb "${V_GOOGLE_CHROME_URL}" \
    && dpkg -i /usr/local/src/google-chrome.deb \
    && rm /usr/local/src/google-chrome.deb \
    && xdg-settings set default-web-browser google-chrome.desktop
