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
echo "Hostname: \$Hostname"
echo "Email: \$Email"
echo "OrganizationName: \$OrganizationName"
echo "OrganizationalUnitName: \$OrganizationalUnitName"
echo "LocalityName: \$LocalityName"
echo "Country: \$Country"

pushd /var/lib/jenkins/workspace/seed-dsl/controlbox/jenkins
    python df_redis_owner_update.py \$Hostname \$Email \$OrganizationName \$OrganizationalUnitName \$LocalityName \$Country
popd
"""
        shell(command)
    }
}
