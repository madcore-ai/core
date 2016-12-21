job('madcore.docker.registry.status') {
    steps {
        def command = """#!/bin/bash
echo \$(curl -k https://root:madcore@localhost:5000/v2/_catalog)
"""
        shell(command)
    }
}
