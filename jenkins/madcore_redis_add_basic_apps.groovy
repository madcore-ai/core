job('madcore.redis.add.basic.apps') {
    wrappers { preBuildCleanup() }
    steps {
        def command = """#!/bin/bash
    python /opt/madcore/bin/redis_add_basic_apps.py
"""
        shell(command)
    }
}
