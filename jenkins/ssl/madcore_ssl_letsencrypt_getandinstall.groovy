job('madcore.ssl.letsencrypt.getandinstall') {
    parameters {
        stringParam('S3BucketName', '', '')
    }
    steps {
        def command = """#!/bin/bash
        sudo /opt/madcore/bin/haproxy_get_ssl.py
"""
        shell(command)
    }
    publishers {
        downstreamParameterized {
            trigger('madcore.backup') {
                condition('SUCCESS')
                parameters {
                    currentBuild()
                }
            }
        }
    }
}

​
