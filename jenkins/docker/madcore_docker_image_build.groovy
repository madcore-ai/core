job('madcore.docker.image.build') {
    parameters {
        stringParam('REPO_URL', '', '')
	    stringParam('APP_NAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/bin
    python docker_image_build.py "\$REPO_URL" "\$APP_NAME"
popd
"""
        shell(command)
    }
}
