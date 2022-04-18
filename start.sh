# DISPLAY=:50
# XAUTHORITY=/home/$USER/.Xauthority

# SYS_PTRACE for GDB and r2. seccom=unconfined for C++ debugging
# /dev/dri for amd/ati gpu acceleration

# echo "/tmp/cores/core.%e.%p.%h.%t" > /proc/sys/kernel/core_pattern

docker run --rm -it -d --name exnux \
	--cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
	-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $PWD/dotfiles:/home/nonroot \
	-v $HOME/.Xauthority:/home/nonroot/.Xauthority \
	-e "XAUTHORITY=/home/nonroot/.Xauthority" \
	-h "$(hostname)" \
	-e "DISPLAY=$DISPLAY" \
	--device /dev/dri \
	-v $HOME:/home/nonroot/home-host \
	exnux:v0.1 /bin/bash

docker exec -it exnux /usr/bin/byobu
