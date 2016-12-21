job('madcore.helm.status') {
    parameters {
	    stringParam('RELEASE_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/helm
    bash status.sh "\$RELEASE_NAME"
popd
"""
        shell(command)
    }
}
