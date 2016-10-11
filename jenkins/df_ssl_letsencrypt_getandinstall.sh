#!/bin/bash
echo "Email: '$Email'"
sudo apt-get install letsencrypt -y
pushd /etc/pki/tls/certs
    openssl req -inform pem -outform der -in server.csr -out server.der
    sudo letsencrypt certonly --csr server.der --standalone --standalone-supported-challenges http-01 --email $Email
    cat 0000_cert.pem server.key > /etc/pki/tls/certs/server.bundle.pem
popd