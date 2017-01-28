job('madcore.kubectl.describe') {
    parameters {
	    stringParam('FILENAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/kubernetes/kubectl
    bash describe.sh "/opt/plugins/\$FILENAME"
popd
"""
        shell(command)
    }
}
