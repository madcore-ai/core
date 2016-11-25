job('df.deploy.spark') {
    wrappers { preBuildCleanup() }
    parameters {
        stringParam('APP_FILE_NAME', '', '')
	    stringParam('APP_ARGS', '', '')
	    stringParam('SPARK_ARGS', '', '')
    }
    steps {
        def command = """#!/bin/bash
echo "APP_FILE_NAME: '\$APP_FILE_NAME'"
echo "APP_ARGS: '\$APP_ARGS'"
echo "SPARK_ARGS: '\$SPARK_ARGS'"

    python /opt/controlbox/bin/spark_run_job.py "\$SPARK_ARGS" "\$APP_FILE_NAME" "\$APP_ARGS"
"""
        shell(command)
    }
}
