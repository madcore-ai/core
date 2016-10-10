job('df.redis.owner.update') {
    parameters {
        stringParam('Hostname', '', '')
        stringParam('Email', '', '')
	stringParam('OrganizationName', '', '')
	stringParam('OrganizationalUnitName', '', '')
	stringParam('LocalityName', '', '')
	stringParam('Country', '', '')
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
    python df_redis_owner_update.py
popd
"""
        shell(command)
    }
}
