#!/bin/bash
echo "EMAIL: '$EMAIL'"
EMAIL=devopsfactory@styk.tv
pushd /opt/certs
    openssl req -inform pem -outform der -in server.csr -out server.der
    letsencrypt certonly --csr server.der --standalone --email $EMAIL --standalone-supported-challenges http-01
    cat 0000_cert.pem server.key > server.bundle.pem
popd
sed -i "s/\/etc\/pki\/tls\/certs\/server.bundle.pem/\/opt\/certs\/server.bundle.pem/g" /opt/haproxy/haproxy.cfg
service haproxy stop
service haproxy start