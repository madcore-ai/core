job('madcore.docker.registry.status') {
    steps {
        def command = """#!/bin/bash
docker login -uroot -pmadcore localhost:5000/
echo $(curl http://myregistry:5000/v1/search?)
"""
        shell(command)
    }
}
