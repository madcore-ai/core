job('madcore.docker.registry.status') {
    steps {
        def command = """#!/bin/bash
echo $(curl http://myregistry:5000/v1/search?)
"""
        shell(command)
    }
}
