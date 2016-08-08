job('df.docker.setup') {
    scm {
        github('jenkinsci/job-dsl-plugin', 'master')
    }
    triggers {
        cron("@hourly")
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/controlbox
    bash /opt/docker_registry_setup/df_docker_setup.sh
popd
"""
        shell(command)
    }
