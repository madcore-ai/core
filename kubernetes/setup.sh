#!/bin/bash
sudo chmod +x /usr/local/bin/docker-compose
cd /opt/controlbox/kubernetes
sudo docker-compose up &

