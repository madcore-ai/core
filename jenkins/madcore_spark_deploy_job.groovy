pipelineJob('madcore.spark.submit') {
    parameters {
	    stringParam('APP_FILE_NAME', 'pi.py', '')
        stringParam('APP_ARGS', '2', '')
        stringParam('SPARK_ARGS', '--executor-memory 1G', '')
    }

    definition {
	cps {
	    sandbox()
	    script("""
		node {
		    stage 'start spark job in kubernetes spark cluster'
		    build job: 'df.deploy.spark', parameters: [string(name: 'APP_FILE_NAME', value: params.APP_FILE_NAME), string(name: 'APP_ARGS', value: params.APP_ARGS), string(name: 'SPARK_ARGS', value: params.SPARK_ARGS)]
                }
	    """.stripIndent())
	    }
    }
}



