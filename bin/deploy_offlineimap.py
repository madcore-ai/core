from __future__ import print_function
from jinja2 import Template
from utils import run_cmd
from consts import *

# variables
job_name = 'df.deploy.offlineimap'
app_name = 'offlineimap'
workspace = '/var/lib/jenkins/workspace/' + job_name + "/" + app_name + "/"
repo_path = 'https://raw.githubusercontent.com/styk-tv/offlineimap/docker/Dockerfile'
kub_config_path = workspace + 'kube_config/'

# Crete image
run_cmd("docker build -t %s %s" % (app_name, repo_path))
# Push image to local docker registry
run_cmd("docker tag {0} {1}/{1}:image".format(docker_server, app_name))
run_cmd("docker login -u{0} -p{1} {2}".format(registry_user, registry_pass, docker_server))
run_cmd("docker push {0}/{1}:image".format(docker_server, app_name))

# Crete kubernetes pods and service
run_cmd("mkdir -p %s" % kub_config_path)
run_cmd("kubectl create secret docker-registry {0} --docker-server={1} --docker-username={2} --docker-password={3} "
        "--docker-email=test@test.com".format(registry_secret, docker_server, registry_user, registry_pass))

config_template = open('/opt/controlbox/bin/templates/kub_replication_controller_template_with_volume.yaml').read()
template = Template(config_template)
config = (template.render(name=app_name, image=app_name + ':image', registry_secret=registry_secret))
open(kub_config_path + 'rc.yaml', "w").write(config)

# config_template2 = open('/opt/controlbox/bin/templates/kub_service_template.yaml').read()
# template2 = Template(config_template2)
# config2 = (template2.render(name=app_name, port=app_port, rc_name=app_name))
# open(kub_config_path + 'svc.yaml', "w").write(config2)

run_cmd("kubectl create -f %s" % kub_config_path)
