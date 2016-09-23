#!/bin/bash
if [ -f /opt/kubectl ];
then
    echo "file exist"
else
wget https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl -P /opt
fi
chmod +x /opt/kubectl
docker pull hello-world
docker tag hello-world localhost:5000/hello-node
docker push localhost:5000/hello-node
docker rmi localhost:5000/hello-node
/opt/kubectl run hello-node --image=localhost:5000/hello-node
/opt/kubectl get deployments
exit 0
