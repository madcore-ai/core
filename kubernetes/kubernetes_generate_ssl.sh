#!/bin/bash
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
public_ip=$(wget -q -O - http://169.254.169.254/latest/meta-data/public-ipv4)
mkdir -p /opt/kubernetes/ssl

pushd /opt/madcore/kubernetes/ssl/
# copy config and token
cp kube.conf /opt/kubernetes/ssl/kube.conf
if [ "$ENV" = "VAGRANT" ]; then 
cat openssl.cnf_template | sed -e "s/\${KUB_MASTER_IP}//" | sed -e "s/\${KUB_MASTER__PUBLIC_IP}//" > /opt/kubernetes/ssl/openssl.cnf
else
cat openssl.cnf_template | sed -e "s/\${KUB_MASTER_IP}/IP.3=$ip/" | sed -e "s/\${KUB_MASTER__PUBLIC_IP}/IP.4=$public_ip/" > /opt/kubernetes/ssl/openssl.cnf
fi
popd

pushd /opt/kubernetes/ssl/
#Create a Cluster Root CA
openssl genrsa -out ca-key.pem 2048
openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"

# Create api server certificate
openssl genrsa -out apiserver-key.pem 2048
openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf

# Create static token
dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 | tr -d "=+/" | dd bs=32 count=1 2>/dev/null > token.csv
echo ",kubeapi,kubeapi" >> token.csv

#Generate the Cluster Administrator Keypair
openssl genrsa -out admin-key.pem 2048
openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365

popd
