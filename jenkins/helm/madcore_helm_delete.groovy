job('madcore.helm.delete') {
    parameters {
	    stringParam('RELEASE_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/helm
    bash delete.sh "\$RELEASE_NAME"
popd
"""
        shell(command)
    }
}
