job('madcore.selftest.redis') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash madcore_selftest_redis.sh
	popd

"""
        shell(command)
    }
}
