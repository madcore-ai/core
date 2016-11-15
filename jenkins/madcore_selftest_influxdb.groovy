job('madcore.selftest.influxdb') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash madcore_selftest_influxdb.sh
	popd

"""
        shell(command)
    }
}
