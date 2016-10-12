job('df.redis.token') {
    parameters {
        stringParam('Type', '', '')
        stringParam('Token', '', '')
        stringParam('action', '', '')
        
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