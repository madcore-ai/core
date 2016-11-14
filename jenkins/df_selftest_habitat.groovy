job('df.selftest.habitat') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash df_selftest_habitat.sh
	popd

"""
        shell(command)
    }
}
