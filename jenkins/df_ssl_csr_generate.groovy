job('df.ssl.csr.generate') {
    steps {
        def command = """#!/bin/bash
    python /opt/controlbox/bin/controlbox_csr_generate.py
"""
        shell(command)
    }
}
