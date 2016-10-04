#!/bin/bash
#hostname=`wget -q -O - http://169.254.169.254/latest/meta-data/public-hostname`
hostname='controlbox.polfilm.devopshosted.com'
email=devopsfactory@styk.tv

sudo apt-get install letsencrypt -y

mkdir -p /opt/sslletsencrypt

echo "
[ req ]
default_bits = 2048 # Size of keys
default_keyfile = key.pem # name of generated keys
default_md = md5 # message digest algorithm
string_mask = nombstr # permitted characters
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
# Variable name   Prompt string
0.organizationName = Organization Name (company)
organizationalUnitName = Organizational Unit Name (department, division)
emailAddress = Email Address
emailAddress_max = 40
localityName = Locality Name (city, district)
stateOrProvinceName = State or Province Name (full name)
countryName = Country Name (2 letter code)
countryName_min = 2
countryName_max = 2
commonName = Common Name (hostname, IP, or your name)
commonName_max = 64

countryName_default = GB
localityName_default = London
0.organizationName_default = Rona Animation Studios
organizationalUnitName_default = Development
commonName_default = $hostname

[SAN]
subjectAltName=DNS:$hostname"  > /opt/sslletsencrypt/openssl.cnf



pushd /opt/sslletsencrypt
    sudo openssl req -nodes -newkey rsa:2048 -keyout server.key -out server.der -outform der -config openssl.cnf -sha256 -batch -reqexts SAN
    sudo letsencrypt certonly --csr /opt/sslletsencrypt/server.der --standalone --standalone-supported-challenges http-01 --email $email
    cat 0000_cert.pem server.key > /etc/pki/tls/certs/server.bundle.pem

sudo service haproxy stop
sudo service haproxy start