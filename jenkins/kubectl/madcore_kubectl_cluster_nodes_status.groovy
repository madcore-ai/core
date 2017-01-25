job('madcore.kubectl.cluster.nodes.status') {
    parameters {
        stringParam('NODE_LABEL', '', 'Set here the node label to filter by.')
    }
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/kubernetes/kubectl
    bash cluster_nodes_status.sh "\$NODE_LABEL"
popd
"""
        shell(command)
    }
}
