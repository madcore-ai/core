#!/bin/bash
echo "EMAIL: '$EMAIL'"
pushd /opt/certs
echo $EMAIL
    openssl req -inform pem -outform der -in server.csr -out server.der
    letsencrypt certonly --csr server.der --standalone --standalone-supported-challenges http-01 --email $EMAIL
    cat 0000_cert.pem server.key > server.bundle.pem
popd
sed -i "s/\/etc\/pki\/tls\/certs\/server.bundle.pem/\/opt\/certs\/server.bundle.pem/g" /opt/haproxy/haproxy.cfg
systemctl restart haproxy