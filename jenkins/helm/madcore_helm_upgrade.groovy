job('madcore.helm.upgrade') {
    parameters {
	    stringParam('RELEASE_NAME', '', '')
	    stringParam('CHART', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/helm
    bash upgrade.sh "\$RELEASE_NAME" /opt/plugins/charts/"\$CHART"
popd
"""
        shell(command)
    }
}
