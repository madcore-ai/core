#!/bin/bash
if pgrep "docker" > /dev/null
then
    echo "Running"
else
    echo "Stopped. Restarting..."
    systemctl restart docker
fi

sudo mkdir -p /opt/auth
sudo docker run --rm --entrypoint htpasswd registry:2.5 -Bbn root madcore  >> /opt/auth/htpasswd
size=$(wc -l /opt/auth/htpasswd | grep -o '[0-9]*')
if (($size < 2));
then
sudo htpasswd -b /opt/auth/htpasswd madcore registrypass
fi
sudo chmod +x /usr/local/bin/docker-compose
sudo cp /opt/madcore/registrydocker/docker-compose.service /etc/systemd/system/docker-compose.service
# systemd reload
sudo systemctl daemon-reload
# Enable the service
cd /etc/systemd/system/
systemctl enable docker-compose.service
# Start the service
systemctl start docker-compose

#restart registry
docker rm -f registrydocker_registry_1
systemctl start docker-compose