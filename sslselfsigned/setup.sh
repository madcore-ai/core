mkdir -p /etc/pki/tls/certs
export SERVER=$HOSTNAME

/opt/controlbox/sslselfsigned/generate_CSR.sh

pushd /etc/pki/tls/certs
    sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
    cat server.crt server.key > server.bundle.pem
popd
chown -R jenkins /opt/certs/