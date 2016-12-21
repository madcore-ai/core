job('madcore.docker.image.build') {
    parameters {
        stringParam('REPO_PATH', '', '')
        stringParam('REPO_HTTPS', '', '')
        stringParam('DOCKER_NAME_LABEL', '', '')
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/madcore/jenkins
    bash madcore_docker_image_build.sh
popd
"""
        shell(command)
    }
}
