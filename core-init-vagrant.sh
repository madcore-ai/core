#!/bin/bash -ex
# Madcore Core (c) 2015-2017 Madcore Ltd on MIT License
# Madcore is a trademark of Madcore Ltd in United Kingdom
# All other trademarks belong to their respective owners

sudo echo ENV=VAGRANT >> /etc/environment
sudo echo MADCORE_BRANCH=$BRANCH_CORE >> /etc/environment
sudo echo MADCORE_COMMIT=FETCH_HEAD >> /etc/environment
sudo echo MADCORE_PLUGINS_BRANCH=$BRANCH_PLUGINS >> /etc/environment
sudo echo MADCORE_PLUGINS_COMMIT=FETCH_HEAD >> /etc/environment

echo 'Installing Madcore Core - Vagrant Edition...'

sudo apt-get update
sudo apt-get install git -y
pushd /opt
    sudo git clone -b $BRANCH_CORE https://github.com/madcore-ai/core.git madcore
    sudo chown -R ubuntu:ubuntu /opt/madcore
popd
pushd /opt/madcore
    sudo git fetch
    sudo git branch -v -a
    sudo chmod +x core-install.sh
    sudo bash core-install.sh
popd
