job('madcore.habitat.registry.setup') {
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/habitat/registry
    bash setup.sh
popd
"""
        shell(command)
    }
}
