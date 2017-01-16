#!/usr/bin/env bash

S3_BUCKET_NAME="$1"
BACKUP_DIR=/opt/backup

echo "Restore from S3 : ${S3_BUCKET_NAME}"

mkdir -p ${BACKUP_DIR}

# remove all data from backup folder, if exists
rm -rf ${BACKUP_DIR}/*

aws s3 sync s3://${S3_BUCKET_NAME}/backup ${BACKUP_DIR}

if [ -d "${BACKUP_DIR}/certs" ]; then
    # restore cert files
    cp -R ${BACKUP_DIR}/certs /opt/certs
fi

if [ -d "${BACKUP_DIR}/redis" ]; then
    # restore redis data
    pkill -f hab
    sleep 10
    rm -rf /hab/svc/redis/data/dump.rdb
    cp ${BACKUP_DIR}/redis/dump.rdb /hab/svc/redis/data/dump.rdb
    systemctl start habitat-depot
    sleep 5

    # start haproxy reconfiguration
    mkdir -p /opt/haproxy
    /opt/madcore/bin/haproxy_get_ssl.py yes
fi
