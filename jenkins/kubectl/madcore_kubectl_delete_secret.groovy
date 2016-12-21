job('madcore.kubectl.delete.secret') {
    parameters {
        stringParam('APP_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/kubernetes/kubectl
    bash delete_secret.sh
popd
"""
        shell(command)
    }
}
