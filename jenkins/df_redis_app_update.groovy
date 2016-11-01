job('df.redis.app.update') {
    wrappers { preBuildCleanup() }
    parameters {
	stringParam('APP_NAME', '', '')
	stringParam('APP_PORT', '', '')
    }
    steps {
        def command = """#!/bin/bash
echo "APP_NAME: '\$APP_NAME'"
echo "APP_PORT: '\$APP_PORT'"

    python /opt/controlbox/bin/redis_app_update.py "\$APP_NAME" "\$APP_PORT"
"""
        shell(command)
    }
}
