job('df.redis.owner.update') {
    parameters {
        stringParam('Repo_HTTPS', '', '')
    }
    steps {
        def command = """#!/bin/bash
echo "Repo_HTTPS: '\$REPO_HTTPS'"
git clone $REPO_HTTPS /opt/flask-test
pushd /opt/flask-test
    docker build -t flask-test .
    docker tag flask-test localhost:5000/flask-test
    docker login -upeter -predhat localhost:5000/
    docker push  localhost:5000/flask-test
    kubectl create secret docker-registry myregistrykey --docker-server=localhost:5000 --docker-username=peter --docker-password=redhat --docker-email=test@test.com
    kubectl create -f /opt/flask-test/kubernetes

"""
        shell(command)
    }
}
