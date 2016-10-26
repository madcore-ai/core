job('df.redis.app.update') {
    wrappers { preBuildCleanup() }
    parameters {
	stringParam('APPNAME', '', '')
    }
    steps {
        def command = """#!/bin/bash
echo "APPNAME: '\$APPNAME'"

    python /opt/controlbox/bin/redis_app_update.py "\$APPNAME"
"""
        shell(command)
    }
}
