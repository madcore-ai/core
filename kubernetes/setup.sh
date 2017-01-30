#!/bin/bash
mkdir /opt/bin
pushd /opt/bin
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
popd
chmod +x /opt/bin/kubectl
ln -s /opt/bin/kubectl /usr/local/bin/kubectl
sudo curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)"
sudo chmod +x /usr/local/bin/docker-compose

mkdir -p /opt/kubernetes/
chmod +x /opt/madcore/kubernetes/kubernetes_generate_ssl.sh
/opt/madcore/kubernetes/kubernetes_generate_ssl.sh

pushd /opt/madcore/kubernetes/
    cp docker-compose.service /etc/systemd/system/docker-compose-kubernetes.service
    cp docker-compose.yml.template  /opt/kubernetes/docker-compose.yml
    cp -R manifests /opt/kubernetes
    cp -R addons /opt/kubernetes
    cp -R ssl /opt/kubernetes
popd

# systemd reload
sudo systemctl daemon-reload

# Enable the service
pushd /etc/systemd/system/
    sudo systemctl enable docker-compose-kubernetes.service
popd

# Start the service
systemctl start docker-compose-kubernetes

# wait kubernetes api
echo "waiting kubernetes api...."
sleep 20
count=0
until [[ $count > 3 ]]; do
    if [[ $(curl -sL -w '%{http_code}' 'http://localhost:8080/' -o /dev/null | grep -m 1 '200') ]]; then
	((count++))
    fi
    sleep 10
done
echo "kubernetes api server is ready"
# Start dashboard and dns

kubectl create -f /opt/kubernetes/addons
