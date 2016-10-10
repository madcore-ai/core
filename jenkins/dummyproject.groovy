job('dummyproject') {
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
    bash dummyproject.sh
popd	    
"""	
        shell(command)
    }

#    publishers {
#	influxdb(http://127.0.0.1:8086,jenkins_logs)
#    }

#  <publishers>
#    <jenkinsci.plugins.influxdb.InfluxDbPublisher plugin="influxdb@1.8.1">
#      <selectedTarget>http://127.0.0.1:8086,jenkins_logs</selectedTarget>
#      <customPrefix>test</customPrefix>
#    </jenkinsci.plugins.influxdb.InfluxDbPublisher>
# </publishers>

}
