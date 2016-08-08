job('df.jenkins.user.create') {
    parameters {
        stringParam('username', '', '')
        stringParam('password', '', '')
    }
    triggers {
        cron("@minutes")
    }
    steps {
        def command = """#!/bin/bash
  pushd /var/lib/jenkins/workspace/seed-dsl/controlbox
      bash df_jenkins_user_create.sh
  popd
"""
        shell(command)
    }
}
