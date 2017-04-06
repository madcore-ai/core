job('madcore.ssl.letsencrypt.getandinstall') {
    parameters {
        stringParam('S3BucketName', '', '')
    }
    steps {
        def command = """#!/bin/bash
sudo /opt/madcore/bin/haproxy_get_ssl.py
CODE=$?
if [[ $CODE -ne 0 ]]; then
  echo 'MADCORE GET CERT FAILED WITH POSITIVE CODE ($CODE). FORCING JENKINS BASH EXIT AS -1 (TO SHOW THE FAIL)'
  exit -1
fi
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
