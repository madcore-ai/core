#!/bin/bash
echo 'sterted testing Docker registry'
registry=$(curl -sLk -w '%{http_code}' 'https://root:madcore@127.0.0.1:5000/v2' -o /dev/null | grep -m 1 '200')

if [ ! -z $registry ]; then
echo 'Docker registry works'
else
echo 'Docker registry down'
curl -Lk https://root:madcore@127.0.0.1:5000/v2
exit 1
fi

echo 'finished testing Docker registry'
