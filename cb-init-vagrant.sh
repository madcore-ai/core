#!/bin/bash 

sudo echo ENV=VAGRANT >> /etc/environment

echo 'Updating'

sudo apt-get update
sudo apt-get install git -y
pushd /opt
    sudo git clone https://github.com/madcore-ai/core.git madcore
    sudo chown -R ubuntu:ubuntu /opt/madcore
popd
pushd /opt/madcore
    sudo git fetch
    sudo git branch -v -a
    sudo git checkout -b development origin/development
    sudo chmod +x core-install.sh
    sudo bash core-install.sh
popd
