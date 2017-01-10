job('madcore.selftest.docker.registry') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /opt/madcore/jenkins/selftests
	    bash madcore_selftest_docker_registry.sh
            CODE=\$?
            if [[ \$CODE -ne 0 ]]; then
                echo "BASH FAILED WITH POSITIVE CODE. FORCING JENKINS BASH EXIT AS -1 (TO SHOW THE FAIL)"
                exit -1
            fi

	popd

"""
        shell(command)
    }
}