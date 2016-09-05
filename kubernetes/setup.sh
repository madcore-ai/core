#!/bin/bash
sudo chmod +x /usr/local/bin/docker-compose
cd /opt/controlbox/kubernetes
cp /opt/controlbox/kubernetes/docker-compose.service /etc/systemd/system/docker-compose-kubernetes.service
cp /opt/controlbox/kubernetes/docker-compose-dashboard.service /etc/systemd/system/docker-compose-dashboard.service
# systemd reload
systemctl daemon-reload
# Enable the service
cd /etc/systemd/system/
systemctl enable docker-compose-kubernetes.service
systemctl enable docker-compose-dashboard.service
# Start the service
systemctl start docker-compose-kubernetes
systemctl start docker-compose-dashboard

