#!/usr/bin/env bash

NODE_IP=$1

NODE_NAME=$(cat nodes.json | python -c "import sys, json; \
nodes=json.load(sys.stdin); \
results = map(lambda item: item['metadata']['name'], filter( \
    lambda _item: filter(lambda addr: addr['type'] == 'InternalIP' and addr['address'] == \"${NODE_IP}\",\
        _item['status']['addresses']), nodes['items']));\
node_name = results[0] if results else '';
print(node_name);\
")

if [[ ! -z "${NODE_NAME}" ]]
then
    echo "Remove node from cluster: ${NODE_NAME}..."
    kubectl drain "${NODE_NAME}" --force --delete-local-data --grace-period 1 --ignore-daemonsets
    kubectl delete node "${NODE_NAME}"
else
    echo "Node with ${NODE_NAME} not found."
fi
