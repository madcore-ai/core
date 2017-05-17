job('madcore.docker.image.build') {
    wrappers { preBuildCleanup() }
    parameters {
        stringParam('REPO_URL', '', '')
	    stringParam('APP_NAME', '', '')
	    stringParam('DOCKERFILE_PATH', '', 'Specify the path, relative to the root of repo, to the docker file')
        stringParam('REPO_BRANCH', 'master', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/bin
    python docker_image_build.py "\$REPO_URL" "\$APP_NAME" "\$DOCKERFILE_PATH" "\$REPO_BRANCH"
popd
"""
        shell(command)
    }
}
