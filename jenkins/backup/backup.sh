#!/bin/bash

S3_BUCKET_NAME="$1"
BACKUP_DIR=/opt/backup

echo "Backup to S3 : ${S3_BUCKET_NAME}"

if [ -d "${BACKUP_DIR}" ]; then
    # clear directory
    rm -rfv ${BACKUP_DIR}/*
else
    mkdir -p ${BACKUP_DIR}
fi

# backup cert files
mkdir -p ${BACKUP_DIR}/certs
cp -R /opt/certs/* ${BACKUP_DIR}/certs

# backup redis data
mkdir -p ${BACKUP_DIR}/redis
redis-cli save
cp /hab/svc/redis/data/dump.rdb ${BACKUP_DIR}/redis/

# backup ssh public key
mkdir -p ${BACKUP_DIR}/ssh
cp /var/lib/jenkins/.ssh/id_rsa.pub ${BACKUP_DIR}/ssh/

# backup docker certs
mkdir -p ${BACKUP_DIR}/docker_ssl
cp /opt/docker_ssl/server.crt ${BACKUP_DIR}/docker_ssl/core.madcore.crt


# backup kubernetes certs
mkdir -p ${BACKUP_DIR}/kubernetes
cp /opt/kubernetes/ssl/ca.pem ${BACKUP_DIR}/kubernetes/
cp /opt/kubernetes/ssl/ca-key.pem ${BACKUP_DIR}/kubernetes/

bucket_region=$(aws s3api get-bucket-location --bucket ${S3_BUCKET_NAME} | jq .[] | sed "s^\"^^g")
if [ $bucket_region = "null" ]; then
   bucket_region="us-east-1"
fi

aws s3 sync ${BACKUP_DIR} s3://${S3_BUCKET_NAME}/backup --region $bucket_region
