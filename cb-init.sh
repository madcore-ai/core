#!/bin/bash -v
# Devops Factory Pre Configure
# Maintained by Peter Styk (devopsfactory@styk.tv)

# PRECONFIGURE CONTROLBOX
sudo apt-get update
sudo apt-get install git -y
sudo mkdir -p /opt/controlbox
sudo chown ubuntu:ubuntu /opt/controlbox
git clone https://bitbucket.org/ronaanimation/controlbox.git /opt/controlbox
sudo "/opt/controlbox/cb-install.sh"

