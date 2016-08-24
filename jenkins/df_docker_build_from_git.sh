#!/bin/bash 
sudo apt-get update
sudo apt-get install git -y
pushd /opt
    sudo git clone https://bitbucket.org/ronaanimation/controlbox.git
    sudo chown -R ubuntu:ubuntu /opt/controlbox
popd
pushd /opt/controlbox
    sudo git checkout -b development origin/development
    cd /opt/controlbox/
    sudo docker run -d ubuntu /bin/sh
    docker tag $(docker images | grep ubuntu | awk '{print $3}') localhost:5000/ubuntu:test
    docker push localhost:5000/ubuntu:test
popds
 
