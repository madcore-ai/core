job('madcore.helm.install') {
    parameters {
	    stringParam('CHART', '', '')
	    stringParam('RELEASE_NAME', '', '')
	    stringParam('NAMESPACE', 'default', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/helm
    bash install.sh /opt/plugins/charts/"\$CHART" --name "\$RELEASE_NAME" --namespace="\$NAMESPACE"
popd
"""
        shell(command)
    }
}
