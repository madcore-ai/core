#!/bin/bash
echo 'sterted testing kubernetes dashboard'
kubedash=$(curl -sL -w '%{http_code}' 'http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard' -o /dev/null | grep -m 1 '200')

if [ ! -z $kubedash ]; then
echo 'kubernetes doshboard works'
else
echo 'kubernetes dashboard down'
fi

echo 'finished testing kubernetes dashboard'