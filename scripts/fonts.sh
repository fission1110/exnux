#!/bin/bash

mkdir -p /usr/share/fonts/nerd-fonts \
    && wget -O /DejaVuSansMonoNerd.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/DejaVuSansMono.zip \
    && unzip /DejaVuSansMonoNerd.zip -d /usr/share/fonts/nerd-fonts \
    && rm /DejaVuSansMonoNerd.zip \
    && fc-cache -f

