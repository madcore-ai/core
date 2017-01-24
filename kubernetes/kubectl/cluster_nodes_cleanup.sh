#!/usr/bin/env bash

UNKNOWN_STATUS_NODES=$(kubectl get nodes -o json | python -c "import sys, json; \
nodes=json.load(sys.stdin); \
results = map(lambda item: item['metadata']['name'], filter( \
    lambda _item: filter(lambda cond: cond['type'] == 'Ready' and cond['status'] == 'Unknown',\
        _item['status']['conditions']), nodes['items']));\
print(' '.join(results));\
")

for NODE_NAME in ${UNKNOWN_STATUS_NODES[@]}; do
    kubectl drain "${NODE_NAME}" --force --delete-local-data --grace-period 1 --ignore-daemonsets
    kubectl delete node "${NODE_NAME}"
done
