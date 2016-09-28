#!/bin/bash
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
sudo chmod +x /usr/local/bin/docker-compose
pushd /opt/controlbox/kubernetes/
   cp docker-compose.service /etc/systemd/system/docker-compose-kubernetes.service
   mkdir -p /opt/kubernetes
   cat docker-compose.yml.template | sed -e "s/\${ip}/${ip}/" > /opt/kubernetes/docker-compose.yml
   cat dashboard.yaml.template | sed -e "s/\${ip}/${ip}/" > /opt/kubernetes/dashboard.yaml
popd
# systemd reload
sudo systemctl daemon-reload
# Enable the service
pushd /etc/systemd/system/
sudo systemctl enable docker-compose-kubernetes.service
popd
# Start the service
sudo systemctl start docker-compose-kubernetes
#
#
#
#  workaround for bug where 1st start info is not acknowledged
sleep 30
kubectl delete -f /opt/kubernetes/dashboard.yaml
kubectl create -f /opt/kubernetes/dashboard.yaml