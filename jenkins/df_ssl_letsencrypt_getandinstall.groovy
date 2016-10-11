job('df.ssl.letsencrypt.getandinstall') {
    parameters {
        stringParam('Email', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/controlbox/jenkins
	sudo bash  "df_ssl_letsencrypt_getandinstall.sh"
popd
"""
        shell(command)
    }
}
