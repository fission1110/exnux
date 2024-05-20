#!/bin/bash
V_IAITO_URL=https://github.com/radareorg/iaito/releases/download/5.8.8/iaito_5.8.8_amd64.deb
wget -O /iaito.deb "${V_IAITO_URL}" \
  && dpkg -i /iaito.deb \
  && rm /iaito.deb
