#!/bin/bash
#su - jenkins
#su - jenkins bash -c "cd /opt/controlbox/registrydocker; docker-compose up &"i
mkdir -p /opt/auth
sudo docker run --rm --entrypoint htpasswd registry:2.5 -Bbn peter redhat  >> /opt/auth/htpasswd
sudo chmod +x /usr/local/bin/docker-compose
cd /opt/controlbox/registrydocker
sudo docker-compose up &

