#!/bin/bash
echo 'sterted testing kubernetes API'
kubeapi=$(curl -sL -w '%{http_code}' 'http://127.0.0.1:8080' -o /dev/null | grep -m 1 '200')

if [ ! -z $kubeapi ]; then
echo 'kubernetes works'
else
echo 'kubernetes down'
curl -L -w http://127.0.0.1:8080
exit 1
fi

echo 'finished testing kubernetes API'