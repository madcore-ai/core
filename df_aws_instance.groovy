job('df.aws.instance') {
    parameters {
        stringParam('InstanceId', '', '')
        stringParam('StateName', '', '')        
    }
    triggers {
        cron("@minutes")
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/jobs/seed-dsl/workspace/controlbox
    bash df_aws_instance.sh
popd
"""
        shell(command)
    }
}