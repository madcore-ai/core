job('madcore.spark.submit.job') {
    wrappers { preBuildCleanup() }
    parameters {
        stringParam('APP_FILE_NAME', 'spark-examples-1.5.2-hadoop2.6.0.jar', '')
	    stringParam('APP_ARGS', '-app=pagerank -niters=11', '')
	    stringParam('SPARK_ARGS', '--class org.apache.spark.examples.graphx.SynthBenchmark --executor-memory 1G', '')
    }
    steps {
        def command = """#!/bin/bash
echo "APP_FILE_NAME: '\$APP_FILE_NAME'"
echo "APP_ARGS: '\$APP_ARGS'"
echo "SPARK_ARGS: '\$SPARK_ARGS'"

    python /opt/madcore/bin/spark_run_job.py "\$SPARK_ARGS" "\$APP_FILE_NAME" "\$APP_ARGS"
"""
        shell(command)
    }
}
