pipelineJob('madcore.spark.deploy') {
    parameters {
	stringParam('REPO_URL', 'https://github.com/giantswarm/sparkexample.git', '')
        stringParam('APP_NAME', 'docker-spark', '')
        stringParam('APP_PORT', '4567', '')
    }

    definition {
	cps {
	    sandbox()
	    script("""
		node {
		    stage 'deploy to kubernetes'
		    build job: 'df.deploy.kubernetes', parameters: [string(name: 'REPO_URL', value: params.REPO_URL), string(name: 'APPNAME', value: params.APP_NAME), string(name: 'PORT', value: params.APP_PORT)]
                }
	    """.stripIndent())
	    }
    }
}



