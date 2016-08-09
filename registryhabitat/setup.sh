#!/bin/bash

# Give Current System's IP Address to variable
# Option 1
# ip=`ifconfig|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/'`
#Option 2
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
# echo "Inserting IP Address: "$ip

# write toml file with ip address
cat /opt/controlbox/registryhabitat/hab.director-controlbox.toml.template  | sed -e "s/\${ip}/${ip}/" >  /opt/controlbox/registryhabitat/hab.director-controlbox.toml

# Service Setup
# Copy Files to Proper Locaiton
# Location to Copy Files into /etc/systemd/system
cp /opt/controlbox/registryhabitat/habitat-depot.service /etc/systemd/system/habitat-depot.service

# systemd reload
systemctl daemon-reload
# Enable the service
systemctl enable habitat-depot.service
# Start the service
systemctl start habitat-depot
