python3 -m venv /usr/local/src/chepy \
    && /usr/local/src/chepy/bin/pip install wheel \
    && /usr/local/src/chepy/bin/pip install chepy \
    && /usr/local/src/chepy/bin/pip install chepy[extras] \
    && ln -s /usr/local/src/chepy/bin/chepy /usr/local/bin/chepy
