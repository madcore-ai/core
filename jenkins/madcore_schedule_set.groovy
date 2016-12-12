job('madcore.schedule.set') {
    parameters {
		stringParam('SchedulerData', '{"name": "test", "region": "eu-west-1", "instances_list": ["i-39dc50dd"], "s_mo": "100000000001111110000000", "s_tu": "000000000001111110000000", "s_we": "000000000000000000001111", "s_th": "111111000000000000000000", "s_fr": "000000000000000000000000", "s_sa": "000000000000000000000000", "s_su": "000000000000000000000001"}', '')
    }
    triggers {
        cron("@hourly")
    }
    steps {
        def command = """#!/bin/bash
echo "SchedulerData: '\$SchedulerData'"
python /opt/madcore/bin/schgen.py --json "\$SchedulerData" -d
"""
        shell(command)
    }
    publishers {
        downstream('madcore.scheduler.seed', 'SUCCESS')
    }
}
