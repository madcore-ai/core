import json

import redis

r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "apps"

data_apps = [
    {"name": "influxdb", "port": "8083"},
    {"name": "jenkins", "port": "8880"},
    {"name": "kubeapi", "port": "8080"},
    {"name": "kubedash", "port": "8080"},
    {"name": "grafana", "port": "8080"},
    {"name": "spark", "port": "8080"},
    {"name": "zeppelin", "port": "80"},
    {"name": "elasticsearch", "port": "9200"}
]

r_server.set(i_key, json.dumps(data_apps))
r_server.bgsave()
