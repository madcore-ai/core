#!/bin/bash
if [ ! -f /usr/local/bin/kubectl ]; then
mkdir /opt/bin
wget -O /opt/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.3.4/bin/linux/amd64/kubectl
chmod +x /opt/bin/kubectl
ln -s /opt/bin/kubectl /usr/local/bin/kubectl
fi

mkdir -p /opt/spark
# install spark on the machine
mkdir -p /opt/spark/spark-bin
pushd /tmp
    wget -O spark-bin.tgz http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz
    tar -xf spark-bin.tgz -C /opt/spark/spark-bin --strip-components 1
popd

pushd /opt/controlbox/spark/
    cp namespace-spark-cluster.yaml /opt/spark/namespace-spark-cluster.yaml
    cp spark-master-controller.yaml /opt/spark/spark-master-controller.yaml
    cp spark-master-service.yaml /opt/spark/spark-master-service.yaml
    cp spark-ui-proxy-controller.yaml /opt/spark/spark-ui-proxy-controller.yaml
    cp spark-ui-proxy-service.yaml /opt/spark/spark-ui-proxy-service.yaml
    cp spark-worker-controller.yaml /opt/spark/spark-worker-controller.yaml
    cp zeppelin-controller.yaml /opt/spark/zeppelin-controller.yaml
    cp zeppelin-service.yaml  /opt/spark/zeppelin-service.yaml
popd
kubectl create -f /opt/spark

echo "Waiting for spark (may take few minutes) …"
sudo su -c "until curl -sL -w '%{http_code}' 'http://localhost:8080/api/v1/proxy/namespaces/spark-cluster/services/spark-master:8080/' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
echo “spark  confirmed.”

echo "Waiting for zeppelin (may take few minutes) …"
sudo su -c "until curl -sL -w '%{http_code}' 'http://localhost:8080/api/v1/proxy/namespaces/spark-cluster/services/zeppelin/' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
echo “zeppelin  confirmed.”



