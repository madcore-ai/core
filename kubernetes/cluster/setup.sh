#!/bin/bash
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
mkdir /opt/bin
wget -O /opt/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.3.4/bin/linux/amd64/kubectl
chmod +x /opt/bin/kubectl
ln -s /opt/bin/kubectl /usr/local/bin/kubectl

sudo chmod +x /usr/local/bin/docker-compose

mkdir -p /opt/kubernetes/manifests
chmod +x /opt/madcore/kubernetes/cluster/kubernetes_generate_ssl.sh
/opt/madcore/kubernetes/cluster/kubernetes_generate_ssl.sh

pushd /opt/madcore/kubernetes/cluster/
    sudo cp kubelet.service /etc/systemd/system/kubelet.service
    cat manifests/proxy.yaml | sed -e "s/\${ip}/$KUB_MASTER_IP/" > /opt/kubernetes/manifests/proxy.yaml
popd

# systemd reload
sudo systemctl daemon-reload

# Enable the service
sudo systemctl enable kubelet.service

# Start the service
systemctl start kubelet
