#!/bin/bash
sudo chmod +x /usr/local/bin/docker-compose
cd /opt/controlbox/kubernetes
cp /opt/controlbox/kubernetes/docker-compose.service /etc/systemd/system/docker-compose-kubernetes.service
# systemd reload
systemctl daemon-reload
# Enable the service
cd /etc/systemd/system/
systemctl enable docker-compose-kubernetes.service
# Start the service
systemctl start docker-compose-kubernetes

