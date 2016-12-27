job('madcore.habitat.delete') {
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/habitat
    bash delete.sh
popd
"""
        shell(command)
    }
}
