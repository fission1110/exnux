mkdir -p /usr/local/src/beef/ \
    && chown $USERNAME:$USERNAME /usr/local/src/beef \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" git clone -b "${V_BEEF_BRANCH}" --depth 1 https://github.com/beefproject/beef.git /usr/local/src/beef \
    && cd /usr/local/src/beef/ \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" rbenv local 2.7.2 \
    && bundle install --jobs=$(nproc) \
    && echo -n '#!/bin/bash\ncd /usr/local/src/beef && ./beef' > /usr/local/bin/beef \
    && chmod +x /usr/local/bin/beef \
    && sed -i 's/user:\s*"beef"/user: "'"$USERNAME"'"/' /usr/local/src/beef/config.yaml \
    && sed -i 's/passwd:\s*"beef"/passwd: "changeme"/' /usr/local/src/beef/config.yaml
