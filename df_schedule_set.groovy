job('df.schedule.set') {
    parameters {
        stringParam('Monday', '', '')
        stringParam('Tuesday', '', '')
        stringParam('Wednesday', '', '')
        stringParam('Thursday', '', '')
        stringParam('Friday', '', '')
        stringParam('Saturday', '', '')
        stringParam('Sunday', '', '')
        stringParam('InstanceList', '', '')
    }
    triggers {
        cron("@hourly")
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/jobs/seed-dsl/workspace/controlbox
    bash df_schedule_set.sh
popd
"""
        shell(command)
    }
}
