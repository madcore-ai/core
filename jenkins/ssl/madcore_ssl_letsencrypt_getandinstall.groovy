job('madcore.ssl.letsencrypt.getandinstall') {

    steps {
        def command = """#!/bin/bash
	sudo /opt/madcore/bin/haproxy_get_ssl.py
"""
        shell(command)
    }
}
