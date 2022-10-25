mkdir /usr/local/src/rust-analyzer \
    && cd /usr/local/src/rust-analyzer \
    && wget -O /usr/local/src/rust-analyzer/rust-analyzer.gz ${V_RUST_ANALYZER_URL} \
    && gunzip /usr/local/src/rust-analyzer/rust-analyzer.gz \
    && chmod +x /usr/local/src/rust-analyzer/rust-analyzer \
    && ln -s /usr/local/src/rust-analyzer/rust-analyzer /usr/local/bin/rust-analyzer
