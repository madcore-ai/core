#!/bin/bash
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
mkdir -p /opt/kubernetes/ssl

pushd /opt/madcore/kubernetes/ssl/
# copy config and token
cp kube.conf /opt/kubernetes/ssl/kube.conf
cat openssl.cnf_template | sed -e "s/\${KUB_MASTER_IP}/$KUB_MASTER_IP/" > /opt/kubernetes/ssl/openssl.cnf
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
