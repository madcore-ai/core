job('madcore.kubectl.wait.pod.up') {
    parameters {
        stringParam('POD_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
until [[ $status == "Running" ]]; do
status=\$(kubectl get pods --all-namespaces | grep \$POD_NAME | awk '{print \$4}')
done
"""
        shell(command)
    }
}
