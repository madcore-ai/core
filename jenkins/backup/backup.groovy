job('madcore.backup') {
    parameters {
        stringParam('S3BucketName', '', 'Input S3 bucket name where backup will be uploaded')
    }
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/jenkins/backup
    bash backup.sh "\$S3BucketName"
popd
"""
        shell(command)
    }
}
