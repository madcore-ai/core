job('madcore.habitat.delete') {
    parameters {
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/habitat
    bash delete.sh
popd
"""
        shell(command)
    }
}
