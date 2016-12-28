job('madcore.aws.instance') {
    parameters {
        stringParam('InstanceId', '', '')
        stringParam('StateName', '', '')        
    }
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/jenkins/aws
    bash madcore_aws_instance.sh
popd
"""
        shell(command)
    }
}
