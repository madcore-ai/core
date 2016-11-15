job('madcore.selftest.docker.registry') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash madcore_selftest_docker_registry.sh
	popd

"""
        shell(command)
    }
}
