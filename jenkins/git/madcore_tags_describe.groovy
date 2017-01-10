job('madcore.tags.describe') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/jenkins/git
    bash describe_tags.sh
popd	    
"""	
        shell(command)
    }
}

