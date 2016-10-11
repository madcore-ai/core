#!/bin/bash
echo "Email: '$Email'"
pushd /opt/certs
    openssl req -inform pem -outform der -in server.csr -out server.der
    letsencrypt certonly --csr server.der --standalone --standalone-supported-challenges http-01 --email $Email
    cat 0000_cert.pem server.key > server.bundle.pem
popd
sed -i "s/\/etc\/pki\/tls\/certs\/server.bundle.pem/\/opt\/certs\/server.bundle.pem/g" /opt/haproxy/haproxy.cfg
sudo service haproxy restart