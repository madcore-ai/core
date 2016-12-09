job('madcore.schedule.del') {
    parameters {
		stringParam('Name', '', '')        
    }    
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
    sudo bash madcore_schedule_del.sh
popd
"""
        shell(command)
    }
}