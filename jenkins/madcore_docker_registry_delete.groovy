job('madcore.docker.registry.delete') {
    parameters {
        stringParam('IMAGE_NAME', '', '')
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/madcore/jenkins
    bash madcore_docker_registry_delete.sh
popd
"""
        shell(command)
    }
}
