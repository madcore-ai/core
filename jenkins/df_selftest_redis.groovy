job('df.selftest.redis') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
	    bash df_selftest_redis.sh
	popd

"""
        shell(command)
    }
}
