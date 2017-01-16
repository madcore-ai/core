pipelineJob('madcore.registration') {
    parameters {
        stringParam('Hostname', '', '')
        stringParam('Email', '', '')
        stringParam('OrganizationName', '', '')
        stringParam('OrganizationalUnitName', '', '')
        stringParam('LocalityName', '', '')
        stringParam('Country', '', '')
        stringParam('S3BucketName', '', '')
    }

    definition {
	cps {
	    sandbox()
	    script("""
		node {
		    paramAValue = "paramAValue"
            stage 'Update owner info in redis'
		    build job: 'madcore.redis.owner.update', parameters: [string(name: 'Hostname', value: params.Hostname), string(name: 'Email', value: params.Email), string(name: 'OrganizationName', value: params.OrganizationName), string(name: 'OrganizationalUnitName', value: params.OrganizationalUnitName), string(name: 'LocalityName', value: params.LocalityName), string(name: 'Country', value: params.Country)]
            stage 'Update app info in redis'
		    build job: 'madcore.redis.add.basic.apps'
		    stage 'generate csr'
		    build 'madcore.ssl.csr.generate'
		    stage 'get certificate and reconfigure haproxy'
		    build 'madcore.ssl.letsencrypt.getandinstall'
		    stage('backup data') {
		        build job: 'madcore.backup', parameters: [string(name: 'S3BucketName', value: params.S3BucketName)]
		    }
            }
	    """.stripIndent())
	    }
    }

}



