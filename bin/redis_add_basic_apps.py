import json

import redis

r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "apps"

data_apps = [
    {"name": "jenkins", "namespace": "", "service_name": "","port": "8880"},
    {"name": "kubeapi", "namespace": "", "service_name": "", "port": "8080"},
    {"name": "kubedash", "namespace": "kube-system", "service_name": "kubernetes-dashboard", "port": "80"},
    {"name": "grafana", "namespace": "kube-system", "service_name": "monitoring-grafana", "port": "80"},
    {"name": "spark", "namespace": "spark-cluster", "service_name": "spark-ui-proxy","port": "80"},
    {"name": "zeppelin", "namespace": "spark-cluster", "service_name": "zeppelin", "port": "80"},
    {"name": "elasticsearch", "namespace": "es-cluster", "service_name": "elasticsearch-main", "port": "9200"},
    {"name": "influxdb", "namespace": "kube-system", "service_name": "monitoring-influxdb", "port": "8083"},
    {"name": "influxdb-api", "namespace": "kube-system", "service_name": "monitoring-influxdb", "port": "8086"}
]

r_server.set(i_key, json.dumps(data_apps))
r_server.bgsave()
