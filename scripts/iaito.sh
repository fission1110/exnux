#!/bin/bash
V_IAITO_URL=https://github.com/radareorg/iaito/releases/download/5.9.0/iaito_5.9.0_amd64.deb
wget -O /iaito.deb "${V_IAITO_URL}" \
  && dpkg -i /iaito.deb \
  && rm /iaito.deb
