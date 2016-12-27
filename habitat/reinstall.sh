#!/usr/bin/env bash

bash /opt/madcore/habitat/delete.sh
bash /opt/madcore/habitat/install.sh
bash /opt/madcore/habitat/registry/setup.sh

sleep 10
pkill -f hab
sleep 10
rm -rf /hab/svc/redis/data/dump.rdb
cp /opt/backup/redis/dump.rdb /hab/svc/redis/data/dump.rdb
systemctl start habitat-depot
