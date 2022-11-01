#!/bin/bash
# asm asmfmt
# (c, c#, c++) clang-format
# (cmake) cmake_format
# (html, css, scss, js, ts, md, yaml) prettier
# (go) gofmt
# (csv, xml) prettydiff
# (json) jq
# (lua) stylua
# (perl) perltidy
# (python) black
# (zsh) shfmt
# (rust) rustfmt
# (java) uncrustify
# (php) phpcbf

apt-get update -y \
    && apt-get install -y \
        jq \
        perltidy \
        uncrustify \
        php-pear

pip3 install \
    black \
    cmakelang \
    prettydiff \
    sqlfmt

npm install -g prettier shfmt

sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" cargo binstall --no-confirm stylua rustfmt

go install github.com/klauspost/asmfmt/cmd/asmfmt@latest \
    && go clean --cache

pear install PHP_CodeSniffer
