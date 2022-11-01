#!/bin/bash
V_BURPSUIT_URL="https://portswigger-cdn.net/burp/releases/download?product=community&version=2022.9.5&type=Jar"
mkdir -p /usr/local/src/burp/ \
    && wget -O /usr/local/src/burp/burp.jar "${V_BURPSUIT_URL}" \
    && echo "java -Xms2G -Xmx5G -jar /usr/local/src/burp/burp.jar" > /usr/local/bin/burp \
    && chmod +x /usr/local/bin/burp \
    && echo "#!/bin/bash\ntmux setenv http_proxy 'http://localhost:8080/'" > /usr/local/bin/burp-proxy \
    && echo "#!/bin/bash\ntmux setenv http_proxy ''" > /usr/local/bin/burp-noproxy \
    && chmod +x /usr/local/bin/burp-proxy \
    && chmod +x /usr/local/bin/burp-noproxy
