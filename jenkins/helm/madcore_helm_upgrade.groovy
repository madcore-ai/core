job('madcore.helm.upgrade') {
    parameters {
	    stringParam('RELEASE_NAME', '', '')
	    stringParam('CHART', '', '')
	    stringParam('NAMESPACE', 'default', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/helm
    bash upgrade.sh "\$RELEASE_NAME" /opt/plugins/charts/"\$CHART" --namespace="\$NAMESPACE"
popd
"""
        shell(command)
    }
}
