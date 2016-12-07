job('madcore.spark.cluster') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	    sudo /opt/controlbox/spark/setup.sh

"""
        shell(command)
    }
}
