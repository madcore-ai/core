pipelineJob('madcore.selftest') {

    definition {
	cps {
	    sandbox()
	    script("""
		node {
		    stage 'Test Kubernetes API'
		    build 'madcore.selftest.kubeapi'
                    stage 'Test Kubernetes Dashboard'
		    build ''madcore.selftest.kubedash'
		    stage 'Test Grafana'
		    build 'madcore.selftest.grafana'
		    stage 'Test InfluxDB'
		    build 'madcore.selftest.influxdb'
		    stage 'Test Docker registry'
		    build 'madcore.selftest.docker.registry'
		    stage 'Test Habitat'
		    build 'madcore.selftest.habitat'

                }
	    """.stripIndent())
	    }
    }

}



