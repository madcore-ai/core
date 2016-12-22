job('madcore.docker.registry.delete') {
    parameters {
	    stringParam('APP_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/bin
    python docker_registry_delete.py "\$APP_NAME"
popd
"""
        shell(command)
    }
}
