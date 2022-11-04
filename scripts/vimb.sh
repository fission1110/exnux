#!/bin/bash
#
apt-get update -y \
&& apt-get install -y \
    libgtk-3-dev \
    libwebkit2gtk-4.0-dev \
    'gstreamer1.0-plugins-*' \
    gstreamer1.0-libav

mkdir -p /usr/local/src/vimb
git clone https://github.com/fanglingsu/vimb.git /usr/local/src/vimb/
cd /usr/local/src/vimb/
make
make install
