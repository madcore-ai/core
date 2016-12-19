job('madcore.schedule.{{name}}.stop') {
    description('This MadCore job was auto generated based on your Schedule setting in the app. WARNING: any changes will be overridden when dls-seed job is rerun.')
    disabled({{disabled}})
    triggers {
        def schedule = """{% for x in cycles.scheds_all %}
{{ x }}{% endfor %}"""
        cron(schedule)
    }
    steps {
        def command = """#!/bin/bash
python /opt/madcore/bin/instance.py -r {{region}} -il {{instances_list}} -a stop
"""
        shell(command)
    }
}
