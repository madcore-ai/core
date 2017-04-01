mkdir -p /opt/docker_ssl/


/opt/madcore/registridocker/ssl/generate_CSR.sh

pushd /opt/docker_ssl/
    sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
    cp server.crt /usr/local/share/ca-certificates/core.madcore.crt
popd

update-ca-certificates

chown -R jenkins /opt/certs/
chown -R jenkins /opt/docker_ssl/
