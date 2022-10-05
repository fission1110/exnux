mkdir -p /usr/local/src/burp/ \
    && wget -O /usr/local/src/burp/burp.jar "${V_BURPSUIT_URL}" \
    && echo "java -Xms2G -Xmx5G -jar /usr/local/src/burp/burp.jar" > /usr/local/bin/burp \
    && chmod +x /usr/local/bin/burp
