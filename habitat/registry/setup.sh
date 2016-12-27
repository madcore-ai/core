#!/bin/bash

# Give Current System's IP Address to variable
# Option 1
# ip=`ifconfig|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/'`
#Option 2
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
# echo "Inserting IP Address: "$ip

# write toml file with ip address
# write directly to proper folder, do not ever write anything into repo folder as it will conflict later with pulls
mkdir -p /hab/svc/hab-director
cat /opt/madcore/habitat/registry/hab.director-madcore.toml.template  | sed -e "s/\${ip}/${ip}/" >  /hab/svc/hab-director/madcore.toml

# Service Setup
# Copy Files to Proper Locaiton
# Location to Copy Files into /etc/systemd/system
cp /opt/madcore/habitat/registry/habitat-depot.service /etc/systemd/system/habitat-depot.service

# systemd reload
systemctl daemon-reload
# Enable the service
systemctl enable habitat-depot.service
# Start the service
systemctl start habitat-depot
