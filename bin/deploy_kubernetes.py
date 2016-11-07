import os, sys, jinja2, redis, json, pycurl
from jinja2 import Template
from StringIO import StringIO
##### variables
job_name='df.deploy.kubernetes'
appname=sys.argv[2]
workspace = '/var/lib/jenkins/workspace/' + job_name + "/" + appname + "/"
repo_path = workspace + 'repo/'
repo_url = sys.argv[1]
kub_config_path = workspace + 'kube_config/'
registry_user='root'
registry_pass='controlbox'
registry_secret='myregistrykey'
app_port=sys.argv[3]


##### clone repository
os.system("git clone %s %s" % (repo_url, repo_path))

##### Crete image 

os.system("docker build -t %s %s" % (appname, repo_path))

#### Push image to local docker registry

os.system("docker tag %s localhost:5000/%s:image" % (appname, appname))
os.system("docker login -u%s -p%s localhost:5000" % (registry_user, registry_pass))
os.system("docker push localhost:5000/%s:image" % appname)

#### Crete kubernetes pods and service
os.system("mkdir -p %s" % kub_config_path)
os.system("kubectl create secret docker-registry %s --docker-server=localhost:5000 --docker-username=%s --docker-password=%s --docker-email=test@test.com" % (registry_secret, registry_user, registry_pass))

config_template=open('/opt/controlbox/bin/templates/kub_replication_controller_template.yaml').read()
template = Template(config_template)
config = (template.render(name=appname, image=appname+':image', registry_secret=registry_secret))
open(kub_config_path+'rc.yaml', "w").write(config)

config_template2=open('/opt/controlbox/bin/templates/kub_service_template.yaml').read()
template2 = Template(config_template2)
config2 = (template2.render(name=appname, port=app_port, rc_name=appname))
open(kub_config_path+'svc.yaml', "w").write(config2)

os.system("kubectl create -f %s" % kub_config_path)
















