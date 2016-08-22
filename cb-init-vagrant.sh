#!/bin/bash 
sudo apt-get update
sudo apt-get install git -y
pushd /opt
    sudo git clone https://bitbucket.org/ronaanimation/controlbox.git
    sudo chown -R ubuntu:ubuntu /opt/controlbox
popd
pushd /opt/controlbox
    sudo git checkout -b development origin/development
    sudo chmod +x cb-install.sh
    sudo bash cb-install.sh
popd
