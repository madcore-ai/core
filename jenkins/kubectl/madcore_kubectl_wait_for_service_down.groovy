job('madcore.kubectl.wait.service.down') {
    parameters {
        stringParam('APP_NAME', '', '')
        stringParam('SERVICE_NAME', '', '')
        stringParam('SERVICE_NAMESPACE', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/kubernetes/kubectl
    bash wait_for_service_down.sh "\$APP_NAME" "\$SERVICE_NAME" "\$SERVICE_NAMESPACE"
popd
"""
        shell(command)
    }
}
