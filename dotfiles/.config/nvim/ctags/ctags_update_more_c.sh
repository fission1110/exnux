#!/bin/bash
library=$(pwd)
CTAGS_LOC=~/.config/nvim/ctags/mytags
FILENAME='/main'
cd $library
mkdir -p $CTAGS_LOC$library
exec ctags-exuberant -R -V -f $CTAGS_LOC$library$FILENAME \
	.
#| grep vendors\.*js\.*language
