job('madcore.redis.token') {
    parameters {
        stringParam('TYPE', '', '')
        stringParam('TOKEN', '', '')
        stringParam('ACTION', '', '')
        
    }
    
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/madcore/jenkins
    bash madcore.redis.token.sh
popd
"""
        shell(command)
    }
}