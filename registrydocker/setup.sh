#!/bin/bash
sudo mkdir -p /opt/auth
sudo docker run --rm --entrypoint htpasswd registry:2.5 -Bbn root controlbox  >> /opt/auth/htpasswd
size=$(wc -l /opt/auth/htpasswd | grep -o '[0-9]*')
if (($size < 2));
then
sudo htpasswd -b /opt/auth/htpasswd controlbox registrypass
fi
sudo chmod +x /usr/local/bin/docker-compose
sudo cp /opt/controlbox/registrydocker/docker-compose.service /etc/systemd/system/docker-compose.service
# systemd reload
sudo systemctl daemon-reload
# Enable the service
cd /etc/systemd/system/
systemctl enable docker-compose.service
# Start the service
systemctl start docker-compose
