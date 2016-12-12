pipelineJob('madcore.deploy') {
    parameters {
	    stringParam('REPO_URL', '', '')
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
		    stage 'deploy to kubernetes'
		    build job: 'madcore.deploy.kubernetes', parameters: [string(name: 'REPO_URL', value: params.REPO_URL), string(name: 'APPNAME', value: params.APP_NAME), string(name: 'PORT', value: params.APP_PORT)]
                }
	    """.stripIndent())
	    }
    }

}



