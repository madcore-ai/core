#!/bin/bash
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
mkdir -p /opt/heapster
cat /opt/controlbox/heapster/influxdb/heapster-controller.yaml | sed -e "s/\${ip}/${ip}/" > /opt/heapster/heapster-controller.yaml
cp /opt/controlbox/heapster/influxdb/grafana-service.yaml /opt/heapster/grafana-service.yaml
cp /opt/controlbox/heapster/influxdb/influxdb-grafana-controller.yaml /opt/heapster/influxdb-grafana-controller.yaml
cp /opt/controlbox/heapster/influxdb/influxdb-service.yaml /opt/heapster/influxdb-service.yaml
cp /opt/controlbox/heapster/influxdb/heapster-service.yaml /opt/heapster/heapster-service.yaml
kubectl create -f /opt/heapster