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
    sudo mkdir -p /opt/docker-compose
    cp docker-compose.service /opt/docker-compose/docker-compose-kubernetes.service
    ln -s /opt/docker-compose/docker-compose-kubernetes.service /etc/systemd/system/docker-compose-kubernetes.service
    cat docker-compose.yml.template | sed -e "s/\${ip}/$KUB_MASTER_IP/" | sed -e "s/\${node_ip}/$ip/" | sed -e "s/\${cluster_name}/${KUB_CLUSTER_NAME}/" > /opt/kubernetes/docker-compose.yml
    cat manifests/proxy.yaml | sed -e "s/\${ip}/$KUB_MASTER_IP/" > /opt/kubernetes/manifests/proxy.yaml
popd

# systemd reload
sudo systemctl daemon-reload

# Enable the service
pushd /etc/systemd/system/
    sudo systemctl enable docker-compose-kubernetes.service
popd

# Start the service
systemctl start docker-compose-kubernetes

# Run backup job
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 build madcore.backup -p S3BucketName=${S3_BUCKET}" jenkins
