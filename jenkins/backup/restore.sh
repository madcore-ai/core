#!/bin/bash

S3_BUCKET_NAME="$1"
BACKUP_DIR=/opt/backup

echo "Restore from S3 : ${S3_BUCKET_NAME}"
echo ""
if [ -d "${BACKUP_DIR}" ]; then
    # remove all data from backup folder, if exists
    rm -rfv ${BACKUP_DIR}/*
else
    mkdir -p ${BACKUP_DIR}
fi

aws s3 sync s3://${S3_BUCKET_NAME}/backup ${BACKUP_DIR}

if [ -d "${BACKUP_DIR}/certs" ]; then
    rm -rfv /opt/certs/*
    # restore cert files
    cp -R ${BACKUP_DIR}/certs/* /opt/certs
    chown -R jenkins /opt/certs
fi

if [ -d "${BACKUP_DIR}/redis" ]; then
    echo "Restore backup for redis"
    # restore redis data
    pkill -f hab
    sleep 10
    rm -rf /hab/svc/redis/data/dump.rdb
    cp ${BACKUP_DIR}/redis/dump.rdb /hab/svc/redis/data/dump.rdb
    systemctl start habitat-depot
    echo "Done."
    sleep 5

    echo "Reconfigure HaProxy"
    # start haproxy reconfiguration
    mkdir -p /opt/haproxy
    /opt/madcore/bin/haproxy_get_ssl.py yes
    echo "Done."
fi
