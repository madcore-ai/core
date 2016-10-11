#!/bin/bash
ping -q -c1 169.254.169.254 > /dev/null
if [ $? -eq 0 ]; then
HOSTNAME=$(wget -q -O -T 5 - http://169.254.169.254/latest/meta-data/public-hostname)
else
    HOSTNAME="vagrant.local"
fi
mkdir -p /opt/haproxy
cat /opt/controlbox/haproxy/haproxy.cfg.template | sed -e "s/\hostname_tmpl/${HOSTNAME}/" > /opt/haproxy/haproxy.cfg
sudo service haproxy stop
sudo sh -c 'mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.old'
sudo sh -c 'rm /etc/default/haproxy'
sudo sh -c 'cp /opt/controlbox/haproxy/haproxy /etc/default/haproxy'
sudo sh -c 'ln -s /opt/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg'
sudo service haproxy start
