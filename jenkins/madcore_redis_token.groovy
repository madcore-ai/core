job('madcore.redis.token') {
    parameters {
        stringParam('TYPE', '', '')
        stringParam('TOKEN', '', '')
        stringParam('ACTION', '', '')
        
    }
    
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/jenkins
    bash madcore.redis.token.sh
popd
"""
        shell(command)
    }
}