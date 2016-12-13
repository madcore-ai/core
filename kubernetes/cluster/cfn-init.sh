#!/bin/bash -v

sudo apt-get update
sudo apt-get install -y python-pip
sudo pip install -U pip
sudo pip install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

# TODO make this configurable
sudo /usr/local/bin/cfn-init \
               --stack MADCORE-Cluster \
               --resource MadcoreClusterAutoScalingLaunchConfiguration \
               --configsets ClusterConfig \
               --region eu-west-1
