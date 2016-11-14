job('df.selftest.docker.registry') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash df_selftest_docker_registry.sh
	popd

"""
        shell(command)
    }
}
