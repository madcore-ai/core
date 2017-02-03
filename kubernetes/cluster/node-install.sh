#!/bin/bash -v
# Ubuntu Xenial Initialization from Cloud-Init or Vagrant
# From Ubuntu user
# Maintained by Peter Styk (devopsfactory@styk.tv)
sudo apt update -y
sudo apt install python python-pip
sudo pip install awscli
echo "copy ssh keys"
cat /opt/backup/ssh/id_rsa.pub >> ~/.ssh/authorized_keys

echo "Kub Node Setup"

# PREREQUESITES
pushd /tmp
    sudo apt-get update
    sudo apt-get install git -y
    sudo curl -fsSL https://get.docker.com/ | sh
    sudo wget https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` -O /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
popd

# PROXY,REGISTRIES, KUBERNETES
sudo bash "/opt/madcore/kubernetes/cluster/setup.sh"
