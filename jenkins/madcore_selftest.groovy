pipelineJob('madcore.selftest') {

    definition {
	cps {
	    sandbox()
	    script("""
		node {
		    stage 'Test Kubernetes API'
		    build 'df.selftest.kubeapi'
                    stage 'Test Kubernetes Dashboard'
		    build 'df.selftest.dashboard'
		    stage 'Test Grafana'
		    build 'df.selftest.grafana'
		    stage 'Test InfluxDB'
		    build 'df.selftest.influxdb'
		    stage 'Test Docker registry'
		    build 'df.selftest.docker.registry'
		    stage 'Test Habitat'
		    build 'df.selftest.habitat'

                }
	    """.stripIndent())
	    }
    }

}



