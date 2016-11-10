#!/bin/bash
echo 'sterted testing services'
kubeapi=$(curl -sL -w '%{http_code}' 'http://127.0.0.1:8080' -o /dev/null | grep -m 1 '200')
kubedash=$(curl -sL -w '%{http_code}' 'http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard' -o /dev/null | grep -m 1 '200')
grafana=$(curl -sL -w '%{http_code}' 'http://127.0.0.1:8080/api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/' -o /dev/null | grep -m 1 '200')
influxdb=$(curl -sL -w '%{http_code}' 'http://127.0.0.1:8083' -o /dev/null | grep -m 1 '200')
redis=$(redis-cli ping)

if [ ! -z $kubeapi ]; then
echo 'kubernetes works'
else
echo 'kubernetes down'
fi

if [ ! -z $kubedash ]; then
echo 'kubernetes doshboard works'
else
echo 'kubernetes dashboard down'
fi

if [ ! -z $grafana ]; then
echo 'grafana works'
else
echo 'grafana down'
fi

if [ ! -z $influxdb ]; then
echo 'influxdb works'
else
echo 'influxdb down'
fi

if [ "$redis" == "PONG" ]; then
echo 'redis works'
else
echo 'redis down'
fi

echo 'finished testing services'