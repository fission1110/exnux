#!/bin/bash
CMD=$1
# DISPLAY=:50
# XAUTHORITY=/home/$USER/.Xauthority

# SYS_PTRACE for GDB and r2. seccom=unconfined for C++ debugging
# /dev/dri for amd/ati gpu acceleration

# echo "/tmp/cores/core.%e.%p.%h.%t" > /proc/sys/kernel/core_pattern

USERNAME=nonroot
case $CMD in
	build)
		docker build -t exnux:v0.1 .
	;;
	build-apt-cache)
		docker run --name apt-cacher-ng --init -d --restart=always \
			-p 172.17.0.1:3142:3142 \
			--volume /srv/docker/apt-cacher-ng:/var/cache/apt-cacher-ng \
			sameersbn/apt-cacher-ng:3.3-20200524
			docker build -t exnux:v0.1 --add-host host.docker.internal:172.17.0.1 --build-arg=APT_PROXY="http://host.docker.internal:3142" .
	;;
	start)
		$0 net
		docker run --rm -it -d --name exnux --network exnux-net \
			--cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
			-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
			-v $PWD/dotfiles:/home/$USERNAME \
			-v $HOME/.Xauthority:/home/$USERNAME/.Xauthority \
			-e "XAUTHORITY=/home/$USERNAME/.Xauthority" \
			-h "$(hostname)" \
			-e "DISPLAY=$DISPLAY" \
			--device /dev/dri \
			-v $HOME:/home/$USERNAME/home-host \
			exnux:v0.1 /bin/bash
			docker exec -it exnux /usr/bin/byobu
	;;
	msf-postgres)
		docker run --name msf-postgres --network exnux-net \
			-e POSTGRES_PASSWORD=msf \
			-e POSTGRES_USER=msf \
			-e POSTGRES_DB=msf \
			-v $PWD/pgdata:/var/lib/postgresql/data \
			-d postgres:14.2 

		docker exec -it exnux /usr/local/src/metasploit-framework/msfdb init --connect-string=postgresql://msf:msf@msf-postgres:5432/msf
	;;
	net)
		docker network create exnux-net 2> /dev/null
	;;
	clean)
		docker stop msf-postgres
		docker rm msf-postgres
		docker stop exnux
		docker stop apt-cacher-ng
		docker rm apt-cacher-ng
	;;
	*)
		echo "$0 build|start|clean|net|build-apt-cache"
	;;
esac
