job('madcore.reinstall') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash madcore_reinstall.sh
	popd

"""
        shell(command)
    }
}
