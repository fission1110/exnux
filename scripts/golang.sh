#!/bin/bash
V_GOLANG_URL=https://go.dev/dl/go1.19.2.linux-amd64.tar.gz
mkdir -p /usr/local/src/golang \
    && wget -O /usr/local/src/golang/go.tar.gz "${V_GOLANG_URL}" \
    && tar -I pigz -C /usr/local -xf /usr/local/src/golang/go.tar.gz \
    && ln -s /usr/local/go/bin/go /usr/local/bin/go \
    && ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt \
    && rm -r /usr/local/src/golang
