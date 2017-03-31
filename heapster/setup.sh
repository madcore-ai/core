#!/bin/bash
if [ ! -f /usr/local/bin/kubectl ]; then
mkdir /opt/bin
wget -O /opt/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.3.4/bin/linux/amd64/kubectl
chmod +x /opt/bin/kubectl
ln -s /opt/bin/kubectl /usr/local/bin/kubectl
fi

echo "Waiting for kubernetes-dashboard (may take few minutes) …"
sudo su -c "until curl -sL -w '%{http_code}' 'http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
echo “kubernetes-dashboard confirmed.”

ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')

mkdir -p /opt/heapster
pushd /opt/madcore/heapster/
   cat heapster-controller.yaml | sed -e "s/\${ip}/${ip}/" > /opt/heapster/heapster-controller.yaml
   cp grafana-service.yaml /opt/heapster/grafana-service.yaml
   cp influxdb-grafana-controller.yaml /opt/heapster/influxdb-grafana-controller.yaml
   cp influxdb-service.yaml /opt/heapster/influxdb-service.yaml
   cp heapster-service.yaml /opt/heapster/heapster-service.yaml
popd

kubectl create -f /opt/heapster

echo "Waiting for monitoring-grafana (may take few minutes) …"
sudo su -c "until curl -sL -w '%{http_code}' 'http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/monitoring-grafana' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
echo “monitoring-grafana confirmed”

# Recongigure haproxy
sudo su -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8880 build madcore.ssl.letsencrypt.getandinstall -p S3BucketName=${S3_BUCKET}" jenkins
