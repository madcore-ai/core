#!/bin/bash
IP=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
echo "NODE_IP=$IP" >> /etc/environment

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
    sudo cp kubelet.service /etc/systemd/system/kubelet.service
    cp -R manifests /opt/kubernetes
    cp -R addons /opt/kubernetes
    cp -R ssl /opt/kubernetes
popd

# systemd reload
sudo systemctl daemon-reload

# Enable the service
systemctl enable kubelet.service


# Start the service
systemctl start kubelet

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

# Run reconfigure HAproxy
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 build madcore.ssl.letsencrypt.getandinstall -p S3BucketName=${S3_BUCKET}" jenkins

# Run backup job
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 build madcore.backup -p S3BucketName=${S3_BUCKET}" jenkins
