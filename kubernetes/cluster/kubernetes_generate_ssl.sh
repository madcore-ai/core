#!/bin/bash
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
local_ip=$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4)

# copy config
mkdir -p /opt/kubernetes/ssl/
pushd /opt/madcore/kubernetes/cluster/ssl/
  cp kube.conf /opt/kubernetes/ssl/
  cp worker-kubeconfig.yaml /opt/kubernetes/ssl/
  cat worker-openssl_template.cnf | sed -e "s/\${node_ip}/$ip}/" | sed -e "s/\${local_node_ip}/$local_ip}/" > /opt/kubernetes/ssl/worker-openssl.cnf
popd

pushd /opt/kubernetes/ssl/
# copy CA certificate
cp /opt/backup/kubernetes/ca.pem /opt/kubernetes/ssl/
cp /opt/backup/kubernjetes/ca-key.pem /opt/kubernetes/ssl/

# generate worker certificate and key
openssl genrsa -out slave-worker-key.pem 2048
openssl req -new -key slave-worker-key.pem -out slave-worker.csr -subj "/CN=slave" -config worker-openssl.cnf
openssl x509 -req -in slave-worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out slave-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf

#Generate the Cluster Administrator Keypair
openssl genrsa -out admin-key.pem 2048
openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365
popd
