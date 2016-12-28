job('madcore.schedule.del') {
    parameters {
		stringParam('Name', '', '')        
    }    
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/jenkins/schedule
    bash madcore_schedule_del.sh
popd
"""
        shell(command)
    }
    publishers {
        downstream('madcore.scheduler.seed', 'SUCCESS')
    }
}