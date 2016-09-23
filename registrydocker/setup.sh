#!/bin/bash
#su - jenkins
#su - jenkins bash -c "cd /opt/controlbox/registrydocker; docker-compose up &"i
mkdir -p /opt/auth
sudo docker run --rm --entrypoint htpasswd registry:2.5 -Bbn peter redhat  >> /opt/auth/htpasswd
sudo chmod +x /usr/local/bin/docker-compose
cd /opt/controlbox/registrydocker
sudo docker-compose up &
cp /opt/controlbox/registrydocker/docker-compose.service /etc/systemd/system/docker-compose.service
# systemd reload
systemctl daemon-reload
# Enable the service
cd /etc/systemd/system/
systemctl enable docker-compose.service
# Start the service
systemctl start docker-compose

