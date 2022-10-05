wget -O /jd-gui.deb "${V_JD_GUI_URL}" \
    && dpkg -i /jd-gui.deb \
	&& echo "java -Xms2G -Xmx5G -jar /opt/jd-gui/jd-gui.jar" > /usr/local/bin/jd-gui \
	&& chmod +x /usr/local/bin/jd-gui \
    && rm /jd-gui.deb
