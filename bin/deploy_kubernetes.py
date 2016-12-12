from __future__ import print_function
import os, sys, jinja2, redis, json, pycurl
from jinja2 import Template
from StringIO import StringIO
from utils import run_cmd

##### variables
job_name = 'df.deploy.kubernetes'
appname = sys.argv[2]
workspace = '/var/lib/jenkins/workspace/' + job_name + "/" + appname + "/"
repo_path = workspace + 'repo/'
repo_url = sys.argv[1]
kub_config_path = workspace + 'kube_config/'
registry_user = 'root'
registry_pass = 'madcore'
registry_secret = 'myregistrykey'
app_port = sys.argv[3]
branch_name = sys.argv[4]


##### clone repository
run_cmd("git clone -b %s %s %s" % (branch_name, repo_url, repo_path))

##### Crete image 

run_cmd("docker build -t %s %s" % (appname, repo_path))

#### Push image to local docker registry

run_cmd("docker tag %s localhost:5000/%s:image" % (appname, appname))
run_cmd("docker login -u%s -p%s localhost:5000" % (registry_user, registry_pass))
run_cmd("docker push localhost:5000/%s:image" % appname)

#### Crete kubernetes pods and service
run_cmd("mkdir -p %s" % kub_config_path)
run_cmd(
    "kubectl create secret docker-registry %s --docker-server=localhost:5000 --docker-username=%s --docker-password=%s --docker-email=test@test.com" % (
    registry_secret, registry_user, registry_pass))

config_template = open('/opt/madcore/bin/templates/kub_replication_controller_template.yaml').read()
template = Template(config_template)
config = (template.render(name=appname, image=appname + ':image', registry_secret=registry_secret, namespace='default'))
open(kub_config_path + 'rc.yaml', "w").write(config)

config_template2 = open('/opt/madcore/bin/templates/kub_service_template.yaml').read()
template2 = Template(config_template2)
config2 = (template2.render(name=appname, port=app_port, rc_name=appname, namespace='default'))
open(kub_config_path + 'svc.yaml', "w").write(config2)

run_cmd("kubectl create -f %s" % kub_config_path)
