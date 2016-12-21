job('madcore.kubectl.create.secret') {
    parameters {
        stringParam('APP_NAME', '', '')
	    stringParam('SECRET', '', 'Secrets in the form: key1=value1;key2=value2')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/kubernetes/kubectl
    bash create_secret.sh
popd
"""
        shell(command)
    }
}
