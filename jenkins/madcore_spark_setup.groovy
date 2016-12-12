job('madcore.spark.setup') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	    sudo /opt/madcore/spark/setup.sh

"""
        shell(command)
    }
}
