INCLUDES=/usr/include
ctags-exuberant -R -V --c++-kinds=+p --fields=+iaS --extra=+q --langmap=c:.h.c --exclude=*.cpp --exclude=*.hpp --exclude=*c++* -f ./systags $INCLUDES
