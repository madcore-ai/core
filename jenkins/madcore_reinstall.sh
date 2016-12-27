#!/bin/bash

#delete docker containers and images
docker stop $(docker ps -q)
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -q)

#copy certs
mkdir -p /opt/backup/certs
cp -R /opt/certs /opt/backup/certs

#copy redis base
mkdir /opt/backup/redis
redis-cli save
cp /hab/svc/redis/data/dump.rdb /opt/backup/redis/

#copy registry base
mkdir /opt/backup/dockerstorage
cp -R /opt/dockerstorage /opt/backup/dockerstorage

#delete files
rm -rf /opt/auth
rm -rf /opt/bin
rm -rf /opt/certs
rm -rf /opt/dockerstorage
rm -rf /opt/haproxy
rm -rf /opt/heapster
rm -rf /opt/kubernetes
rm -rf /opt/spark

##delete habitat
#echo "started deleting habitat...."
#pkill -f hab
#rm -rf /var/lib/jenkins/git/habitat
#rm -rf /hab
#echo "habitat deleted"
#sleep 10
#
#
##start new installation
## HABITAT
#sudo su -c "mkdir -p /var/lib/jenkins/git/habitat" jenkins
#sudo su -c "git clone https://github.com/habitat-sh/habitat /var/lib/jenkins/git/habitat" jenkins
#bash /var/lib/jenkins/git/habitat/components/hab/install.sh
#hab install core/hab-sup
#hab install core/redis
#hab install core/hab-depot
#hab install core/hab-director
#hab pkg binlink core/hab-sup hab-sup
#hab pkg binlink core/redis redis-cli
#hab pkg binlink core/hab-depot hab-depot
#hab pkg binlink core/hab-director hab-director
#/opt/madcore/registryhabitat/setup.sh
#sleep 10
#pkill -f hab
#sleep 10
#rm -rf /hab/svc/redis/data/dump.rdb
#cp /opt/backup/redis/dump.rdb /hab/svc/redis/data/dump.rdb
#systemctl start habitat-depot

pushd /opt/madcore
    git pull
popd

# Docker registry
/opt/madcore/registrydocker/setup.sh
docker rm -f registrydocker_registry_1
mv /opt/backup/dockerstorage /opt/dockerstorage
docker stop registrydocker_registry_1
systemctl start docker-compose

# start kubernetes
/opt/madcore/kubernetes/setup.sh

# start heapster
/opt/madcore/heapster/setup.sh

# start spark
/opt/madcore/spark/setup.sh

#restore certs
cp -R /opt/backup/certs /opt/certs

# start haproxy
mkdir -p /opt/haproxy
/opt/madcore/bin/haproxy_get_ssl.py yes
