job('df.schedule.set') {
    parameters {
		stringParam('Name', '', '')
        stringParam('Monday', '', '')
        stringParam('Tuesday', '', '')
        stringParam('Wednesday', '', '')
        stringParam('Thursday', '', '')
        stringParam('Friday', '', '')
        stringParam('Saturday', '', '')
        stringParam('Sunday', '', '')
        stringParam('InstanceList', '', '')
		stringParam('IsEnabled', '', '')
    }
    triggers {
        cron("@hourly")
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
    bash df_schedule_set.sh
popd
"""
        shell(command)
    }
}
