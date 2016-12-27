job('madcore.habitat.install') {
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/habitat
    bash install.sh
popd
"""
        shell(command)
    }
}
