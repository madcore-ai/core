job('madcore.habitat.reinstall') {
    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/habitat
    bash reinstall.sh
popd
"""
        shell(command)
    }
}
