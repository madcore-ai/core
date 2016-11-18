#!/bin/bash
if [ ! -f /usr/local/bin/kubectl ]; then
mkdir /opt/bin
wget -O /opt/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.3.4/bin/linux/amd64/kubectl
chmod +x /opt/bin/kubectl
ln -s /opt/bin/kubectl /usr/local/bin/kubectl
fi

echo "Waiting for kubernetes-dashboard (may take few minutes) …"
sudo su -c "until curl -sL -w '%{http_code}' 'http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
echo “kubernetes-dashboard confirmed.”

ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')

mkdir -p /opt/spark
pushd /opt/controlbox/spark/
    cp namespace-spark-cluster.yaml /opt/spark/namespace-spark-cluster.yaml
    cp spark-master-controller.yaml /opt/spark/spark-master-controller.yaml
    cp spark-master-service.yaml /opt/spark/spark-master-service.yaml
    cp spark-ui-proxy-controller.yaml /opt/spark/spark-ui-proxy-controller.yaml
    cp spark-worker-controller.yaml /opt/spark/spark-worker-controller.yaml
    cp zeppelin-controller.yaml /opt/spark/zeppelin-controller.yaml
popd
kubectl create -f /opt/spark/namespace-spark-cluster.yaml
CURRENT_CONTEXT=$(kubectl config view -o jsonpath='{.current-context}')
USER_NAME=$(kubectl config view -o jsonpath='{.contexts[?(@.name == "'"${CURRENT_CONTEXT}"'")].context.user}')
CLUSTER_NAME=$(kubectl config view -o jsonpath='{.contexts[?(@.name == "'"${CURRENT_CONTEXT}"'")].context.cluster}')
kubectl config set-context spark --namespace=spark-cluster --cluster=${CLUSTER_NAME} --user=${USER_NAME}
kubectl config use-context spark
kubectl create -f /opt/spark/spark-master-controller.yaml
kubectl create -f /opt/spark/spark-master-service.yaml
kubectl create -f /opt/spark/spark-ui-proxy-controller.yaml
kubectl create -f /opt/spark/spark-worker-controller.yaml
kubectl create -f /opt/spark/zeppelin-controller.yaml


