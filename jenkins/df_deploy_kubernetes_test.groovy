job('df.deploy.kubernetes.test') {
    parameters {
        stringParam('REPO1_HTTPS', '', '')
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
    bash df_deploy_kubernetes_test.sh
popd

"""
        shell(command)
    }
}
