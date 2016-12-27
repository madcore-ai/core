job('madcore.habitat.registry.setup') {
    parameters {
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/habitat/registry
    bash setup.sh
popd
"""
        shell(command)
    }
}
