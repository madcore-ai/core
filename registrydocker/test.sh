#!/bin/bash
cd /opt/controlbox/registrydocker
#mkdir -p /opt/auth
#docker-compose up &
sudo docker run -d ubuntu /bin/sh -c "while true; do echo hello world; sleep 1; done"
#sudo docker run --rm --entrypoint htpasswd registry:2.5 -Bbn indy_user redhat  >> /opt/auth/htpasswd
#sudo docker-compose stop
#sudo docker-compose up &
#sudo docker login -upeter -predhat localhost:5000/
sudo docker tag $(docker images | grep ubuntu | awk '{print $3}') localhost:5000/ubuntu:image
sudo docker push localhost:5000/ubuntu:image
sudo docker stop $(docker ps -q --filter ancestor=ubuntu)
sudo docker rmi -f $(docker images | grep "ubuntu" | awk '{print $3}')
sudo docker pull localhost:5000/ubuntu:image
sudo docker run -d localhost:5000/ubuntu:image /bin/sh -c "while true; do echo hello world; sleep 1; done"
