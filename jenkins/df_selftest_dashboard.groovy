job('df.selftest.dashboard') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash df_selftest_dashboard.sh
	popd

"""
        shell(command)
    }
}
