#!/bin/bash -v
# Madcore Kubernetes Node Pre Configure
# Maintained by Madcore Ltd (humans@madcore.ai)

sudo echo ENV=AWS >> /etc/environment

KUB_MASTER_IP="${KUB_MASTER_IP:-10.99.101.99}"

# disable source-destination health check
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
aws ec2 modify-instance-attribute --instance-id ${INSTANCE_ID} --no-source-dest-check

# PRECONFIGURE madcore
sudo apt-get update
sudo apt-get install git -y
sudo mkdir -p /opt/madcore
sudo chown ubuntu:ubuntu /opt/madcore
git clone https://github.com/madcore-ai/core.git /opt/madcore

sudo chmod +x /opt/madcore/kubernetes/cluster/node-install.sh
sudo "/opt/madcore/kubernetes/cluster/node-install.sh"
