mkdir -p /usr/local/src/golang \
    && wget -O /usr/local/src/golang/go.tar.gz "${V_GOLANG_URL}" \
    && tar -I pigz -C /usr/local -xf /usr/local/src/golang/go.tar.gz \
    && ln -s /usr/local/go/bin/go /usr/local/bin/go \
    && rm -r /usr/local/src/golang
