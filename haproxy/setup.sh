#!/bin/bash
sudo apt-get install haproxy -y
#certificate generated as part of main script cb-install.sh
sudo service haproxy stop
sudo sh -c 'mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.old'
sudo sh -c 'rm /etc/default/haproxy'
sudo sh -c 'cp /opt/controlbox/haproxy/haproxy /etc/default/haproxy'
sudo sh -c 'cp /opt/controlbox/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg'
sudo service haproxy start
