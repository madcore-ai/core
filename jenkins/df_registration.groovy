pipelineJob('df.registration') {
    parameters {
        stringParam('Hostname', '', '')
        stringParam('Email', '', '')
	stringParam('OrganizationName', '', '')
	stringParam('OrganizationalUnitName', '', '')
	stringParam('LocalityName', '', '')
	stringParam('Country', '', '')
        stringParam('APPNAME', '', '')

    }

    definition {
	cps {
	    sandbox()
	    script("""
		node {
		    paramAValue = "paramAValue"
                    stage 'Update owner info in redis'
		    build job: 'df.redis.owner.update', parameters: [string(name: 'Hostname', value: params.Hostname), string(name: 'Email', value: params.Email), string(name: 'OrganizationName', value: params.OrganizationName), string(name: 'OrganizationalUnitName', value: params.OrganizationalUnitName), string(name: 'LocalityName', value: params.LocalityName), string(name: 'Country', value: params.Country)]
                    stage 'Update app info in redis'
		    build job: 'df.redis.app.update', parameters: [string(name: 'APPNAME', value: params.APPNAME)]
		    stage 'generate csr'
		    build 'df.ssl.csr.generate'
		    stage 'get certificate and reconfigure haproxy'
		    build 'df.ssl.letsencrypt.getandinstall'
                }
	    """.stripIndent())
	    }
    }

}



