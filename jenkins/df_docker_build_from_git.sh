#!/bin/bash
REPO_PATH=/apache
REPO_HTTPS=https://github.com/kstaken/dockerfile-examples.git
WORKSPACE=/web_server
DOCKER_NAME_LABEL=my-web-server
sudo git clone $REPO_HTTPS $WORKSPACE
pushd $WORKSPACE/$REPO_PATH
sudo docker build -t=$DOCKER_NAME_LABEL .
sudo docker run -d -p 443:80 --name web my-web-server
sudo docker tag $(docker images | grep my-web-server | awk '{print $3}') localhost:5000/my-web-server:image
sudo docker push localhost:5000/my-web-server:image

popd

