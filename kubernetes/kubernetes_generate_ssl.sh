#!/bin/bash
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')

pushd /opt/madcore/kubernetes/ssl/
# copy CA certificate
cp ca.pem /opt/kubernetes/ssl/
cp ca-key.pem /opt/kubernetes/ssl/

# copy csr
cp admin.csr /opt/kubernetes/ssl/
cp apiserver.csr /opt/kubernetes/ssl/

# copy config and token
cp kube.conf /opt/kubernetes/ssl/
cp token.csv /opt/kubernetes/ssl/
cat openssl.cnf_template | sed -e "s/\${ip}/${KUB_MASTER_IP}/" > /opt/kubernetes/ssl/openssl.cnf
popd

pushd /opt/kubernetes/ssl/
# Create api server certificate
openssl genrsa -out apiserver-key.pem 2048
openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf

#Generate the Cluster Administrator Keypair

openssl genrsa -out admin-key.pem 2048
openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365

popd
