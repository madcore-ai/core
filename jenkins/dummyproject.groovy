job('df.ssl.csr.generate') {
    steps {
        def command = """#!/bin/bash
min=1
range=15
randy=$RANDOM
let "randy %= 50"
echo ".... started looping"
sleep $[ $randy ]s
echo "...... finished process: "$randy"sec"
ping -c 50 google.com
"""
        shell(command)
    }

  <publishers>
    <jenkinsci.plugins.influxdb.InfluxDbPublisher plugin="influxdb@1.8.1">
      <selectedTarget>http://127.0.0.1:8086,jenkins_logs</selectedTarget>
      <customPrefix>test</customPrefix>
    </jenkinsci.plugins.influxdb.InfluxDbPublisher>
  </publishers>

}
