job('df.selftest.kubeapi') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash df_selftest_kubeapi.sh
	popd

"""
        shell(command)
    }
}
