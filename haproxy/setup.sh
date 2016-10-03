#!/bin/bash
hostname=`wget -q -O - http://169.254.169.254/latest/meta-data/public-hostname`
sudo apt-get install haproxy -y
#certificate generated as part of main script cb-install.sh
mkdir -p /opt/haproxy
cat /opt/controlbox/haproxy/haproxy.cfg.template | sed -e "s/\hostname_tmpl/${hostname}/" > /opt/haproxy/haproxy.cfg
sudo service haproxy stop
sudo sh -c 'mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.old'
sudo sh -c 'rm /etc/default/haproxy'
sudo sh -c 'cp /opt/controlbox/haproxy/haproxy /etc/default/haproxy'
sudo sh -c 'cp /opt/controlbox/haproxy/haproxy.cfg.template /opt/haproxy/haproxy.cfg'
sudo sh -c 'ln -s /etc/haproxy/haproxy.cfg /opt/haproxy/haproxy.cfg'
sudo service haproxy start
