job('df_docker_build_from_git') {
   
    triggers {
        cron("@minutes")
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/controlbox
    bash df_docker_build_from_git.sh
popd
"""
        shell(command)
    }
}


