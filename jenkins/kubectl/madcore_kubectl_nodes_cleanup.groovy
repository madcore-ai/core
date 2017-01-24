job('madcore.kubectl.cluster.nodes.cleanup') {
    parameters {
        stringParam('NODE_LABEL', 'cluster=test', 'Set here the node label to filter by.')
    }
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/kubernetes/kubectl
    bash cluster_nodes_cleanup.sh "\$NODE_LABEL"
popd
"""
        shell(command)
    }
}
