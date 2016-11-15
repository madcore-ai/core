job('madcore.selftest.habitat') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash madcore_selftest_habitat.sh
	popd

"""
        shell(command)
    }
}
