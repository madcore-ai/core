import redis

r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "apps"

i_data = '[{"name":"madcore", "port":"8880"},{"name":"influxdb", "port" :"8086"},{"name":"jenkins", "port" :"8880"},{"name":"kubeapi", "port" :"8080"},{"name":"kubedash", "port" :"8080"},{"name":"grafana", "port" :"8080"}, {"name":"spark", "port":"8080"}, {"name":"zeppelin", "port":"80"}]'
r_server.set(i_key, i_data)
r_server.bgsave
