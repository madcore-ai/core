job('madcore.selftest.kubedash') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash df_selftest_kubedash.sh
	popd

"""
        shell(command)
    }
}
