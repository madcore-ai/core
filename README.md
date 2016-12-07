Welcome to DevopsFactory Controlbox repo
|
         PORT TABLES
----------------------------------------------
   SERVICE      |           PORT
----------------|-----------------------------
docker registry |           5000
etcd            |        7001, 4001
haproxy         |           443
letsencrypt     |           80
kubeapi         |        8080, 6443
influxdb        |     8083, 8086, 8088
grafana         |          3000
redis           |          6379
habitat         |9632. 8000, 8001, 9000, 9001
jenkins         |          8880


cluster/setup.sh - basic setup of cluster (no job for that) this is automatic on launch of cluster cloud formation

spark/setup.sh - master setup of spark - madcore.spark.setup job in jenkins

spark/cluster.sh - cluster setup of spark - madcore.spark.cluster job in jenkins