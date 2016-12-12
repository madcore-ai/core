job('madcore.deploy.kubernetes') {
    wrappers { preBuildCleanup() }
    parameters {
        stringParam('REPO_URL', '', '')
        stringParam('REPO_BRANCH', 'master', '')
	    stringParam('APPNAME', '', '')
        stringParam('PORT', '', '')
    }
    steps {
        def command = """#!/bin/bash
echo "REPO_URL: '\$REPO_URL'"
echo "REPO_BRANCH: '\$REPO_BRANCH'"
echo "APPNAME: '\$APPNAME'"
echo "PORT: '\$PORT'"

    python /opt/madcore/bin/deploy_kubernetes.py "\$REPO_URL" "\$APPNAME" "\$PORT" "\$REPO_BRANCH"
"""
        shell(command)
    }

    configure { project ->
	project / 'InfluxDbPublisher' << 'jenkinsci.plugins.influxdb.InfluxDbPublisher plugin="influxdb@1.8.1"' {
    	    selectedTarget 'http://127.0.0.1:8086,jenkins_logs'
      }
    }

}
