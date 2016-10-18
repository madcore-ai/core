#!/bin/bash
echo "REPO1_HTTPS: '$REPO1_HTTPS'"
git clone $REPO1_HTTPS /var/lib/jenkins/workspace/df.deploy.kubernetes.test/flask-test
pushd /var/lib/jenkins/workspace/df.deploy.kubernetes.test/flask-test
    docker build -t flask-test .
    docker tag flask-test localhost:5000/flask-test
    docker login -upeter -predhat localhost:5000/
    docker push  localhost:5000/flask-test
    kubectl create secret docker-registry myregistrykey --docker-server=localhost:5000 --docker-username=peter --docker-password=redhat --docker-email=test@test.com
    kubectl create -f /var/lib/jenkins/workspace/df.deploy.kubernetes.test/flask-test/kubernetes
popd
