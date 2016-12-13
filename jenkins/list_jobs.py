from __future__ import print_function

import glob
import os
import re
import json

JOBS_PATH = './'

os.chdir(JOBS_PATH)

jobs = {
    'job': [],
    'pipelineJob': []
}

for job_file in glob.glob("*.groovy"):
    with open(os.path.join(JOBS_PATH, job_file)) as f:
        data = f.read()
        for j in jobs.keys():
            o = re.search('%s\(\'(.+?)\'\)' % j, data)
            if o:
                jobs[j].append(o.group(1))
                break

print(json.dumps(jobs, indent=4))
