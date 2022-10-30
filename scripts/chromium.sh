add-apt-repository ppa:system76/pop
apt-get install -y chromium libavcodec-extra
update-alternatives --config x-www-browser /usr/bin/chromium
update-alternatives --config gnome-www-browser /usr/bin/chromium
sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" xdg-settings set default-web-browser chromium.desktop

echo "Package: *
Pin: release o=LP-PPA-system76-pop
Pin-Priority: 400" > /etc/apt/preferences.d/system76-pop
