job('madcore.reinstall') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
	    sudo /opt/controlbox/jenkins/madcore_reinstall.sh

"""
        shell(command)
    }
}
