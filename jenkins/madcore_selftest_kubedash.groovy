job('madcore.selftest.kubedash') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	pushd /var/lib/jenkins/workspace/seed-dsl/madcore/jenkins
	    bash madcore_selftest_kubedash.sh
            CODE=\$?
            if [[ \$CODE -ne 0 ]]; then
                echo "BASH FAILED WITH POSITIVE CODE. FORCING JENKINS BASH EXIT AS -1 (TO SHOW THE FAIL)"
                exit -1
            fi

	popd

"""
        shell(command)
    }
}
