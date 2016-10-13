#!/bin/bash
HOSTNAME_AWS=$(curl --connect-timeout 5 http://169.254.169.254/latest/meta-data/public-hostname)
if [[ -z $HOSTNAME  ]]; then
    HOSTNAME_AWS="localhost"
fi
mkdir -p /opt/haproxy
cat /opt/controlbox/haproxy/haproxy.cfg.template | sed -e "s/\hostname_tmpl/${HOSTNAME_AWS}/" > /opt/haproxy/haproxy.cfg
sudo service haproxy stop
sudo sh -c 'mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.old'
sudo sh -c 'rm /etc/default/haproxy'
sudo sh -c 'cp /opt/controlbox/haproxy/haproxy /etc/default/haproxy'
sudo sh -c 'ln -s /opt/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg'
sudo service haproxy start
