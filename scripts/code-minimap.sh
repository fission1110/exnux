#!/bin/bash
wget -O /code-minimap.deb "${V_CODE_MINIMAP_URL}" \
    && dpkg -i /code-minimap.deb \
    && rm /code-minimap.deb
