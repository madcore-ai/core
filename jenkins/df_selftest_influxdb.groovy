job('df.selftest.influxdb') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash df_selftest_influxdb.sh
	popd

"""
        shell(command)
    }
}
