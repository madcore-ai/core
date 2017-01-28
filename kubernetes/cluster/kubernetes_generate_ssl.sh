#!/bin bash
ip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
local_ip=$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4)

# copy config
pushd /opt/madcore/kubernetes/cluster/ssl/
  cp kube.conf /opt/kubernetes/ssl/
  cp worker-kubeconfig.yaml /opt/kubernetes/ssl/
  cat worker-openssl.cnf_template | sed -e "s/\${node_ip}/$ip}/" | sed -e "s/\${local_node_ip}/$local_ip}/" > /opt/kubernetes/ssl/worker-openssl.cnf
popd

pushd /opt/kubernetes/ssl/
# copy CA certificate
scp -i /home/ubuntu/.ssl/id_rsa -o StrictHostKeychecking=no ubuntu@$KUB_MASTER_IP:/opt/kubernetes/ssl/ca.pem
scp -i /home/ubuntu/.ssl/id_rsa -o StrictHostKeychecking=no ubuntu@$KUB_MASTER_IP:/opt/kubernetes/ssl/ca-key.pem

# generate worker certificate and key
openssl genrsa -out slave-worker-key.pem 2048
openssl req -new -key slave-worker-key.pem -out slave-worker.csr -subj "/CN=slave" -config worker-openssl.cnf
openssl x509 -req -in slave-worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out slave-worker.pem -days 365 -extensions v3_req -extfile worker-openssl.cnf

#Generate the Cluster Administrator Keypair
openssl genrsa -out admin-key.pem 2048
openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365
popd
