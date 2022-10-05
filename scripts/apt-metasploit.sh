apt-get update -y \
    && apt-get install -y \
        autoconf \
        build-essential \
        git \
        libncurses-dev \
        libpcap-dev \
        libpq-dev \
        libsqlite3-dev \
        libxml2-dev \
        libyaml-dev \
        sqlite3 \
        libsqlite3-dev \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
