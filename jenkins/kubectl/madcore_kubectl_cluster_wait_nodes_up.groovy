job('madcore.kubectl.cluster.wait.nodes.up') {
    parameters {
        stringParam('NODES_LABEL', '', 'Set here the node label to filter by.')
        stringParam('NODES_IPS', '', 'Comma separated list of IPs.')
        stringParam('NODES_TIMEOUT', '600', 'Timeout to wait for nodes')
    }
    steps {
        def command = """#!/bin/bash
echo NODES_LABEL: "\$NODES_LABEL"
echo NODES_IPS: "\$NODES_IPS"
echo NODES_TIMEOUT: "\$NODES_TIMEOUT"

pushd /opt/madcore/bin
    python wait_until_cluster_nodes_up.py "\$NODES_LABEL" "\$NODES_IPS" "\$NODES_TIMEOUT"
popd
"""
        shell(command)
    }
}
