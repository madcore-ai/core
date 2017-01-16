pipelineJob('madcore.application') {
    parameters {
        stringParam('APP_NAME', '', '')
        stringParam('APP_PORT', '', '')
    }

    definition {
	cps {
	    sandbox()
	    script("""
		node {
		    paramAValue = "paramAValue"
            stage 'Update app info in redis'
            build job: 'madcore.redis.app.update', parameters: [string(name: 'APP_NAME', value: params.APP_NAME), string(name: 'APP_PORT', value: params.APP_PORT)]
            stage 'generate csr'
            build 'madcore.ssl.csr.generate'
            stage 'get certificate and reconfigure haproxy'
            build 'madcore.ssl.letsencrypt.getandinstall'
        }
	    """.stripIndent())
	    }
    }

}



