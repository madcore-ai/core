job('madcore.kubectl.cluster.nodes.cleanup') {
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/kubernetes/kubectl
    bash cluster_nodes_cleanup.sh
popd
"""
        shell(command)
    }
}
