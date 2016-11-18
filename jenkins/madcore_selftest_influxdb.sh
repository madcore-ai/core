#!/bin/bash
echo 'sterted testing InfluxDB'
influxdb=$(curl -sL -w '%{http_code}' 'http://127.0.0.1:8083' -o /dev/null | grep -m 1 '200')

if [ ! -z $influxdb ]; then
echo 'influxdb works'
else
echo 'influxdb down'
curl -L http://127.0.0.1:8083
exit 1
fi

echo 'finished testing InfluxDB'