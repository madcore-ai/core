#!/bin/bash
mkdir /opt/bin
wget -O /opt/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.3.4/bin/linux/amd64/kubectl
chmod +x /opt/bin/kubectl
ln -s /opt/bin/kubectl /usr/local/bin/kubectl
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
sudo chmod +x /usr/local/bin/docker-compose
pushd /opt/madcore/kubernetes/
    cp docker-compose.service /etc/systemd/system/docker-compose-kubernetes.service
    mkdir -p /opt/kubernetes
    cat docker-compose.yml.template | sed -e "s/\${ip}/${ip}/" > /opt/kubernetes/docker-compose.yml
popd

# systemd reload
sudo systemctl daemon-reload

# Enable the service
pushd /etc/systemd/system/
    sudo systemctl enable docker-compose-kubernetes.service
popd

# Start the service
systemctl start docker-compose-kubernetes

