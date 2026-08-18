#!/bin/bash
add-apt-repository ppa:xtradeb/apps -y
apt-get install -y chromium libavcodec-extra
update-alternatives --config x-www-browser /usr/bin/chromium
update-alternatives --config gnome-www-browser /usr/bin/chromium
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" xdg-settings set default-web-browser chromium.desktop
