wget -P /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.3.4/bin/linux/amd64/kubectl
chmod +x kubectl
kubectl create -f /opt/controlbox/heapster/influxdb/