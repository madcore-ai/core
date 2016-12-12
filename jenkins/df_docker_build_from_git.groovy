job('df_docker_build_from_git') {
    parameters {
        stringParam('REPO_PATH', '', '')
        stringParam('REPO_HTTPS', '', '')  
        stringParam('DOCKER_NAME_LABEL', '', '') 
    }   
    triggers {
        cron("@minutes")
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/madcore/jenkins
    bash df_docker_build_from_git.sh
popd
"""
        shell(command)
    }
}


