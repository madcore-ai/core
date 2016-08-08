#!/bin/bash

# Give Current System's IP Address to variable
# Option 1
# ip=`ifconfig|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/'`
#Option 2
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
# echo "Inserting IP Address: "$ip

# write toml file with ip address
cat habitat/hab.director-controlbox.toml.template  | sed -e "s/\${ip}/${ip}/" >  habitat/hab.director-controlbox.toml

# Copy Files to Proper Locaiton
# Location to Copy Files into /etc/systemd/system
# Copy files to location isskiped coz a sym link is created for it.
sudo cp habitat/systemd-director.service /etc/systemd/system/systemd-director.service
