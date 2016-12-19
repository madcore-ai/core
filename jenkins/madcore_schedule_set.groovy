job('madcore.schedule.set') {
    parameters {
        stringParam('Name', 'test', '')
        stringParam('Region', 'eu-west-1', '')
        stringParam('Monday', '100000000001111110000000', '')
        stringParam('Tuesday', '000000000001111110000000', '')
        stringParam('Wednesday', '000000000000000000001111', '')
        stringParam('Thursday', '111111000000000000000000', '')
        stringParam('Friday', '000000000000000000000000', '')
        stringParam('Saturday', '000000000000000000000000', '')
        stringParam('Sunday', '000000000000000000000001', '')
        stringParam('InstanceList', 'i-39dc50dd', '')
        booleanParam('IsEnabled', true, '')
    }
    steps {
        def command = """#!/bin/bash
python /opt/madcore/bin/schgen.py --json "{\\"enabled\\":\$IsEnabled, \\"name\\":\\"\$Name\\", \\"region\\":\\"\$Region\\", \\"instances_list\\":\\"\$InstanceList\\", \\"s_mo\\":\\"\$Monday\\", \\"s_tu\\": \\"\$Tuesday\\", \\"s_we\\": \\"\$Wednesday\\", \\"s_th\\": \\"\$Thursday\\", \\"s_fr\\": \\"\$Friday\\",\\"s_sa\\": \\"\$Saturday\\",\\"s_su\\": \\"\$Sunday\\"}" -d
"""
        shell(command)
    }
    publishers {
        downstream('madcore.scheduler.seed', 'SUCCESS')
    }
}
