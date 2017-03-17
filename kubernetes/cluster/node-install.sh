#!/bin/bash -v
# Ubuntu Xenial Initialization from Cloud-Init or Vagrant
# From Ubuntu user
# Maintained by Peter Styk (devopsfactory@styk.tv)
sudo apt update -y
sudo apt install python python-pip
sudo pip install awscli
echo "copy ssh keys"
sudo su -c "cat /opt/backup/ssh/id_rsa.pub >> ~/.ssh/authorized_keys" ubuntu

echo "Kub Node Setup"

# PREREQUESITES
pushd /tmp
    sudo apt-get update
    sudo apt-get install git -y
    sudo curl -fsSL https://get.docker.com/ | sh
    sudo wget https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` -O /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
popd

## flannel
pushd /tmp
  apt-get install linux-libc-dev golang gcc
  git clone https://github.com/coreos/flannel.git
    pushd /tmp/flannel
      make dist/flanneld-amd64
      cp dist/flanneld-amd64 /usr/local/bin/flanneld
    popd
popd

pushd /opt/madcore/flannel
  cp flanneld.service /etc/systemd/system/flanneld.service
  cp docker.service /lib/systemd/system/docker.service
popd

systemctl daemon-reload
systemctl start flanneld
systemctl enable flanneld
systemctl restart docker


# PROXY,REGISTRIES, KUBERNETES
sudo bash "/opt/madcore/kubernetes/cluster/setup.sh"
