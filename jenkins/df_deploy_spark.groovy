job('df.deploy.spark') {
    wrappers { preBuildCleanup() }
    parameters {
        stringParam('FILE_NAME', '', '')
	    stringParam('ARGS', '', '')
    }
    steps {
        def command = """#!/bin/bash
echo "FILE_NAME: '\$FILE_NAME'"
echo "ARGS: '\$ARGS'"

    python /opt/controlbox/bin/spark_run_job.py "\$FILE_NAME" "\$ARGS"
"""
        shell(command)
    }
}
