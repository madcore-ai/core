job('madcore.helm.upgrade') {
   customWorkspace('/opt/plugins/charts')

    parameters {
	    stringParam('RELEASE_NAME', '', '')
	    stringParam('CHART', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/helm
    bash upgrade.sh "\$RELEASE_NAME" "\$CHART"
popd
"""
        shell(command)
    }
}
