job('madcore.deploy.offlineimap') {
    wrappers { preBuildCleanup() }
    parameters {
        stringParam('REPO_URL', '', '')
    }
    steps {
        def command = """#!/bin/bash
echo "REPO_URL: '\$REPO_URL'"

    python /opt/controlbox/bin/deploy_offlineimap.py "\$REPO_URL"
"""
        shell(command)
    }
}
