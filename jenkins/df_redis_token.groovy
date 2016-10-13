job('df.redis.token') {
    parameters {
        stringParam('TYPE', '', '')
        stringParam('TOKEN', '', '')
        stringParam('ACTION', '', '')
        
    }
    
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
    bash df.redis.token.sh
popd
"""
        shell(command)
    }
}