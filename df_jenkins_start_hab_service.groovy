job('df.jenkins.start.hab.service') {
    triggers {
        cron("@minutes")
    }
    steps {
        def command = """#!/bin/bash
  pushd /var/lib/jenkins/workspace/seed-dsl/controlbox
      bash df_jenkins_start_hab_service.sh
  popd
"""
        shell(command)
    }
}
