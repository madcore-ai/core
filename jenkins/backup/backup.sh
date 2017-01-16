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

aws s3 sync ${BACKUP_DIR} s3://${S3_BUCKET_NAME}/backup
