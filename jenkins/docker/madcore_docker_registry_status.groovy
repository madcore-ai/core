job('madcore.docker.registry.status') {
    parameters {
	    stringParam('APP_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/bin
    echo \$(curl -k https://root:madcore@localhost:5000/v2/_catalog)
popd
"""
        shell(command)
    }
}
