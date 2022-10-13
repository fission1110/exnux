#!/bin/bash
#
# Install requirements (docker, docker-compose, git, curl)
# Clone the repo in /usr/local/src/exnux
# Add the exnux command to /usr/local/bin

# Install curl
if ! command -v curl &> /dev/null
then
    sudo apt-get install -y curl
fi

# install docker
if ! command -v docker &> /dev/null
then
    echo "Installing docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh | bash
fi

# install docker-compose
if ! command -v docker-compose &> /dev/null
then
    echo "Installing docker-compose..."
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# install git
if ! command -v git &> /dev/null
then
    echo "Installing git..."
    sudo apt-get install -y git
fi

# if the directory doesn't exist, clone the repo
if [ ! -d "/usr/local/src/exnux" ]; then
    echo "Installing exnux..."
    sudo git clone --recursive https://github.com/fission1110/exnux.git /usr/local/src/exnux
    sudo chown -R $USER:$USER /usr/local/src/exnux
fi

# Install exnux
if [ ! -d "exnux" ]; then
    sudo /bin/bash -c 'echo "#!/bin/bash" > /usr/local/bin/exnux'
    sudo /bin/bash -c 'echo '\''/usr/local/src/exnux/exnux ${@:1}'\'' >> /usr/local/bin/exnux'
    sudo chmod +x /usr/local/bin/exnux
fi
