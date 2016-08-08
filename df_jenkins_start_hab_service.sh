#!/bin/bash

# Give Current System's IP Address to variable
# Option 1
# ip=`ifconfig|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/'`
#Option 2
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
# echo "Inserting IP Address: "$ip

# write toml file with ip address
echo """[cfg.services.core.redis.depot]
start = \"--permanent-peer --peer $ip:9000\"

[cfg.services.core.hab-depot.depot]
start = \"--permanent-peer --bind database:redis.depot,router:hab-depot.depot --peer $ip:9000\"
""" > habitat/hab.director-controlbox.toml

# Copy Files to Proper Locaiton
# Location to Copy Files into /etc/systemd/system
# Copy files to location isskiped coz a sym link is created for it.
cp habitat/systemd-director.service /etc/systemd/system/systemd-director.service
