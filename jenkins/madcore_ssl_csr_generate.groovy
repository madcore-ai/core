job('madcore.ssl.csr.generate') {
    steps {
        def command = """#!/bin/bash
    python /opt/madcore/bin/madcore_csr_generate.py
"""
        shell(command)
    }
}
