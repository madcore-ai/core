#!/bin/bash
#HOSTNAME=`wget -q -O - http://169.254.169.254/latest/meta-data/public-hostname`
export SERVER='polfilm.devopshosted.com'
email=devopsfactory@styk.tv

sudo apt-get install letsencrypt -y

/opt/controlbox/sslselfsigned/generate_CSR.sh

pushd /etc/pki/tls/certs
    openssl req -inform pem -outform der -in server.csr -out server.der
    sudo letsencrypt certonly --csr server.der --standalone --standalone-supported-challenges http-01 --email $email
    cat 0000_cert.pem server.key > /etc/pki/tls/certs/server.bundle.pem
popd

#sudo service haproxy stop
#sudo service haproxy start