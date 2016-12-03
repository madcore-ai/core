pipelineJob('madcore.deploy.spark') {
    parameters {
	    stringParam('REPO_URL', 'https://github.com/giantswarm/sparkexample.git', '')
	    stringParam('REPO_BRANCH', 'master', '')
        stringParam('APP_NAME', 'docker-spark', '')
        stringParam('APP_PORT', '4567', '')
    }

    definition {
	cps {
	    sandbox()
	    script("""
		node {
		    stage 'deploy spark container to kubernetes'
		    build job: 'df.deploy.kubernetes', parameters: [string(name: 'REPO_URL', value: params.REPO_URL), string(name: 'APPNAME', value: params.APP_NAME), string(name: 'PORT', value: params.APP_PORT), string(name: 'REPO_BRANCH', value: params.REPO_BRANCH)]
                }
	    """.stripIndent())
	    }
    }
}



