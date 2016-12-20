job('madcore.helm.install') {
   customWorkspace('/opt/plugins/charts')

    parameters {
	    stringParam('CHART', '', '')
	    stringParam('RELEASE_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/helm
    bash install.sh "\$CHART" --name "\$RELEASE_NAME"
popd
"""
        shell(command)
    }
}
