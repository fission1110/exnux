#!/bin/bash
V_PROCYON_URL=https://github.com/mstrobel/procyon/releases/download/v0.6.0/procyon-decompiler-0.6.0.jar
mkdir -p /usr/local/src/procyon \
    && wget -O /usr/local/src/procyon/procyon-decompiler.jar "${V_PROCYON_URL}" \
	&& echo 'java -Xms2G -Xmx5G -jar /usr/local/src/procyon/procyon-decompiler.jar $@' > /usr/local/bin/procyon \
    && chmod +x /usr/local/bin/procyon
