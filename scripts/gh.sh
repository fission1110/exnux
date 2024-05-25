#!/bin/bash

wget -O /gh.deb https://github.com/cli/cli/releases/download/v2.49.2/gh_2.49.2_linux_amd64.deb \
  && sudo dpkg -i /gh.deb \
  && rm /gh.deb
