#!/bin/bash
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
sudo chmod +x /usr/local/bin/docker-compose
cd /opt/controlbox/kubernetes
cp /opt/controlbox/kubernetes/docker-compose.service /etc/systemd/system/docker-compose-kubernetes.service
mkdir /kubernetes
cat /opt/controlbox/kubernetes/docker-compose.yml.template | sed -e "s/\${ip}/${ip}/" > /kubernetes/docker-compose.yml
# systemd reload
systemctl daemon-reload
# Enable the service
cd /etc/systemd/system/
systemctl enable docker-compose-kubernetes.service
# Start the service
systemctl start docker-compose-kubernetes
