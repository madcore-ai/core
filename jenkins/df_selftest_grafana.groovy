job('df.selftest.grafana') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash df_selftest_grafana.sh
	popd

"""
        shell(command)
    }
}
