#!/bin/bash
library=$(pwd)
CTAGS_LOC=~/.config/nvim/ctags/mytags
FILENAME='/main.cpp'
cd $library
mkdir -p $CTAGS_LOC$library
exec ctags-exuberant -R -V -f $CTAGS_LOC$library$FILENAME \
	--fields=+l \
	--langmap=c:.c.h \
    --totals=yes \
    --tag-relative=yes \
	.
#| grep vendors\.*js\.*language
