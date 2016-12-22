job('madcore.docker.registry.publish') {
    parameters {
	    stringParam('APP_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/bin
    python docker_registry_publish.py "\$APP_NAME"
popd
"""
        shell(command)
    }
}
