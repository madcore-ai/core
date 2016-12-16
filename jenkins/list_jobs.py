from __future__ import print_function

import glob
import os
import re
import json
import argparse
import jinja2
from jinja2 import Environment
from collections import OrderedDict

JOBS_PATH = './'

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
    for job_file in glob.glob("*.groovy"):
        with open(os.path.join(JOBS_PATH, job_file)) as f:
            data = f.read()
            for j in jobs.keys():
                o = re.search('%s\(\'(.+?)\'\)' % j, data)
                if o:
                    jobs[j].append(o.group(1))
                    break

    return jobs


def render(cfg, jobs_data):
    r = None

    if cfg.output in ['json']:
        r = json.dumps(jobs_data, indent=4, ensure_ascii=False)
    else:
        r = Environment().from_string(JOBS_TEMPLATE).render(jobs_data=jobs_data)

    print(r)

if __name__ == '__main__':
    args = parse_args()
    jobs_data = parse()
    render(args, jobs_data)
