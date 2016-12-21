job('madcore.docker.registry.status') {
    parameters {
	    stringParam('APP_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/bin
    # TODO
popd
"""
        shell(command)
    }
}
