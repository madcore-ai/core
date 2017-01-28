job('madcore.kubectl.cluster.node.remove') {
    parameters {
        stringParam('NODE_IP', '', 'Set IP of the node you want to remove.')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/kubernetes/kubectl
    bash remove_node_from_cluster.sh "\$NODE_IP"
popd
"""
        shell(command)
    }
}
