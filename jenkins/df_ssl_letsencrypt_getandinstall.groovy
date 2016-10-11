job('df.ssl.letsencrypt.getandinstall') {
    parameters {
        stringParam('Email', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
    bash df_ssl_letsencrypt_getandinstall.sh
popd
"""
        shell(command)
    }
}
