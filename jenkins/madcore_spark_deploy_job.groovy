pipelineJob('madcore.spark.py.job') {
    parameters {
	    stringParam('FILE_NAME', 'pi.py', '')
        stringParam('ARGS', '2', '')
    }

    definition {
	cps {
	    sandbox()
	    script("""
		node {
		    stage 'start spark job in kubernetes spark cluster'
		    build job: 'df.deploy.spark', parameters: [string(name: 'FILE_NAME', value: params.FILE_NAME), string(name: 'ARGS', value: params.ARGS)]
                }
	    """.stripIndent())
	    }
    }
}



