job('madcore.docker.registry.publish') {
    parameters {
        stringParam('IMAGE_NAME', '', '')
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/madcore/jenkins
    bash madcore_docker_registry_publish.sh
popd
"""
        shell(command)
    }
}
