#!/usr/bin/env python

import json
import sys
import time

from utils import run_cmd_no_debug


def mprint(msg):
    print(msg)
    sys.stdout.flush()


NODES_LABEL = sys.argv[1]
NODES_IPS = sys.argv[2]
TIMEOUT = int(sys.argv[3]) or 60 * 10

NODES_IPS = list(set(filter(None, map(lambda s: s.strip(), NODES_IPS.split(',')))))

mprint("NODES_IPS: %s" % NODES_IPS)

if not NODES_IPS:
    mprint("NO input IPs to check, skip.")
    sys.exit(1)

check_sleep = 10
slept_time = 0

nodes_status = {}

while True:
    get_nodes_json = run_cmd_no_debug(
        'kubectl get nodes --selector="{nodes_label}" -o json'.format(nodes_label=NODES_LABEL))

    for node in json.loads(get_nodes_json)['items']:
        for node_ip in NODES_IPS:
            node_status = nodes_status.get(node_ip, {})
            if node_status.get('ready', None):
                continue
            else:
                nodes_status[node_ip] = {'ready': None}
            for address in node['status']['addresses']:
                if address['type'] == 'InternalIP' and address['address'] == node_ip:
                    # just found, not yet sure about status
                    nodes_status[node_ip]['ready'] = False
                    break
            if nodes_status[node_ip]['ready'] is False:
                for condition in node['status']['conditions']:
                    if condition['type'] == 'Ready' and condition['status'] == 'True':
                        nodes_status[node_ip]['ready'] = True
                        break
    ready_count = 0

    for node_ip, status in nodes_status.items():
        if status['ready']:
            ready_count += 1
            mprint("Node with IP: %s is Ready." % node_ip)
        else:
            mprint("Node with IP: %s not yet Ready." % node_ip)

    mprint('-' * 42)

    if ready_count == len(NODES_IPS):
        break
    else:
        time.sleep(check_sleep)
        slept_time += check_sleep

        if slept_time > TIMEOUT:
            mprint("Timeout waiting for cluster nodes: %s seconds" % TIMEOUT)
            break
