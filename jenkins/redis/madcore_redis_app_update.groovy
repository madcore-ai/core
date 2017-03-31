job('madcore.redis.app.update') {
    wrappers { preBuildCleanup() }
    parameters {
	stringParam('APP_NAME', '', '')
	stringParam('SERVICE_PORT', '', '')
  stringParam('APP_NAMESPACE', '', '')
	stringParam('APP_SERVICE_NAME', '', '')
    }
    steps {
        def command = """#!/bin/bash
    python /opt/madcore/bin/redis_app_update.py "params.APP_NAME" "params.SERVICE_PORT" "params.APP_NAMESPACE" "params.APP_SERVICE_NAME"
"""
        shell(command)
    }
}
