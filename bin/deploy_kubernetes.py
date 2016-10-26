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
registry_user='peter'
registry_pass='redhat'
registry_secret='myregistrykey'
app_port=sys.argv[3]


##### clone repository
os.system("git clone %s %s" % (repo_url, repo_path))

##### Crete image 

os.system("docker build -t %s %s" % (appname, repo_path))

#### Push image to local docker registry

os.system("docker tag %s localhost:5000/%s" % (appname, appname))
os.system("docker login -u%s -p%s localhost:5000" % (registry_user, registry_pass))
os.system("docker push localhost:5000/%s" % appname)

#### Crete kubernetes pods and service
os.system("mkdir -p %s" % kub_config_path)
os.system("kubectl create secret docker-registry %s --docker-server=localhost:5000 --docker-username=%s --docker-password=%s --docker-email=test@test.com" % (registry_secret, registry_user, registry_pass))

config_template=open('/opt/controlbox/bin/templates/kub_replication_controller_template.yaml').read()
template = Template(config_template)
config = (template.render(name=appname, image=appname, registry_secret=registry_secret))
open(kub_config_path+'rc.yaml', "w").write(config)

config_template2=open('/opt/controlbox/bin/templates/kub_service_template.yaml').read()
template2 = Template(config_template2)
config2 = (template2.render(name=appname, port=app_port, rc_name=appname))
open(kub_config_path+'svc.yaml', "w").write(config2)

os.system("kubectl create -f %s" % kub_config_path)

#### write app key to redis
r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "apps"

i_data='{"apps":["%s"]}' % (appname)
r_server.set(i_key,i_data)
r_server.bgsave

#### regenerate CSR and get new cert
os.system("python /opt/controlbox/bin/controlbox_csr_generate.py %s" % appname)
os.system("sudo /opt/controlbox/bin/haproxy_get_ssl.py")

















