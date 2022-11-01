#!/bin/bash
V_JD_GUI_URL=https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6.deb
wget -O /jd-gui.deb "${V_JD_GUI_URL}" \
    && dpkg -i /jd-gui.deb \
	&& echo "java -Xms2G -Xmx5G -jar /opt/jd-gui/jd-gui.jar" > /usr/local/bin/jd-gui \
	&& chmod +x /usr/local/bin/jd-gui \
    && rm /jd-gui.deb
