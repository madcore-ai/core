#!/bin/bash -v
# Madcore Kubernetes Node Pre Configure
# Maintained by Madcore Ltd (humans@madcore.ai)

sudo echo ENV=AWS >> /etc/environment

KUB_MASTER_IP="${KUB_MASTER_IP:-10.99.101.99}"

# PRECONFIGURE CONTROLBOX
sudo apt-get update
sudo apt-get install git -y
sudo mkdir -p /opt/controlbox
sudo chown ubuntu:ubuntu /opt/controlbox
git clone https://bitbucket.org/ronaanimation/controlbox.git /opt/controlbox

sudo chmod +x /opt/controlbox/kubernetes/cluster/cfn-init.sh
sudo "/opt/controlbox/kubernetes/cluster/cfn-init.sh"

sudo chmod +x /opt/controlbox/kubernetes/cluster/node-install.sh
sudo "/opt/controlbox/kubernetes/cluster/node-install.sh"
