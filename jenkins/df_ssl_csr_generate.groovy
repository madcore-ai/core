job('df.ssl.csr.generate') {
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
    python df_ssl_csr_generate.py
popd
"""
        shell(command)
    }
}
