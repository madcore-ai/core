from __future__ import print_function
from utils import run_cmd, j2_render, get_pod, copy_file_to_pod, execute_cmd_on_pod, wait_until_pod_is_ready
from consts import *
import sys
import time

REMOTE_USER = sys.argv[1]
OAUTH2_CLIENT_ID = sys.argv[2]
OAUTH2_CLIENT_SECRET = sys.argv[3]
OAUTH2_REFRESH_TOKEN = sys.argv[4]
APP_NAME = sys.argv[5]

# variables
job_name = 'madcore.deploy.offlineimap'
app_name = APP_NAME
workspace = '/var/lib/jenkins/workspace/' + job_name + "/" + app_name + "/"
repo_path = workspace + 'repo/'
docker_file = 'https://raw.githubusercontent.com/styk-tv/offlineimap/docker/Dockerfile'
# docker_file = '/opt/madcore/bin/templates/Dockerfile'
kub_config_path = workspace + 'kube_config/'
registry_secret = 'keyofflineimap'
volume_mount_path = '/offlineimap_data'
volume_host_path = '/opt/offlineimap_data'
offlineimap_config_path = '/tmp/offlineimaprc'
namespace = APP_NAME
port = 1234

run_cmd("mkdir -p %s" % repo_path)
# get docker file locally
if docker_file.startswith('http'):
    run_cmd('wget -O {0}Dockerfile {1}'.format(repo_path, docker_file))
else:
    run_cmd('cp {0} {1}'.format(docker_file, repo_path))

# Crete image
run_cmd("docker build -t {0} {1}".format(app_name, repo_path))
# Push image to local docker registry
run_cmd("docker tag {0} {1}/{0}:image".format(app_name, docker_server))
run_cmd("docker login -u{0} -p{1} {2}".format(registry_user, registry_pass, docker_server))
run_cmd("docker push {0}/{1}:image".format(docker_server, app_name))

# Crete kubernetes pods and service
run_cmd("mkdir -p %s" % kub_config_path)
run_cmd("kubectl create secret docker-registry {0} --docker-server={1} --docker-username={2} --docker-password={3} "
        "--docker-email=test@test.com".format(registry_secret, docker_server, registry_user, registry_pass))

data_ns = {
    'namespace': namespace
}
j2_render('/opt/madcore/bin/templates/offlineimap-namespace.yaml', kub_config_path + 'ns.yaml', data_ns)

data_rc = {
    'name': app_name,
    'image': app_name + ':image',
    'registry_secret': registry_secret,
    'docker_server': docker_server,
    'namespace': namespace,
    'volume_mount_path': volume_mount_path,
    'volume_host_path': volume_host_path
}
j2_render('/opt/madcore/bin/templates/kub_replication_controller_template_with_volume.yaml',
          kub_config_path + 'rc.yaml', data_rc)

data_srv = {
    'name': app_name,
    'port': port,
    'rc_name': app_name,
    'namespace': namespace
}
j2_render('/opt/madcore/bin/templates/offlineimap_kub_service_template.yaml', kub_config_path + 'svc.yaml', data_srv)

print(run_cmd("kubectl create -f %s" % kub_config_path))

wait_until_pod_is_ready(namespace)

# render offlineimap config file
data_conf = {
    'remote_user': REMOTE_USER,
    'oauth2_client_id': OAUTH2_CLIENT_ID,
    'oauth2_client_secret': OAUTH2_CLIENT_SECRET,
    'oauth2_refresh_token': OAUTH2_REFRESH_TOKEN,
    'volume_mount_path': volume_mount_path,
}

j2_render('/opt/madcore/bin/templates/offlineimap_config.j2', offlineimap_config_path, data_conf)
pod_name = get_pod(app_name, namespace, wait_until_created=True)
copy_file_to_pod(pod_name, offlineimap_config_path, '~/.offlineimaprc', namespace)
print(execute_cmd_on_pod(pod_name, 'offlineimap', namespace))
# TODO get the progress of email downloaded and upload to Graphana via influxDB

time.sleep(10)
print(run_cmd("kubectl delete -f %s" % kub_config_path))
