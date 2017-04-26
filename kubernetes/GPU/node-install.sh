#!/bin/bash -v
# Ubuntu Xenial Initialization from Cloud-Init or Vagrant
# From Ubuntu user
# Maintained by Peter Styk (devopsfactory@styk.tv)

sudo echo "${KUB_MASTER_IP} core.madcore" >> /etc/hosts

sudo yum update -y
sudo yum install python python-pip
sudo pip install awscli
echo "copy ssh keys"
sudo su -c "cat /opt/backup/ssh/id_rsa.pub >> ~/.ssh/authorized_keys" ubuntu
sudo cp /opt/backup/docker_ssl/core.madcore.crt /usr/local/share/ca-certificates/core.madcore.crt
sudo update-ca-certificates

echo "Kub Node Setup"

echo  "disable source-destination health check"
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
sudo aws ec2 modify-instance-attribute --instance-id ${INSTANCE_ID} --no-source-dest-check --region ${AWS_REGION}

# PREREQUESITES
pushd /tmp
    sudo yum update -y
    sudo yum install git -y
    sudo curl -fsSL https://get.docker.com/ | sh
    sudo wget https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` -O /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
popd

## flannel
pushd /tmp
  sudo yum install linux-libc-dev golang gcc -y
  wget https://github.com/coreos/flannel/releases/download/v0.7.0/flanneld-amd64
  cp flanneld-amd64 /usr/local/bin/flanneld
  chmod +x /usr/local/bin/flanneld
popd

pushd /opt/madcore/flannel
  cat flanneld_node.service | sed -e "s/\${ip}/$KUB_MASTER_IP/" > /etc/systemd/system/flanneld.service
  cp docker.service /lib/systemd/system/docker.service
popd

systemctl daemon-reload
systemctl start flanneld
systemctl enable flanneld
systemctl restart docker


# PROXY,REGISTRIES, KUBERNETES
sudo bash "/opt/madcore/kubernetes/GPU/setup.sh"
