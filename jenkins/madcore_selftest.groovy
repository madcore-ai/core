pipelineJob('madcore.deploy') {
    parameters {
    }

    definition {
	cps {
	    sandbox()
	    script("""
		node {
		    stage 'Test Kubernetes API'
		    build job: 'df.selftesf.kubeapi'
                    stage 'Test Kubernetes Dashboard'
		    build job: 'df.selftesf.dashboard'
		    stage 'Test Grafana'
		    build job: 'df.selftesf.grafana'
		    stage 'Test InfluxDB'
		    build job: 'df.selftesf.influxdb'
		    stage 'Test Docker registry'
		    build job: 'df.selftesf.docker.registry'
		    stage 'Test Habitat'
		    build job: 'df.selftesf.habitat'

                }
	    """.stripIndent())
	    }
    }

}



