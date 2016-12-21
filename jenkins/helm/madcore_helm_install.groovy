job('madcore.helm.install') {
    parameters {
	    stringParam('CHART', '', '')
	    stringParam('RELEASE_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/helm
    bash install.sh /opt/plugins/charts/"\$CHART" --name "\$RELEASE_NAME"
popd
"""
        shell(command)
    }
}
