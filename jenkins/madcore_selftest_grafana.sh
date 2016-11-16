#!/bin/bash
echo 'sterted testing Grafana dashboard'
grafana=$(curl -sL -w '%{http_code}' 'http://127.0.0.1:8080/api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/' -o /dev/null | grep -m 1 '200')

if [ ! -z $grafana ]; then
echo 'grafana works'
else
echo 'grafana down'
exit 1
fi

echo 'finished testing Grafana Dashboard'