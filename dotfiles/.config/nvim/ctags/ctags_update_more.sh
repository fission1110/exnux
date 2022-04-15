#!/bin/bash
LIBRARY=$(pwd)
CTAGS_LOC=~/.config/nvim/ctags/mytags
FILENAME='/main'
cd $LIBRARY
mkdir -p $CTAGS_LOC$LIBRARY
exec ctags-exuberant --fields=+l --langmap=c:.c.h -R -V -f $CTAGS_LOC$LIBRARY$FILENAME \
    -h \".php.ctp\" \
    --exclude=*xml\.js \
    --exclude=*\.svn \
	--exclude=main\-scripts\.js \
	--exclude=exterior\-scripts\.js \
	--exclude=common\-scripts\.js \
	--exclude=Solera\.Templates\.js \
    --totals=yes \
    --tag-relative=yes \
    --PHP-kinds=+cif-jv \
    --regex-PHP='/abstract class ([^ ]*)/\1/c/' \
    --regex-PHP='/interface ([^ ]*)/\1/c/' \
    --regex-PHP='/(public |static |abstract |protected |private )+function ([^ (]*)/\2/f/' \
	--JavaScript-kinds=fcm \
	--langdef=js \
	--langmap=js:.js \
	--regex-js="/(,|(;|^)[ \t]*(var|let|([A-Za-z_$][A-Za-z0-9_$.]+\.)*))[ \t]*([A-Za-z0-9_$]+)[ \t]*=[ \t]*\{/\5/,object/" \
	--regex-js="/(,|(;|^)[ \t]*(var|let|([A-Za-z_$][A-Za-z0-9_$.]+\.)*))[ \t]*([A-Za-z0-9_$]+)[ \t]*=[ \t]*function[ \t]*\(/\5/,function/" \
	--regex-js="/(,|(;|^)[ \t]*(var|let|([A-Za-z_$][A-Za-z0-9_$.]+\.)*))[ \t]*([A-Za-z0-9_$]+)[ \t]*=[ \t]*\[/\5/,array/" \
	--regex-js="/(,|(;|^)[ \t]*(var|let|([A-Za-z_$][A-Za-z0-9_$.]+\.)*))[ \t]*([A-Za-z0-9_$]+)[ \t]*=[ \t]*[^\"]'[^']*/\5/,string/" \
	--regex-js="/(,|(;|^)[ \t]*(var|let|([A-Za-z_$][A-Za-z0-9_$.]+\.)*))[ \t]*([A-Za-z0-9_$]+)[ \t]*=[ \t]*(true|false)/\5/,boolean/" \
	--regex-js="/(,|(;|^)[ \t]*(var|let|([A-Za-z_$][A-Za-z0-9_$.]+\.)*))[ \t]*([A-Za-z0-9_$]+)[ \t]*=[ \t]*[0-9]+/\5/,number/" \
	--regex-js="/(,|(;|^)[ \t]*(var|let|([A-Za-z_$][A-Za-z0-9_$.]+\.)*))[ \t]*([A-Za-z0-9_$]+)[ \t]*=[ \t]*.+([,;=]|$)/\5/,variable/" \
	--regex-js="/(,|(;|^)[ \t]*(var|let|([A-Za-z_$][A-Za-z0-9_$.]+\.)*))[ \t]*([A-Za-z0-9_$]+)[ \t]*[ \t]*([,;]|$)/\5/,variable/" \
	--regex-js="/function[ \t]+([A-Za-z0-9_$]+)[ \t]*\([^)]*\)/\1/,function/" \
	--regex-js="/(,|^)[ \t]*([A-Za-z_$][A-Za-z0-9_$]+)[ \t]*:[ \t]*\{/\2/,object/" \
	--regex-js="/(,|^)[ \t]*([A-Za-z_$][A-Za-z0-9_$]+)[ \t]*:[ \t]*function[ \t]*\(/\2/,function/" \
	--regex-js="/(,|^)[ \t]*([A-Za-z_$][A-Za-z0-9_$]+)[ \t]*:[ \t]*\[/\2/,array/" \
	--regex-js="/(,|^)[ \t]*([A-Za-z_$][A-Za-z0-9_$]+)[ \t]*:[ \t]*[^\"]'[^']*/\2/,string/" \
	--regex-js="/(,|^)[ \t]*([A-Za-z_$][A-Za-z0-9_$]+)[ \t]*:[ \t]*(true|false)/\2/,boolean/" \
	--regex-js="/(,|^)[ \t]*([A-Za-z_$][A-Za-z0-9_$]+)[ \t]*:[ \t]*[0-9]+/\2/,number/" \
	--regex-js="/(,|^)[ \t]*([A-Za-z_$][A-Za-z0-9_$]+)[ \t]*:[ \t]*[^=]+([,;]|$)/\2/,variable/" \
#| grep vendors\.*js\.*language
