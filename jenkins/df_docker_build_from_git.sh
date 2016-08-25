#!/bin/bash
echo "REPO_PATH: '$REPO_PATH'"
echo "REPO_HTTPS: '$REPO_HTTPS'"
echo "WORKSPACE: '$WORKSPACE'"
echo "DOCKER_NAME_LABEL: '$DOCKER_NAME_LABEL'"
git clone $REPO_HTTPS $WORKSPACE
pushd $WORKSPACE/$REPO_PATH
    docker build -t=$DOCKER_NAME_LABEL .
    docker run -d -p 8081:80 --name web my-web-server
    docker tag $(docker images | grep my-web-server | awk '{print $3}') localhost:5000/my-web-server:image
    docker push localhost:5000/my-web-server:image
popd

