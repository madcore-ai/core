from __future__ import print_function

import glob
import os
import re
import json
import argparse
from jinja2 import Environment
from collections import OrderedDict
from pprint import pprint

JOBS_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../')
os.chdir(JOBS_PATH)

JOBS_TEMPLATE = """
====== Jenkins Job List ======
Madcore List of Jenkins DSL Jobs
{% for job_type, job_list in jobs_data.iteritems() %}
^{{ job_type }}^description^
{% for job_name in job_list %}|{{job_name}}| |
{% endfor %}
{% endfor %}
"""

JOBS_TEMPLATE_PARAMS = """
{% for job in jobs_data.job %}
==== {{job.name }} ====
<progress>
<bar showvalue="true" value="100" type="success">{{job.name }}</bar>
</progress>

{% for label in job.labels %}<label type="primary">{{label}}</label>
{% endfor %}
<list-group>
{% if job.params %}
{% for param in job.params %}  * {{param.name}}
{% endfor %}
{% endif %}
</list-group>
{% endfor %}
"""

JOBS_TEMPLATE_PARAMS1 = """
==== madcore.registration ====
<progress>
<bar showvalue="true" value="100" type="success">madcore.registration</bar>
</progress>
<label type="primary">pipeline</label>
<list-group>
  * Hostname
  * Email
  * OrganizationName
  * OrganizationalUnitName
  * LocalityName
  * Country
</list-group>
"""

# JOB_NAMES = ['madcore.schedule', 'madcore.registration']
SKIP_JOB_NAMES = ['123madcore']
JOB_NAMES = []


def to_process_job(job_name):
    for js in SKIP_JOB_NAMES:
        if js in job_name:
            return False

    if not JOB_NAMES:
        return True

    for j in JOB_NAMES:
        if j in job_name:
            return True

    return False


def parse_args():
    """
    Parse arguments for input params
    """

    parser = argparse.ArgumentParser(prog="Jenkins Scheduler Generator")

    parser.add_argument('-o', '--output', required=True, choices=['json', 'doku'],
                        help='Json input with scheduler data')

    return parser.parse_args()


def parse():
    jobs = OrderedDict([
        ('pipelineJob', []),
        ('job', []),
    ])
    for pattern in ["*.groovy", "**/*.groovy"]:
        for job_file in glob.glob(pattern):
            group_folder = os.path.dirname(job_file) or 'core'
            with open(os.path.join(JOBS_PATH, job_file)) as f:
                data = f.read()
                for j in jobs.keys():
                    o = re.search('%s\(\'(.+?)\'\)' % j, data)
                    if o:
                        job_name = o.group(1)
                        if not to_process_job(job_name):
                            print("Skip job ", job_name)
                            continue

                        item = {"name": job_name, "labels": [j, group_folder], "params": {}}

                        params_text = re.search('.+?parameters.+?(\{.*?\})', data, re.MULTILINE | re.DOTALL)
                        if params_text:
                            params_text = params_text.group(1)
                            reg = '[a-z]+Param\(\'(?P<name>.+?)\'\s*\,\s*\'?(?P<default>.*?)\'?\s*,\s*\'(?P<desc>.*?)\'\)'
                            params = [m.groupdict() for m in re.finditer(reg, params_text, re.MULTILINE | re.DOTALL)]
                            item['params'] = params

                        jobs[j].append(item)
                        break

    jobs['job'] += jobs['pipelineJob']

    return jobs


def render(cfg, jobs_data, template=JOBS_TEMPLATE):
    if cfg.output in ['json']:
        r = json.dumps(jobs_data, indent=4, ensure_ascii=False)
    else:
        r = Environment().from_string(template).render(jobs_data=jobs_data)

    return r


def save_to_file(text):
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'wiki.txt')
    with open(path, 'w') as f:
        f.write(text)


if __name__ == '__main__':
    args = parse_args()
    jobs_data = parse()
    res = render(args, jobs_data, JOBS_TEMPLATE_PARAMS)
    save_to_file(res)
